#!/usr/bin/env bash
# Release automation for بده‌بستان (BedeBestan).
#
# Bumps the app version (single source of truth: apps/bedeh_bestan/pubspec.yaml),
# regenerates the CHANGELOG from git history, syncs store/LISTING.md, runs an
# optional verify gate, builds the requested artifacts, copies them to
# store/builds/ (gitignored), then commits and tags the release.
#
# Usage:
#   store/release.sh [options]
#
# Version selection (pick one; default: --bump patch):
#   --version X.Y.Z     Set an explicit version name (e.g. 1.0.1)
#   --bump patch|minor|major
#   --build N           Explicit build number (default: current build + 1)
#
# Build targets (if none given, defaults to --apk --aab):
#   --apk               Build release APK (Cafe Bazaar / Myket)
#   --aab               Build release App Bundle (Google Play)
#   --web               Build release web bundle
#   --all               Build apk + aab + web
#   --no-build          Skip building (only bump + changelog + commit + tag)
#
# Flow control:
#   --no-verify         Skip `flutter analyze` + `flutter test`
#   --no-tag            Skip the git commit + tag step
#   --allow-dirty       Proceed even if the working tree has other changes
#   --push              Push the release commit and tag to origin
#   --dry-run           Print what would happen; change nothing
#   -h, --help          Show this help
set -euo pipefail

# ---------------------------------------------------------------------------
# Paths & constants
# ---------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
APP_DIR="$ROOT/apps/bedeh_bestan"
PUBSPEC="$APP_DIR/pubspec.yaml"
CHANGELOG="$ROOT/CHANGELOG.md"
LISTING="$ROOT/store/LISTING.md"
BUILDS_DIR="$ROOT/store/builds"
FLUTTER="${FLUTTER:-flutter}"

# ---------------------------------------------------------------------------
# Pretty output
# ---------------------------------------------------------------------------
if [[ -t 1 ]]; then
  BOLD="$(printf '\033[1m')"; DIM="$(printf '\033[2m')"; RED="$(printf '\033[31m')"
  GRN="$(printf '\033[32m')"; YLW="$(printf '\033[33m')"; BLU="$(printf '\033[34m')"
  RST="$(printf '\033[0m')"
else
  BOLD=""; DIM=""; RED=""; GRN=""; YLW=""; BLU=""; RST=""
fi
step() { printf '%s==>%s %s\n' "$BLU$BOLD" "$RST" "$*"; }
info() { printf '    %s\n' "$*"; }
warn() { printf '%s!! %s%s\n' "$YLW" "$*" "$RST" >&2; }
die()  { printf '%sxx %s%s\n' "$RED" "$*" "$RST" >&2; exit 1; }
ok()   { printf '%s✓ %s%s\n'  "$GRN" "$*" "$RST"; }

# ---------------------------------------------------------------------------
# Args
# ---------------------------------------------------------------------------
BUMP="patch"; VERSION=""; BUILD_NUM=""
DO_APK=0; DO_AAB=0; DO_WEB=0; DO_BUILD=1
VERIFY=1; DO_TAG=1; ALLOW_DIRTY=0; PUSH=0; DRY_RUN=0
usage() { sed -n '2,40p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --version)   VERSION="${2:?}"; shift 2;;
    --bump)      BUMP="${2:?}"; shift 2;;
    --build)     BUILD_NUM="${2:?}"; shift 2;;
    --apk)       DO_APK=1; shift;;
    --aab)       DO_AAB=1; shift;;
    --web)       DO_WEB=1; shift;;
    --all)       DO_APK=1; DO_AAB=1; DO_WEB=1; shift;;
    --no-build)  DO_BUILD=0; shift;;
    --no-verify) VERIFY=0; shift;;
    --no-tag)    DO_TAG=0; shift;;
    --allow-dirty) ALLOW_DIRTY=1; shift;;
    --push)      PUSH=1; shift;;
    --dry-run)   DRY_RUN=1; shift;;
    -h|--help)   usage;;
    *) die "Unknown option: $1 (see --help)";;
  esac
done

# Default build targets: the two store artifacts.
if [[ $DO_BUILD -eq 1 && $DO_APK -eq 0 && $DO_AAB -eq 0 && $DO_WEB -eq 0 ]]; then
  DO_APK=1; DO_AAB=1
fi

run() {
  if [[ $DRY_RUN -eq 1 ]]; then
    printf '%s[dry-run]%s %s\n' "$DIM" "$RST" "$*"
  else
    eval "$@"
  fi
}

# ---------------------------------------------------------------------------
# 0. Sanity checks
# ---------------------------------------------------------------------------
[[ -f "$PUBSPEC" ]] || die "Cannot find $PUBSPEC"
command -v git >/dev/null || die "git not found"
command -v "$FLUTTER" >/dev/null || die "flutter not found (set FLUTTER=path)"
cd "$ROOT"

# ---------------------------------------------------------------------------
# 1. Compute versions
# ---------------------------------------------------------------------------
CUR_LINE="$(grep -E '^version:' "$PUBSPEC" | head -1)"
CUR_FULL="${CUR_LINE#version:}"; CUR_FULL="$(echo "$CUR_FULL" | tr -d '[:space:]')"
CUR_NAME="${CUR_FULL%%+*}"
CUR_BUILD="${CUR_FULL##*+}"
[[ "$CUR_FULL" == *+* ]] || CUR_BUILD=0
[[ "$CUR_BUILD" =~ ^[0-9]+$ ]] || die "Cannot parse build number from '$CUR_FULL'"

if [[ -z "$VERSION" ]]; then
  IFS='.' read -r MAJ MIN PAT <<<"$CUR_NAME"
  [[ "$MAJ" =~ ^[0-9]+$ && "$MIN" =~ ^[0-9]+$ && "$PAT" =~ ^[0-9]+$ ]] \
    || die "Cannot parse semver from '$CUR_NAME'"
  case "$BUMP" in
    major) MAJ=$((MAJ+1)); MIN=0; PAT=0;;
    minor) MIN=$((MIN+1)); PAT=0;;
    patch) PAT=$((PAT+1));;
    *) die "--bump must be patch|minor|major";;
  esac
  VERSION="$MAJ.$MIN.$PAT"
fi
[[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || die "Version must be X.Y.Z, got '$VERSION'"

NEW_BUILD="${BUILD_NUM:-$((CUR_BUILD+1))}"
[[ "$NEW_BUILD" =~ ^[0-9]+$ ]] || die "Build number must be an integer"
(( NEW_BUILD > CUR_BUILD )) || warn "New build ($NEW_BUILD) not greater than current ($CUR_BUILD); stores will reject it."
NEW_FULL="$VERSION+$NEW_BUILD"
TAG="v$VERSION"

step "Release plan"
info "current : $CUR_FULL"
info "new     : ${BOLD}$NEW_FULL${RST}   tag ${BOLD}$TAG${RST}"
targets=""
[[ $DO_APK -eq 1 ]] && targets+=" apk"
[[ $DO_AAB -eq 1 ]] && targets+=" aab"
[[ $DO_WEB -eq 1 ]] && targets+=" web"
[[ $DO_BUILD -eq 0 ]] && targets=" (none)"
info "build   :${targets:-" (none)"}"
info "verify  : $([[ $VERIFY -eq 1 ]] && echo yes || echo no)   tag/commit: $([[ $DO_TAG -eq 1 ]] && echo yes || echo no)   push: $([[ $PUSH -eq 1 ]] && echo yes || echo no)"

if git rev-parse "$TAG" >/dev/null 2>&1; then
  die "Tag $TAG already exists."
fi

# ---------------------------------------------------------------------------
# 2. Working tree check
# ---------------------------------------------------------------------------
if [[ -n "$(git status --porcelain)" ]]; then
  if [[ $ALLOW_DIRTY -eq 1 ]]; then
    warn "Working tree is dirty; only release files will be staged for the commit."
  else
    warn "Working tree has uncommitted changes."
    warn "Re-run with --allow-dirty to proceed (only release files get committed),"
    die  "or commit/stash your work first."
  fi
fi

# ---------------------------------------------------------------------------
# 3. Verify gate
# ---------------------------------------------------------------------------
if [[ $VERIFY -eq 1 ]]; then
  step "Verify: flutter analyze + test"
  run "(cd '$APP_DIR' && '$FLUTTER' pub get)"
  run "(cd '$APP_DIR' && '$FLUTTER' analyze)"
  run "(cd '$APP_DIR' && '$FLUTTER' test)"
  ok "verify passed"
else
  warn "Skipping verify gate (--no-verify)"
fi

# ---------------------------------------------------------------------------
# 4. Bump pubspec
# ---------------------------------------------------------------------------
step "Bump version -> $NEW_FULL"
if [[ $DRY_RUN -eq 1 ]]; then
  info "[dry-run] set 'version: $NEW_FULL' in $PUBSPEC"
else
  # Portable in-place edit (GNU/BSD sed differ on -i).
  tmp="$(mktemp)"; sed -E "s/^version:.*/version: $NEW_FULL/" "$PUBSPEC" >"$tmp" && mv "$tmp" "$PUBSPEC"
  ok "pubspec.yaml -> version: $NEW_FULL"
fi

# ---------------------------------------------------------------------------
# 5. Sync store/LISTING.md
# ---------------------------------------------------------------------------
if [[ -f "$LISTING" ]]; then
  step "Sync store/LISTING.md"
  if [[ $DRY_RUN -eq 1 ]]; then
    info "[dry-run] Version **$VERSION** (build $NEW_BUILD)"
  else
    tmp="$(mktemp)"
    sed -E "s/Version \*\*[0-9]+\.[0-9]+\.[0-9]+\*\* \(build [0-9]+\)/Version **$VERSION** (build $NEW_BUILD)/" \
      "$LISTING" >"$tmp" && mv "$tmp" "$LISTING"
    ok "LISTING.md -> Version **$VERSION** (build $NEW_BUILD)"
  fi
fi

# ---------------------------------------------------------------------------
# 6. Changelog (Keep a Changelog style, grouped by conventional-commit type)
# ---------------------------------------------------------------------------
step "Update CHANGELOG.md"
LAST_TAG="$(git describe --tags --abbrev=0 2>/dev/null || true)"
if [[ -n "$LAST_TAG" ]]; then RANGE="$LAST_TAG..HEAD"; info "since $LAST_TAG"; else RANGE=""; info "no prior tag; using full history"; fi

collect() { # $1 = grep regex for the conventional prefix
  git log $RANGE --no-merges --pretty=format:'%s' 2>/dev/null \
    | grep -E "$1" \
    | grep -viE '^(chore\(release\)|release)' \
    | sed -E 's/^[a-z]+(\([^)]*\))?(!)?: //' \
    | sed -E 's/^/- /' || true
}
ADDED="$(collect '^feat(\(|!|:)')"
FIXED="$(collect '^fix(\(|!|:)')"
CHANGED="$(git log $RANGE --no-merges --pretty=format:'%s' 2>/dev/null \
  | grep -viE '^(feat|fix)(\(|!|:)' \
  | grep -viE '^(chore\(release\)|release|chore:|docs:|test:|ci:|build:|style:|refactor:)' \
  | sed -E 's/^[a-z]+(\([^)]*\))?(!)?: //' | sed -E 's/^/- /' || true)"

TODAY="$(date +%Y-%m-%d)"
section="## [$VERSION] - $TODAY"$'\n'
[[ -n "$ADDED"   ]] && section+=$'\n'"### Added"$'\n'"$ADDED"$'\n'
[[ -n "$FIXED"   ]] && section+=$'\n'"### Fixed"$'\n'"$FIXED"$'\n'
[[ -n "$CHANGED" ]] && section+=$'\n'"### Changed"$'\n'"$CHANGED"$'\n'
[[ -z "$ADDED$FIXED$CHANGED" ]] && section+=$'\n'"- Maintenance release."$'\n'

if [[ $DRY_RUN -eq 1 ]]; then
  info "[dry-run] would prepend section:"; printf '%s\n' "$section" | sed 's/^/      /'
else
  if [[ ! -f "$CHANGELOG" ]]; then
    printf '# Changelog\n\nAll notable changes to this project are documented here.\nFormat loosely follows [Keep a Changelog](https://keepachangelog.com/); this project uses [Semantic Versioning](https://semver.org/).\n\n' >"$CHANGELOG"
  fi
  header="$(sed -n '1,/^$/p' "$CHANGELOG")"
  body="$(sed '1,/^$/d' "$CHANGELOG")"
  { printf '%s\n\n' "$header"; printf '%s\n' "$section"; printf '%s\n' "$body"; } >"$CHANGELOG.tmp"
  mv "$CHANGELOG.tmp" "$CHANGELOG"
  ok "prepended [$VERSION] section"
fi

# ---------------------------------------------------------------------------
# 7. Build artifacts
# ---------------------------------------------------------------------------
if [[ $DO_BUILD -eq 1 ]]; then
  run "mkdir -p '$BUILDS_DIR'"
  APK_OUT="$APP_DIR/build/app/outputs/flutter-apk/app-release.apk"
  AAB_OUT="$APP_DIR/build/app/outputs/bundle/release/app-release.aab"
  if [[ $DO_APK -eq 1 ]]; then
    step "Build APK"
    run "(cd '$APP_DIR' && '$FLUTTER' build apk --release)"
    run "cp '$APK_OUT' '$BUILDS_DIR/bedebestan-$VERSION-$NEW_BUILD.apk'"
    ok "store/builds/bedebestan-$VERSION-$NEW_BUILD.apk"
  fi
  if [[ $DO_AAB -eq 1 ]]; then
    step "Build App Bundle"
    run "(cd '$APP_DIR' && '$FLUTTER' build appbundle --release)"
    run "cp '$AAB_OUT' '$BUILDS_DIR/bedebestan-$VERSION-$NEW_BUILD.aab'"
    ok "store/builds/bedebestan-$VERSION-$NEW_BUILD.aab"
  fi
  if [[ $DO_WEB -eq 1 ]]; then
    step "Build Web"
    run "(cd '$APP_DIR' && '$FLUTTER' build web --release)"
    ok "web bundle at apps/bedeh_bestan/build/web"
  fi
else
  warn "Skipping builds (--no-build)"
fi

# ---------------------------------------------------------------------------
# 8. Commit + tag
# ---------------------------------------------------------------------------
if [[ $DO_TAG -eq 1 ]]; then
  step "Commit + tag $TAG"
  files=("$PUBSPEC" "$CHANGELOG")
  [[ -f "$LISTING" ]] && files+=("$LISTING")
  run "git add ${files[*]}"
  run "git commit -m 'chore(release): $TAG'"
  run "git tag -a '$TAG' -m '$TAG'"
  ok "committed and tagged $TAG"
  if [[ $PUSH -eq 1 ]]; then
    step "Push"
    run "git push origin HEAD"
    run "git push origin '$TAG'"
    ok "pushed commit and tag"
  else
    info "Not pushed. Run: git push origin HEAD && git push origin $TAG"
  fi
else
  warn "Skipping commit + tag (--no-tag)"
fi

step "Done — $NEW_FULL"
[[ $DO_AAB -eq 1 ]] && info "Play (AAB): store/builds/bedebestan-$VERSION-$NEW_BUILD.aab"
[[ $DO_APK -eq 1 ]] && info "Bazaar/Myket (APK): store/builds/bedebestan-$VERSION-$NEW_BUILD.apk"

# Release & Publish — بده‌بستان (BedeBestan)

Runbook for cutting a version and publishing to **Cafe Bazaar**, **Myket**, and **Google Play**.
Package: `com.nickapp.bedebestan`.

## TL;DR

```bash
# Full release: bump version, changelog, tag, build APK+AAB, sign for Bazaar
./store/release.sh --version 1.0.1 --apk --aab --bazaar

# Same, and regenerate phone listing screenshots (light + dark)
./store/release.sh --version 1.0.1 --apk --aab --bazaar --screenshots

# Push the release commit + tag
git push origin HEAD && git push origin v1.0.1
```

Then upload the artifacts from `store/builds/` to each store (see [Publish](#publish)).

---

## How versioning works

The app version is the **single source of truth** in one line:

```
# apps/bedeh_bestan/pubspec.yaml
version: 1.0.1+3
#         └─┬─┘ └┬┘
#           │    └ build number  -> versionCode  (MUST increase every upload)
#           └ version name (semver) -> versionName (what users see)
```

Android reads these automatically (`flutter.versionName` / `flutter.versionCode` in
`android/app/build.gradle.kts`). **Never edit the Android files by hand.**

- **versionName** — bump per [SemVer](https://semver.org/): `patch` for fixes, `minor`
  for features, `major` for breaking changes. Pass only `X.Y.Z` to `--version`
  (never hand-edit `+N` in the release command).
- **versionCode** (`W` in `X.Y.Z+W`) — `release.sh` **always** sets
  `W = previous W + 1`. Do not set it by hand; Cafe Bazaar / Play / Myket reject
  any code that is not strictly higher than the last upload.

The melos sub-packages are `publish_to: none`; only the app version matters for stores.

Also bump **`store/version.json`** (`latestVersion` + `latestBuild` = the `+W`
from pubspec) and push to **`develop`** (or set
`--dart-define=VERSION_MANIFEST_URL=…` to a **public** JSON URL).

On Android, **Settings → Check for updates** prefers **Cafe Bazaar’s** update
service (Bazaar app installed). The GitHub manifest is only a fallback when
Bazaar is not available.

---

## Prerequisites (one time)

- **Flutter** on `PATH` (`flutter doctor` clean for Android).
- **Java (JRE)** for Bazaar's signer.
- **Release keystore** at `apps/bedeh_bestan/android/upload-keystore.jks` with
  `apps/bedeh_bestan/android/key.properties`. Create with `store/create_keystore.sh`.
  > ⚠️ Back up `upload-keystore.jks` + `key.properties`. **Losing them permanently
  > blocks updating every store listing.**
- **Bazaar bundlesigner** jar in `store/` (e.g. `bundlesigner-0.1.13.jar`), downloaded
  from the [Bazaar App Bundle guide](https://developers.cafebazaar.ir/fa/guidelines/feature/app_bundle).
  It is gitignored.

Everything in `store/builds/` is gitignored (artifacts + `.bin` are never committed).

---

## Release (`store/release.sh`)

Bumps the version, runs a verify gate, regenerates the changelog, builds artifacts,
copies them to `store/builds/`, then commits and tags.

```bash
# Preview everything, change nothing:
./store/release.sh --version 1.0.1 --all --dry-run

# Real release (choose targets):
./store/release.sh --version 1.0.1 --apk --aab --bazaar
```

### What it does, in order

1. Compute versions (`--version X.Y.Z` or `--bump patch|minor|major`).
   Build number is always `previous + 1` (never passed on the CLI).
2. Guard against a dirty working tree (`--allow-dirty` stages only release files).
3. Verify gate: `flutter pub get && flutter analyze && flutter test --exclude-tags store`.
   Store screenshots stay off unless you pass `--screenshots`.
4. Bump `pubspec.yaml`; sync the version line in `store/LISTING.md`.
5. Regenerate `CHANGELOG.md` from git history since the last tag.
6. Build the requested artifacts → `store/builds/bedebestan-<ver>-<build>.{apk,aab}`.
7. With `--bazaar`, sign the AAB into `store/builds/bedebestan-<ver>-<build>.bin`
   (genbin's generic `bedebestan-<versionCode>.bin` is renamed so releases do not
   overwrite each other).
8. Commit `chore(release): vX.Y.Z` and create annotated tag `vX.Y.Z`.

### Options

| Flag | Meaning |
|---|---|
| `--version X.Y.Z` | Explicit version name (`+N` is automatic) |
| `--bump patch\|minor\|major` | Bump instead of explicit (default `patch`) |
| `--apk` / `--aab` / `--web` | Pick build targets (default: `apk`+`aab`) |
| `--all` | apk + aab + web |
| `--bazaar` | After the AAB, produce the Bazaar `.bin` |
| `--no-build` | Only bump + changelog + commit + tag |
| `--no-verify` | Skip analyze + test |
| `--no-changelog` | Skip regenerating `CHANGELOG.md` |
| `--screenshots` | Opt-in: regenerate `store/screenshots` (phone, light + dark) |
| `--no-tag` | Skip commit + tag |
| `--allow-dirty` | Proceed on a dirty tree (stages only release files) |
| `--push` | Push commit + tag to origin |
| `--dry-run` | Print actions, change nothing |

After a real run, push:

```bash
git push origin HEAD && git push origin vX.Y.Z
```

---

## Bazaar signing (`store/bazaar_sign.sh`)

Cafe Bazaar's App Bundle flow does **not** accept a raw AAB. After uploading the
`.aab` you must upload an "encrypted" **`.bin`** — a signed digest produced with
**your** keystore. No `.pk8`/`.pem` conversion needed; the tool reads the `.jks`
directly.

```bash
# Sign the newest AAB in store/builds/ (or pass a path):
./store/bazaar_sign.sh store/builds/bedebestan-1.0.1-3.aab
# -> store/builds/bedebestan-1.0.1-3.bin

# If Bazaar requires v3 signing:
V3=true ./store/bazaar_sign.sh store/builds/bedebestan-1.0.1-3.aab
```

Defaults to signing scheme `v2=true, v3=false` (matching Bazaar's own example). The
script reads alias + passwords from `key.properties` and passes them via env vars.
The `.bin` is always named after the AAB stem so each release keeps its own file.

---

## Artifacts

After a build, `store/builds/` contains:

| File | Target |
|---|---|
| `bedebestan-<ver>-<build>.aab` | Google Play (upload) · Cafe Bazaar (upload, then sign) |
| `bedebestan-<ver>-<build>.bin` | Cafe Bazaar (upload after the AAB) |
| `bedebestan-<ver>-<build>.apk` | Myket (and Bazaar if you prefer APK) |
| `apps/bedeh_bestan/build/web` | Web (from `--web`) |

---

## Publish

### Cafe Bazaar
1. Upload the `.aab`.
2. When prompted, upload the matching `.bin` (from `bazaar_sign.sh`).
3. Update the listing from `store/LISTING.md`; attach `store/screenshots/*` and
   `store/promo/*`.

### Myket
Upload the `.apk`; update listing/assets as above.

### Google Play
Upload the `.aab` to a release track. If using Play App Signing, Google manages the
app signing key; your upload key is the keystore above.

Store copy, screenshots, promo art, and the public certificate SHA-256 live in
[`store/LISTING.md`](LISTING.md).

---

## Post-release checklist

- [ ] `store/release.sh` ran clean (analyze + tests passed).
- [ ] `pubspec.yaml` version + build bumped; `CHANGELOG.md` updated.
- [ ] Commit `chore(release): vX.Y.Z` and tag `vX.Y.Z` pushed.
- [ ] Artifacts uploaded to each target store.
- [ ] Bazaar `.bin` uploaded after the AAB.
- [ ] Keystore + `key.properties` backed up.

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
  for features, `major` for breaking changes.
- **versionCode** (`W` in `X.Y.Z+W`) — every store upload needs a strictly higher
  value. `release.sh` picks it like this:
  - same `X.Y.Z` as current (`--version 1.0.4` while already on `1.0.4+2`) → `W+1`
  - new `X.Y.Z` (`--version 1.0.5` or `--bump`) → `W` starts at `1` again
  - override with `--version 1.0.5+4` or `--build 4`
  - if the new `W` is not greater than the current one, the script warns: Bazaar /
    Play / Myket will reject the upload (pass `--build N` with `N` higher)

The melos sub-packages are `publish_to: none`; only the app version matters for stores.

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

1. Compute versions (`--version X.Y.Z[+W]` or `--bump patch|minor|major`).
   Same name increments `W`; a new name starts `W` at 1 (`--build` overrides).
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
| `--version X.Y.Z[+W]` | Explicit version name, optional build |
| `--bump patch\|minor\|major` | Bump instead of explicit (default `patch`) |
| `--build N` | Explicit build number (default: `W+1` on the same name, `1` on a new name) |
| `--apk` / `--aab` / `--web` | Pick build targets (default: `apk`+`aab`) |
| `--all` | apk + aab + web |
| `--bazaar` | After the AAB, produce the Bazaar `.bin` |
| `--no-build` | Only bump + changelog + commit + tag |
| `--no-verify` | Skip analyze + test |
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

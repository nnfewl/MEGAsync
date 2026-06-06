# MEGAsync Fork Pipeline

## Branches

| Branch | Purpose |
|--------|---------|
| `pipeline` | CI/CD scripts, workflows, patches, PKGBUILD — default branch |
| `master` | Pure mirror of upstream `meganz/MEGAsync` master |
| `tray-iconname` | Single commit with theme-native tray icon patch on top of latest upstream tag |

## Key files

- `.github/workflows/release.yml` — full pipeline (detect → sync → build → release → cleanup)
- `scripts/detect-upstream.sh` — finds latest `v*_Linux` tag on upstream
- `scripts/generate-patches.sh` — diffs `tray-iconname` against upstream tag to produce patch 050
- `scripts/cleanup-releases.sh` — keeps 5 most recent releases
- `patches/` — AUR compatibility patches (010, 020, 030); synced from AUR on upstream version bumps
- `PKGBUILD` — local install via `makepkg -si`

## How patches work

- **010–030**: Static AUR patches. When upstream releases a new version, check `https://aur.archlinux.org/packages/megasync` for updated patches and replace files in `patches/`.
- **050**: Generated at build time by `generate-patches.sh` from `tray-iconname` branch diff.

## When upstream releases a new version

CI auto-rebases `tray-iconname` onto the new tag. If rebase fails (conflict), a GitHub issue is opened with manual instructions. Fix:

```bash
eval $(ssh-agent -s) && ssh-add ~/.ssh/github_rsa
git fetch origin
git checkout tray-iconname
# Save patched files
git show HEAD:src/MEGASync/gui/TrayIconManager.cpp > /tmp/TrayIconManager_patched.cpp
git show HEAD:src/MEGASync/CMakeLists.txt > /tmp/CMakeLists_patched.txt
# Reset to new tag
git reset --hard <new-tag>
cp /tmp/TrayIconManager_patched.cpp src/MEGASync/gui/TrayIconManager.cpp
cp /tmp/CMakeLists_patched.txt src/MEGASync/CMakeLists.txt
git add src/MEGASync/gui/TrayIconManager.cpp src/MEGASync/CMakeLists.txt
git commit -m "feat: theme-native tray icons via QIcon::fromTheme"
git push origin tray-iconname --force-with-lease
git checkout pipeline
```

Then re-trigger: `gh workflow run release.yml --repo nnfewl/MEGAsync --ref pipeline -f force_rebuild=true`

## SSH for pushing

```bash
eval $(ssh-agent -s) && ssh-add ~/.ssh/github_rsa
```

## PKGBUILD

`pkgver` must match the latest release version. CI auto-updates it on successful builds.
Install: `makepkg -si` from repo root (default branch is `pipeline`).

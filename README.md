# MEGAsync — Theme-Native Tray Icons (Fork)

Automated fork of [meganz/MEGAsync](https://github.com/meganz/MEGAsync) that patches the Linux tray icon to use `QIcon::fromTheme()`, so GNOME Shell (and other StatusNotifierItem hosts) resolve the icon from your installed theme (Papirus, Tela, etc.) instead of rendering hardcoded pixels.

## How it works

```
detect-upstream → sync-fork → build-arch → release → cleanup
```

1. **Detect**: nightly check for new `v*_Linux` tags on upstream
2. **Sync**: fast-forward fork's `master`, push upstream tags, auto-rebase `tray-iconname`
3. **Build**: Arch Linux container — apply AUR patches + theme patch, cmake build, strip binary
4. **Release**: GitHub release with `megasync-VERSION-arch.tar.zst` install tree
5. **Cleanup**: keep 5 most recent releases

## Patches applied

**AUR compatibility** (build with system packages, no vcpkg):
- `010` — cmake dependency detection for cryptopp/pdfium
- `020` — MEGAUpdateGenerator pkg-config
- `030` — disable ENABLE_ISOLATED_GFX
- `040` — add ICU::i18n link target

**Theme-native tray icons**:
- `050` — `QIcon::fromTheme()` in `TrayIconManager.cpp` (generated from `tray-iconname` branch)

## Install (Arch Linux)

### PKGBUILD

```bash
git clone https://github.com/nnfewl/MEGAsync.git
cd MEGAsync
makepkg -si
```

### Manual

Download `megasync-VERSION-arch.tar.zst` from [Releases](../../releases), then:

```bash
sudo tar -xf megasync-*-arch.tar.zst -C /
```

### Requirements

An icon theme with MEGAsync icons (`megauptodate`, `megasynching`, etc.) — Papirus, Tela, etc.

## Branches

| Branch | Purpose |
|--------|---------|
| `pipeline` | CI/CD scripts and workflows (default) |
| `master` | Pure mirror of upstream master |
| `tray-iconname` | Dev branch with theme icon patches |

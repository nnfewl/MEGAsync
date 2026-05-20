# MEGAsync — Theme-Native Tray Icons (Fork)

Automated fork of [meganz/MEGAsync](https://github.com/meganz/MEGAsync) that patches the Linux tray icon to use `QIcon::fromTheme()`, so GNOME Shell (and other StatusNotifierItem hosts) resolve the icon from your installed theme (Papirus, Tela, etc.) instead of rendering hardcoded pixels.

## How it works

```
detect-upstream → sync-fork → build-arch → release → cleanup
```

1. **Detect**: nightly check for new `v*_Linux` tags on upstream
2. **Sync**: fast-forward fork's `master` + push upstream tags
3. **Build**: Arch Linux container — apply AUR patches + theme patch, cmake build, strip binary
4. **Release**: GitHub release with `megasync_arch` binary
5. **Cleanup**: keep 5 most recent releases

## Patches applied

**AUR compatibility** (build with system packages, no vcpkg):
- `010` — cmake dependency detection for cryptopp/pdfium
- `020` — MEGAUpdateGenerator pkg-config
- `030` — disable ENABLE_ISOLATED_GFX
- `040` — add ICU::i18n link target

**Theme-native tray icons**:
- `050` — `QIcon::fromTheme()` in `TrayIconManager.cpp` (generated from `tray-iconname` branch)

## Install

Download `megasync_arch` from [Releases](../../releases), then:

```bash
sudo cp megasync_arch /usr/bin/megasync
sudo chmod +x /usr/bin/megasync
```

Requires Papirus (or another theme with `megauptodate`, `megasynching`, etc.) installed in your icon theme.

## Branches

| Branch | Purpose |
|--------|---------|
| `pipeline` | CI/CD scripts and workflows (default) |
| `master` | Pure mirror of upstream master |
| `tray-iconname` | Dev branch with theme icon patches |

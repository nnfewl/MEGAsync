pkgname=megasync-bin
pkgver=6.3.0.1
pkgrel=1
pkgdesc='MEGAsync with theme-native tray icons (Papirus/Tela support)'
arch=('x86_64')
url='https://github.com/nnfewl/MEGAsync'
license=('custom')
provides=("megasync=${pkgver%.*}")
conflicts=('megasync'
           'megatools')
depends=('glibc>=2.33'
         'gcc-libs>=10.2.0'
         'qt5-base>=5.15'
         'qt5-svg'
         'qt5-x11extras'
         'qt5-graphicaleffects'
         'qt5-declarative'
         'qt5-quickcontrols2'
         'qt5-quickcontrols')
optdepends=('xdg-desktop-portal: follow the desktop color scheme (using dbus)'
            'glib2: follow the desktop color scheme (using gsettings)')
_upstream_ver="${pkgver%.*}"
_upstream_rel="${pkgver##*.}"
source=("megasync-official.pkg.tar.zst::https://mega.nz/linux/repo/Arch_Extra/x86_64/megasync-${_upstream_ver}-${_upstream_rel}-x86_64.pkg.tar.zst"
        "megasync_arch::https://github.com/nnfewl/MEGAsync/releases/download/linux-v${pkgver}/megasync_arch")
sha256sums=('SKIP'
            'SKIP')
noextract=('megasync_arch')

package() {
    cp -R "${srcdir}/usr" "${pkgdir}/"
    cp -R "${srcdir}/opt" "${pkgdir}/"
    rm -rf "${pkgdir}/usr/share/icons/ubuntu-mono-dark"

    install -Dm755 "${srcdir}/megasync_arch" "${pkgdir}/usr/bin/megasync"
}

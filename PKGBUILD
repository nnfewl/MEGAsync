pkgname=megasync-bin
pkgver=6.3.0.1
pkgrel=1
pkgdesc='MEGAsync with theme-native tray icons (Papirus/Tela support)'
arch=('x86_64')
url='https://github.com/nnfewl/MEGAsync'
license=('custom')
provides=("megasync=$pkgver")
conflicts=('megasync'
           'megatools')
depends=('crypto++'
         'curl'
         'glibc'
         'libgcc'
         'hicolor-icon-theme'
         'icu'
         'libmediainfo'
         'libsodium'
         'libstdc++'
         'libuv'
         'libxcb'
         'libzen'
         'openssl'
         'qt5-base'
         'qt5-declarative'
         'qt5-graphicaleffects'
         'qt5-quickcontrols'
         'qt5-quickcontrols2'
         'qt5-svg'
         'qt5-x11extras'
         'sqlite'
         'zlib')
optdepends=('xdg-desktop-portal: follow the desktop color scheme (using dbus)'
            'glib2: follow the desktop color scheme (using gsettings)')
source=("https://github.com/nnfewl/MEGAsync/releases/download/linux-v${pkgver}/megasync-${pkgver}-arch.tar.zst")
sha256sums=('SKIP')

package() {
    cp -a "$srcdir/usr" "$pkgdir/"
}

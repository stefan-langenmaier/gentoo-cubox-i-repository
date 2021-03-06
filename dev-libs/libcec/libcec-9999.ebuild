# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libcec/libcec-2.1.4.ebuild,v 1.1 2014/03/23 15:24:46 thev00d00 Exp $

EAPI=5

inherit autotools eutils linux-info

case ${PV} in
9999)
        EGIT_REPO_URI="git://github.com/xbmc-imx6/libcec.git"
        inherit git-2
        ;;
*)
	SRC_URI="http://github.com/Pulse-Eight/${PN}/archive/${P}.tar.gz"
        KEYWORDS="~amd64 ~x86"
        ;;
esac


DESCRIPTION="Library for communicating with the Pulse-Eight USB HDMI-CEC Adaptor"
HOMEPAGE="http://libcec.pulse-eight.com"
LICENSE="GPL-2"
SLOT="0"
IUSE="debug static-libs"

RDEPEND="virtual/udev
	dev-libs/lockdev"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

CONFIG_CHECK="~USB_ACM"

S="${WORKDIR}/${PN}-${P}"

src_prepare() {
	sed -i '/^CXXFLAGS/s:-fPIC::' configure.ac || die
	sed -i '/^CXXFLAGS/s:-Werror::' configure.ac || die
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static) \
	$(use_enable debug) \
	--enable-optimisation \
	--enable-imx6 \
	--disable-rpi \
	--disable-cubox
}

src_install() {
	default
	use static-libs || find "${ED}" -name '*.la' -delete
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Cubox-i xorg driver"
HOMEPAGE="https://github.com/Freescale/meta-fsl-arm"

SRC_URI="http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/xserver-xorg-video-imx-viv-3.10.17-1.0.0_beta.tar.gz"

LICENSE="CLOSED"

SLOT="0"

KEYWORDS="-* arm"

S=${WORKDIR}/xserver-xorg-video-imx-viv-${PV}-1.0.0_beta/EXA/src
OPENGLDIR=usr/lib/opengl/vivante

src_prepare() {
	epatch "${FILESDIR}"/Stop-using-Git-to-write-local-version.patch
	epatch "${FILESDIR}"/Remove-dix-internal-header-usage.patch
	epatch "${FILESDIR}"/0001-Avoid-strict-check.patch
	epatch "${FILESDIR}"/0002-http-oliverchang.github.io-2014-12-22-fixing-linux-a.patch
}

src_compile() {
	emake CFLAGS="${CFLAGS} -I/usr/include/libdrm" BUILD_HARD_VFP=1 BUSID_HAS_NUMBER=1 XSERVER_GREATER_THAN_13=1 -f makefile.linux || die
}

src_install() {
	mkdir -p ${D}/usr/lib/xorg/modules
	mv vivante_drv.so ${D}/usr/lib/xorg/modules || die
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="GPU driver and apps for imx6"
HOMEPAGE="https://github.com/Freescale/meta-fsl-arm"

SRC_URI="http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/${PN}-${PV}.bin"

LICENSE="freescale"

SLOT="0"

KEYWORDS="-* arm"

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	sh ${DISTDIR}/${A} --force --auto-accept
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Cubox-i ipu firmware"
HOMEPAGE="https://github.com/Freescale/meta-fsl-arm"

MY_PV=${PV}-1.0.0
SRC_URI="http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/${PN}-${MY_PV}.bin"

LICENSE="freescale"

SLOT="0"

KEYWORDS="-* arm"

RESTRICT="strip mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}-${MY_PV}

src_unpack() {
	sh ${DISTDIR}/${A} --force --auto-accept
}

src_install() {
	mkdir -p ${D}lib/firmware

	mv firmware/vpu ${D}lib/firmware/

}

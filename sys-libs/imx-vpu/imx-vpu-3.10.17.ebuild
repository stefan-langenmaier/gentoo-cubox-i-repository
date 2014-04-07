# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Cubox-i IPU driver"
HOMEPAGE="https://github.com/Freescale/meta-fsl-arm"

MY_PV=${PV}-1.0.0_beta
SRC_URI="http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/${PN}-${MY_PV}.bin"

LICENSE="freescale"

SLOT="0"

KEYWORDS="-* arm"

RESTRICT="strip mirror"

DEPEND="sys-libs/firmware-imx sys-libs/gpu-viv-bin-mx6q"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}-${MY_PV}

src_unpack() {
	sh ${DISTDIR}/${A} --force --auto-accept
}

src_compile() {
	export PLATFORM="IMX6Q"
	emake all
}


src_install() {
	mkdir -p ${D}usr/include
	mkdir -p ${D}usr/lib

	mv vpu/libvpu* ${D}usr/lib
	mv vpu/vpu_lib.h ${D}usr/include
	mv vpu/vpu_io.h ${D}usr/include

}

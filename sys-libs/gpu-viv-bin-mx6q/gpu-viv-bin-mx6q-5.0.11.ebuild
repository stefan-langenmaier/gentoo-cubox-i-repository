# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="GPU driver and apps for imx6"
#at the moment only with support for the framebuffer
HOMEPAGE="https://github.com/Freescale/meta-fsl-arm"

MY_PV=${PV}.p4.5-hfp
MY_PN=imx-gpu-viv
SRC_URI="http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/${MY_PN}-${MY_PV}.bin"

LICENSE="freescale"

SLOT="0"

KEYWORDS="-* arm"

RESTRICT="strip mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}-${MY_PV}
OPENGLDIR=usr/lib/opengl/vivante

src_unpack() {
	sh ${DISTDIR}/${A} --force --auto-accept
}

src_compile() {
	cd "${S}/gpu-core"

	rm -r etc

	cd usr

	#prepare include dir
	cd include
	rm -r wayland-viv

	#prepare lib dir
	cd ../lib
	rm -r directfb-1.7-4

	rm libOpenVG.so
	ln -sf libOpenVG.3d.so libOpenVG.so

	# update pkgconfig for fb
	cd pkgconfig
	cp egl_linuxfb.pc egl.pc
	rm egl_directfb.pc egl_x11.pc wayland-egl.pc egl_linuxfb.pc egl_wayland.pc gc_wayland_protocol.pc glesv1_cm_x11.pc glesv2_x11.pc vg_x11.pc wayland-viv.pc

	cd ..

	rm libgc_wayland_protocol*
	rm libwayland-viv*

	#the libs are already linked to the fb, just remove the other libs
	rm *dfb*
	rm *wl*
	rm *x11*

	#create the gentoo folder structure
	cd "${S}/gpu-core"
	mkdir -p $OPENGLDIR/include $OPENGLDIR/lib $OPENGLDIR/extensions

	#and move it into the gentoo structure
	mv usr/include/* $OPENGLDIR/include/
	mv usr/lib/lib* $OPENGLDIR/lib/


#	cd $OPENGLDIR/lib
#	#FIXME it seems there is a problem with the SONAME
#	# it should be libGL.so.1 but it is libGL.so.1.2
#	# so the file libGL.so.1 is not created when activating opengl
#	sed 's/\x6C\x69\x62\x47\x4c\x2e\x73\x6f\x2e\x31\x2e\x32\x00/\x6C\x69\x62\x47\x4c\x2e\x73\x6f\x2e\x31\x00\x00\x00/g' libGL.so.1.2 > libGL.tmp.so
#	rm libGL.so.1.2
#	mv libGL.tmp.so libGL.so.1.2
#	cp libGL.so.1.2 libGL.so.1
#
#	ln -sf libGL.so.1 libGL.so.1.2
#	ln -sf libGL.so.1 libGL.so

}


src_install() {
	cd "${S}/apitrace/non-x11"
	cp ./* "${D}" -R
	cd "${S}/g2d"
	cp ./* "${D}" -R
	cd "${S}/gpu-tools/gmem-info"
	cp ./* "${D}" -R
#	cd "${S}/gpu-demos"
#	cp ./* "${D}" -R
	cd "${S}/gpu-core"
	cp ./* "${D}" -R
}

pkg_postinst() {
	eselect opengl set xorg-x11
	eselect opengl set vivante

	elog "At the moment this ebuild only installs framebuffer support"
}


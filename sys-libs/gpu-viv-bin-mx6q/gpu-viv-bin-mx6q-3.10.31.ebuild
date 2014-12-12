# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="GPU driver and apps for imx6"
HOMEPAGE="https://github.com/Freescale/meta-fsl-arm"

MY_PV=${PV}-1.1.0-beta-hfp
SRC_URI="http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/${PN}-${MY_PV}.bin"

LICENSE="freescale"

SLOT="0"

KEYWORDS="-* arm"

RESTRICT="strip mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}-${MY_PV}
OPENGLDIR=usr/lib/opengl/vivante

src_unpack() {
	sh ${DISTDIR}/${A} --force --auto-accept
}

src_configure() {
	# FIXME : not sure what this is good for
	# adopt the prefix and exec_prefix variables in .pc files
	#sed -i 's#^prefix=/usr#prefix=/'${FSLDIR}'/usr#' usr/lib/pkgconfig/*.pc
 	#sed -i 's#^exec_prefix=/usr#exec_prefix=/'${FSLDIR}'/usr#' usr/lib/pkgconfig/*.pc

	#gcc on Gentoo seems to define it lowercase
	sed -i s/LINUX/linux/g usr/include/EGL/eglvivante.h
}

src_compile() {
	#taken from repo of @danbrough
	#some cleanup
	rm -rf opt

	rm usr/lib/directfb-1.6-0 -rf
	rm include/wayland-viv -rf
	mkdir -p $OPENGLDIR/include $OPENGLDIR/lib $OPENGLDIR/extensions

	mv usr/include/* $OPENGLDIR/include/

	mv usr/lib/lib* $OPENGLDIR/lib/

	cd $OPENGLDIR/lib
	#FIXME it seems there is a problem with the SONAME
	# it should be libGL.so.1 but it is libGL.so.1.2
	# so the file libGL.so.1 is not created when activating opengl
	sed 's/\x6C\x69\x62\x47\x4c\x2e\x73\x6f\x2e\x31\x2e\x32\x00/\x6C\x69\x62\x47\x4c\x2e\x73\x6f\x2e\x31\x00\x00\x00/g' libGL.so.1.2 > libGL.tmp.so
	rm libGL.so.1.2
	mv libGL.tmp.so libGL.so.1.2
	cp libGL.so.1.2 libGL.so.1

	ln -sf libGL.so.1 libGL.so.1.2
	ln -sf libGL.so.1 libGL.so

	for library in EGL GAL GLESv2 VIVANTE; do
		ln -sf lib${library}-fb.so lib${library}.so
		rm lib${library}-{wl,x11,dfb}.so
	done

	rm libgc_wayland*
	rm libwayland*

	ln -sf libGLESv2-fb.so libGLESv2.so.2
	ln -sf libGLESv2-fb.so libGLESv2.so.2.0.0

	ln -sf libOpenVG_3D.so libOpenVG.so

	cd ..
	find "include/" -type f -exec chmod 644 {} \;
	find "lib/" -type f -exec chmod 644 {} \;
}


src_install() {
	mv * ${D}
}

pkg_postinst() {
	eselect opengl set vivante

	elog "At the moment this ebuild only installs framebuffer support"

#	elog "Make sure that you have a patched libdrm installed"
#	elog "You can find the patch here:"
#	elog "  https://github.com/Freescale/meta-fsl-arm/blob/master/recipes-graphics/drm/libdrm/mx6/drm-update-arm.patch"
#	elog "After you have patched libdrm you also have to recompile xorg-server" 
}


# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Cubox-i xorg driver"
HOMEPAGE="https://github.com/Freescale/meta-fsl-arm"

#SRC_URI="http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/${PN}.tar.gz"
SRC_URI="xserver-xorg-video-imx-viv-3.10.17-1.0.0_beta.tar.gz https://github.com/Freescale/meta-fsl-arm/raw/master/recipes-graphics/xorg-driver/xf86-video-imxfb-vivante/fix-hdmi-preferred-mode.patch"


# License of the package.  This must match the name of file(s) in
# /usr/portage/licenses/.  For complex license combination see the developer
# docs on gentoo.org for details.
LICENSE=""

SLOT="0"

KEYWORDS="-* arm"

RESTRICT="mirror"

#DEPEND=""

# Run-time dependencies. Must be defined to whatever this depends on to run.
# The below is valid if the same run-time depends are required to compile.
RDEPEND="${DEPEND}"

# Source directory; the dir where the sources can be found (automatically
# unpacked) inside ${WORKDIR}.  The default value for S is ${WORKDIR}/${P}
# If you don't need to change it, leave the S= line out of the ebuild
# to keep it tidy.
S=${WORKDIR}/${PN}-${PV}-1.0.0-beta-hfp
OPENGLDIR=usr/lib/opengl/vivante

# The following src_configure function is implemented as default by portage, so
# you only need to call it if you need a different behaviour.
# This function is available only in EAPI 2 and later.
src_configure() {
	# Most open-source packages use GNU autoconf for configuration.
	# The default, quickest (and preferred) way of running configure is:
	#econf
	#
	# You could use something similar to the following lines to
	# configure your package before compilation.  The "|| die" portion
	# at the end will stop the build process if the command fails.
	# You should use this at the end of critical commands in the build
	# process.  (Hint: Most commands are critical, that is, the build
	# process should abort if they aren't successful.)
	#./configure \
	#	--host=${CHOST} \
	#	--prefix=/usr \
	#	--infodir=/usr/share/info \
	#	--mandir=/usr/share/man || die
	# Note the use of --infodir and --mandir, above. This is to make
	# this package FHS 2.2-compliant.  For more information, see
	#   http://www.pathname.com/fhs/
	sed -i makefile.linux  -e 's:-L${LDFLAGSVIV}: -L${LDFLAGSVIV} -I/usr/include/libdrm:g'
}

# The following src_compile function is implemented as default by portage, so
# you only need to call it, if you need different behaviour.
# For EAPI < 2 src_compile runs also commands currently present in
# src_configure. Thus, if you're using an older EAPI, you need to copy them
# to your src_compile and drop the src_configure function.
src_compile() {
	# emake (previously known as pmake) is a script that calls the
	# standard GNU make with parallel building options for speedier
	# builds (especially on SMP systems).  Try emake first.  It might
	# not work for some packages, because some makefiles have bugs
	# related to parallelism, in these cases, use emake -j1 to limit
	# make to a single process.  The -j1 is a visual clue to others
	# that the makefiles have bugs that have been worked around.

	#emake || die

	#just call make
	make -f makefile.linux BUILD_HARD_VFP=1 BUSID_HAS_NUMBER=1

}

# The following src_install function is implemented as default by portage, so
# you only need to call it, if you need different behaviour.
# For EAPI < 4 src_install is just returing true, so you need to always specify
# this function in older EAPIs.
src_install() {
	# You must *personally verify* that this trick doesn't install
	# anything outside of DESTDIR; do this by reading and
	# understanding the install part of the Makefiles.
	# This is the preferred way to install.
	#emake DESTDIR="${D}" install || die

	# When you hit a failure with emake, do not just use make. It is
	# better to fix the Makefiles to allow proper parallelization.
	# If you fail with that, use "emake -j1", it's still better than make.

	# For Makefiles that don't make proper use of DESTDIR, setting
	# prefix is often an alternative.  However if you do this, then
	# you also need to specify mandir and infodir, since they were
	# passed to ./configure as absolute paths (overriding the prefix
	# setting).
	#emake \
	#	prefix="${D}"/usr \
	#	mandir="${D}"/usr/share/man \
	#	infodir="${D}"/usr/share/info \
	#	libdir="${D}"/usr/$(get_libdir) \
	#	install || die
	# Again, verify the Makefiles!  We don't want anything falling
	# outside of ${D}.

	# The portage shortcut to the above command is simply:
	#
	#einstall || die

	mv vivante_drv.so $D/usr/lib/xorg/modules
}

SRC_URI = "svn://svn.macosforge.org/repository/odcctools;protocol=http;module=trunk"
SRC_URI = "svn://iphone-dev.googlecode.com/svn/branches;protocol=http;module=odcctools-9.2-ld \
        file://fix-${SRCREV}.patch"
LICENSE = "ApplePSLicense-2.0"
SRCREV = "287"

PV = "0.0+svnr${SRCPV}"
S = "${WORKDIR}/odcctools-9.2-ld"

LIC_FILES_CHKSUM = "file://APPLE_LICENSE;md5=dacaafbaf91483700da837d31213a1e8"

inherit autotools crosssdk

PROVIDES = "virtual/${TARGET_PREFIX}binutils-crosssdk"

EXTRA_OECONF = "--enable-ld64"
BUILD_CFLAGS += "-m32"
BUILD_LDFLAGS += "-m32"
BUILD_CXXFLAGS += "-m32"

do_install_append () {
	ln -s ../libexec ${D}${bindir}/../libexec
	ln -s ${TARGET_SYS}/gcc ${D}${exec_prefix}/libexec/gcc
	mv ${D}${bindir}/${TARGET_PREFIX}ld  ${D}${bindir}/${TARGET_PREFIX}ld_classic
	ln -s ${TARGET_PREFIX}ld64 ${D}${bindir}/${TARGET_PREFIX}ld 	
}


sysroot_stage_all_append () {
	sysroot_stage_dir ${D}${bindir}/.. ${SYSROOT_DESTDIR}${bindir}/..
	sysroot_stage_dir ${D}${exec_prefix}/libexec ${SYSROOT_DESTDIR}${exec_prefix}/libexec
}

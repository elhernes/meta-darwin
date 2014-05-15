SRC_URI = "file://apple-x86-odcctools_758.159-0flosoft11.tar.gz \
           file://odcctools-9.2_p287-ld64.patch;pnum=0 \
           file://objc.patch \
           file://fix-758.patch \
           file://vm_types_h.patch \
           file://as.patch \
           file://arch_c.patch "
LICENSE = "ApplePSLicense-2.0"

S = "${WORKDIR}/apple-x86-odcctools-758.159"

LIC_FILES_CHKSUM = "file://APPLE_LICENSE;md5=dacaafbaf91483700da837d31213a1e8"

inherit autotools crosssdk

DEPENDS += "util-linux-native openssl-native"
PROVIDES = "virtual/${TARGET_PREFIX}binutils-crosssdk"

EXTRA_OECONF = "--enable-ld64"

do_install_append () {
	ln -s ../libexec ${D}${bindir}/../libexec
	ln -s ${TARGET_SYS}/gcc ${D}${exec_prefix}/libexec/gcc
}

sysroot_stage_all_append () {
	sysroot_stage_dir ${D}${bindir}/.. ${SYSROOT_DESTDIR}${bindir}/..
	sysroot_stage_dir ${D}${exec_prefix}/libexec ${SYSROOT_DESTDIR}${exec_prefix}/libexec
}

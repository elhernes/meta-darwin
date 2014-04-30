DESCRIPTION = "Runtime libraries from OSX"
LICENSE = "Proprietary"

COMPATIBLE_HOST = ".*-darwin.*"

SRC_URI = "file://OSX-sdk.zip \
           file://LICENSE"

LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE;md5=03fe683ef28b9ddfe7f658a0f4b3b80e"

S = "${WORKDIR}/OSX-sdk"
#B = "${WORKDIR}/build-${TARGET_SYS}"

inherit nativesdk

INHIBIT_DEFAULT_DEPS = "1"

PROVIDES += "virtual/nativesdk-libc"
PROVIDES += "virtual/nativesdk-${SDK_PREFIX}libc-initial"
PROVIDES += "virtual/nativesdk-${SDK_PREFIX}libc-for-gcc"

# Work around pulling in eglibc for now...
PROVIDES += "virtual/nativesdk-libintl"
PROVIDES += "virtual/nativesdk-libiconv"

do_configure () {
	:
}

do_compile () {
	:
}

do_install () {
	mkdir ${D}/usr
	cp -r ${S}/usr/* ${D}/usr/
}

FILES_${PN} = "/usr"
FILES_${PN}-staticdev = "/usr/lib/*.a"

sysroot_stage_all() {
	sysroot_stage_dir ${D} ${SYSROOT_DESTDIR}
}


DESCRIPTION = "Runtime libraries from OSX"
LICENSE = "Proprietary"

COMPATIBLE_HOST = ".*-darwin.*"

OSX_SDK ?= "file://OSX-sdk.zip"

SRC_URI = "${OSX_SDK} \
           file://LICENSE"

LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE;md5=03fe683ef28b9ddfe7f658a0f4b3b80e"

PR = "1"

S = "${WORKDIR}/OSX-sdk"

inherit nativesdk

INHIBIT_DEFAULT_DEPS = "1"

PROVIDES += "virtual/nativesdk-libc"
PROVIDES += "virtual/nativesdk-libc-locale"
PROVIDES += "virtual/nativesdk-${SDK_PREFIX}libc-initial"
PROVIDES += "virtual/nativesdk-${SDK_PREFIX}libc-for-gcc"

# Work around pulling in eglibc for now...
PROVIDES += "virtual/nativesdk-libintl"
PROVIDES += "virtual/nativesdk-libiconv"

CFLAGS[unexport] = "1"
CXXFLAGS[unexport] = "1"
CPPFLAGS[unexport] = "1"
LDFLAGS[unexport] = "1"
TARGET_CFLAGS[unexport] = "1"
TARGET_CXXFLAGS[unexport] = "1"
TARGET_CPPFLAGS[unexport] = "1"
TARGET_LDFLAGS[unexport] = "1"

do_configure[noexec] = "1"
do_compile[noexec] = "1"
package_do_shlibs[noexec] = "1"

INSANE_SKIP_${PN} += "file-rdeps staticdev"


do_install () {
    mkdir -p ${D}
	mkdir ${D}/usr
	cp -r ${S}/usr/* ${D}/usr/
	mkdir -p ${D}/System/Library/Frameworks
	cp -r ${S}/System/Library/Frameworks/* ${D}/System/Library/Frameworks/
}

ALLOW_EMPTY_${PN} = "1"

PACKAGES = "${PN} ${PN}-dontship"

FILES_${PN}-dontship = "/usr /System"

sysroot_stage_all() {
	sysroot_stage_dir ${D} ${SYSROOT_DESTDIR}${SDKPATHNATIVE}/runtime
}


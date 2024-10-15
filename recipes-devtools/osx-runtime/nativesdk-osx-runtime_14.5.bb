DESCRIPTION = "Runtime libraries for MacOS"
LICENSE = "Proprietary"

COMPATIBLE_HOST = ".*-darwin.*"

OSX_SDK ?= "git://github.com/alexey-lysiuk/macos-sdk.git;nobranch=1;protocol=https;subpath=MacOSX14.5.sdk;destsuffix=git"
SRCREV = "69ddec41e6224afebd5f19bb24764305ac3e828a"

SRC_URI = " \
    ${OSX_SDK} \
    file://sdk-14.5.patch \
    file://LICENSE \
"

LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE;md5=03fe683ef28b9ddfe7f658a0f4b3b80e"

PR = "1"

S = "${WORKDIR}/git"

inherit nativesdk

INHIBIT_DEFAULT_DEPS = "1"
EXCLUDE_FROM_SHLIBS = "1"

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

do_compile[noexec] = "1"
package_do_shlibs[noexec] = "1"

INSANE_SKIP:${PN} += "file-rdeps staticdev"
INSANE_SKIP:${PN}-dontship += "file-rdeps staticdev"

do_configure() {
}

do_install () {
    mkdir -p ${D}
    cp -r ${S}/* ${D}/
}

do_stash_locale () {
}
addtask do_stash_locale after do_install before do_populate_sysroot do_package

ALLOW_EMPTY:${PN} = "1"

PACKAGES = "${PN} ${PN}-dontship"

FILES:${PN}-dontship = " \
    /usr \
    /System \
    /Entitlements.plist \
    /SDKSettings.json \
    /SDKSettings.plist \
    /Library \
    /patches \
"

SYSROOT_DIRS_NATIVE:append = " ${SDKPATHNATIVE}/runtime"
SYSROOT_DIRS:append = " ${SDKPATHNATIVE}/runtime"

sysroot_stage_all:append() {
    sysroot_stage_dir ${D} ${SYSROOT_DESTDIR}${SDKPATHNATIVE}/runtime
}

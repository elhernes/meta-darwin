DESCRIPTION = "Linux port of Apple CCTools"
SECTION = "devel"
LICENSE = "ApplePSLicense-2.0"
LIC_FILES_CHKSUM = "file://cctools/APPLE_LICENSE;md5=dacaafbaf91483700da837d31213a1e8"

SRCREV = "236a426c1205a3bfcf0dbb2e2faf2296f0a100e5"
SRC_URI = "git://github.com/tpoechtrager/cctools-port.git;branch=973.0.1-ld64-609;protocol=https"

SRC_URI[md5sum] = "1f2507d489c7416f3bfc447bd7d3a07e"
SRC_URI[sha256sum] = "1fa3dd2c4d7192e284481927fceaaa1b2b0e2efff8f219479b87c95dc840c5d3"

PR = "r1"

inherit autotools crosssdk

DEPENDS += "util-linux-native openssl-native xar-native libtapi-native clang-native"
PROVIDES = "virtual/${TARGET_PREFIX}binutils-crosssdk"

export CC="${STAGING_DIR_NATIVE}/usr/bin/clang"
export CXX="${STAGING_DIR_NATIVE}/usr/bin/clang++"

EXTRA_OECONF:append = " \
    --with-llvm-config=${STAGING_DIR_NATIVE}/usr/bin/llvm-config \
    --enable-lto-support \
    --enable-xar-support \
    --with-libxar=${STAGING_DIR_NATIVE}/usr \
    --enable-tapi-support \
    --with-libtapi=${STAGING_DIR_NATIVE}/usr \
"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build"

AUTOTOOLS_SCRIPT_PATH = "${S}/cctools"

do_configure:prepend() {
    PWD_CUR=$(pwd)
    cd ${AUTOTOOLS_SCRIPT_PATH}
    libtoolize
    cd ${PWD_CUR}
}

DESCRIPTION = "Linux port of Apple CCTools"
SECTION = "devel"
LICENSE = "APSL-2.0"
LIC_FILES_CHKSUM = "file://cctools/APPLE_LICENSE;md5=dacaafbaf91483700da837d31213a1e8"

SRCREV = "f28fb5e9c31efd3d0552afcce2d2c03cae25c1ca"
SRC_URI = "git://github.com/tpoechtrager/cctools-port.git;branch=master;protocol=https"

PR = "r2"

inherit autotools crosssdk

DEPENDS += "util-linux-native openssl-native xar-native libtapi-native"
PROVIDES = "virtual/${TARGET_PREFIX}binutils"

DEPENDS += "clang-native libcxx-native"

TOOLCHAIN:class-crosssdk = "clang"
COMPILER_RT:class-crosssdk = "-rtlib=libgcc --unwindlib=libgcc"
LIBCPLUSPLUS:class-crosssdk = "-stdlib=libc++ -lc++abi"

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

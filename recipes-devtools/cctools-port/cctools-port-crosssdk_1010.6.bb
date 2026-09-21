DESCRIPTION = "Linux port of Apple CCTools"
SECTION = "devel"
LICENSE = "APSL-2.0"
LIC_FILES_CHKSUM = "file://cctools/APPLE_LICENSE;md5=dacaafbaf91483700da837d31213a1e8"

SRCREV = "a2724f04cafe3590fbc3d0beacc37293d83a2177"
SRC_URI = "git://github.com/tpoechtrager/cctools-port.git;nobranch=1;protocol=https"

inherit autotools crosssdk

DEPENDS += " \
    util-linux-native \
    openssl-native \
    xar-native \
    libtapi-native \
    libdispatch-native \
"

PROVIDES = "virtual/nativesdk-cross-binutils"

DEPENDS += " \
    clang-native \
    libcxx-native \
"

# Selects clang for the native build; TOOLCHAIN:class-crosssdk has no effect here.
# -stdlib=libc++ isn't added automatically, so this is C++ and needs it set directly.
TOOLCHAIN_NATIVE = "clang"
CXXFLAGS:append:class-crosssdk = " -stdlib=libc++"
LDFLAGS:append:class-crosssdk = " -stdlib=libc++"

# cctools' own include/stuff/bool.h declares "enum bool { FALSE, TRUE };",
# which is a hard syntax error under C23, where bool is a reserved keyword
# rather than a macro. Pin the C dialect to a pre-C23 standard rather than
# relying on clang's default (gnu23 as of this clang version).
CFLAGS:append:class-crosssdk = " -std=gnu17"

EXTRA_OECONF:append = " \
    --with-llvm-config=${STAGING_DIR_NATIVE}/usr/bin/llvm-config \
    --enable-lto-support \
    --enable-xar-support \
    --with-libxar=${STAGING_DIR_NATIVE}/usr \
    --enable-tapi-support \
    --with-libtapi=${STAGING_DIR_NATIVE}/usr \
"

AUTOTOOLS_SCRIPT_PATH = "${S}/cctools"

do_configure:prepend() {
    PWD_CUR=$(pwd)
    cd ${AUTOTOOLS_SCRIPT_PATH}
    libtoolize
    cd ${PWD_CUR}
}

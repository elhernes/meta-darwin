DESCRIPTION = "Linux port of Apple CCTools"
SECTION = "daqri"
LICENSE = "ApplePSLicense-2.0"
LIC_FILES_CHKSUM = "file://cctools/APPLE_LICENSE;md5=dacaafbaf91483700da837d31213a1e8"

SRCREV = "ecb84d757b6f011543504967193375305ffa3b2f"
SRC_URI = "git://github.com/tpoechtrager/cctools-port.git;protocol=https"

SRC_URI[md5sum] = "1f2507d489c7416f3bfc447bd7d3a07e"
SRC_URI[sha256sum] = "1fa3dd2c4d7192e284481927fceaaa1b2b0e2efff8f219479b87c95dc840c5d3"

PR = "r1"

inherit autotools crosssdk

DEPENDS += "util-linux-native openssl-native"
PROVIDES = "virtual/${TARGET_PREFIX}binutils-crosssdk"

export CC="/usr/bin/clang"
export CXX="/usr/bin/clang++"

EXTRA_OECONF_append = " --with-llvm-config=/usr/bin/llvm-config"


S = "${WORKDIR}/git"
B = "${WORKDIR}/build"

AUTOTOOLS_SCRIPT_PATH = "${S}/cctools"

#do_configure_prepend() {
#    cd ${AUTOTOOLS_SCRIPT_PATH}
#    libtoolize --force
#}

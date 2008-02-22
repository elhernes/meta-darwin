SRC_URI = "svn://iphone-dev.googlecode.com/svn/trunk;proto=http;module=odcctools"

DEPENDS = "cross-linkage bison-native"

PV = "0.0+${SRCREV}"

S = "${WORKDIR}/odcctools"

PROVIDES = "virtual/${TARGET_PREFIX}binutils"


PARALLEL_MAKE = ""

inherit autotools cross

EXTRA_OECONF = "--disable-ld64"
#EXTRA_OEMAKE = "ENABLE_OPTIMIZED=1"
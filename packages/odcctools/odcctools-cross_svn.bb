#SRC_URI = "svn://iphone-dev.googlecode.com/svn/trunk;proto=http;module=odcctools"
SRC_URI = "svn://iphone-dev.googlecode.com/svn/branches;proto=http;module=odcctools-9.2-ld"

DEPENDS = "cross-linkage bison-native"

PV = "0.0+${SRCREV}"
PR = "r1"

S = "${WORKDIR}/odcctools-9.2-ld"

PROVIDES = "virtual/${TARGET_PREFIX}binutils"


PARALLEL_MAKE = ""

inherit autotools cross

EXTRA_OECONF = "--disable-ld64"
#EXTRA_OEMAKE = "ENABLE_OPTIMIZED=1"
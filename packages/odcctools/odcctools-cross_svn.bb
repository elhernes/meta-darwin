
SRC_URI = "svn://iphone-dev.googlecode.com/svn/trunk;proto=http;module=odcctools"

PV = "0.0+${SRCREV}"

S = "${WORKDIR}/odcctools"

PROVIDES = "virtual/${TARGET_PREFIX}binutils"
DEPENDS = "cross-linkage"

inherit autotools cross

EXTRA_OECONF = "--disable-ld64"
#EXTRA_OEMAKE = "ENABLE_OPTIMIZED=1"
SRC_URI = "svn://iphone-dev.googlecode.com/svn/trunk;proto=http;module=odcctools"

DEPENDS = "bison-native"

PV = "0.0+${SRCREV}"

S = "${WORKDIR}/odcctools"

PARALLEL_MAKE = ""

inherit autotools sdk

EXTRA_OECONF = "--disable-ld64"

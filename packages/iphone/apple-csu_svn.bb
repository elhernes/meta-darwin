
SRC_URI = "svn://iphone-dev.googlecode.com/svn/trunk;proto=http;module=csu"

PV = "0.0+${SRCREV}"

INHIBIT_DEFAULT_DEPS = "1"

S = "${WORKDIR}/csu"

inherit autotools

do_stage () {
	oe_runmake DESTDIR=${STAGING_DIR_TARGET} install
}
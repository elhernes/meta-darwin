#SRC_URI = "svn://iphone-dev.googlecode.com/svn/trunk;proto=http;module=odcctools"
SRC_URI = "svn://iphone-dev.googlecode.com/svn/branches;proto=http;module=odcctools-9.2-ld"

DEPENDS = "bison-native"

PV = "0.0+${SRCREV}"
PR = "r1"

S = "${WORKDIR}/odcctools-9.2-ld"

PARALLEL_MAKE = ""

inherit autotools sdk

EXTRA_OECONF = "--disable-ld64"

do_install_append () {
	install -d "${D}${prefix}/${TARGET_SYS}/bin/"
	for l in ${D}${bindir}/*; do
		ln -sf "${bindir}/`basename $l`" "${D}${prefix}/${TARGET_SYS}/bin/`basename $l | sed -e 's,${TARGET_PREFIX},,'`"
	done
}

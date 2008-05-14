
SRC_URI = "svn://iphone-dev.googlecode.com/svn/trunk;proto=http;module=include \
           ${DARWINFILES}MacOSX10.4u.sdk.tgz \
	   file://headers-hack.patch;patch=1"

PV = "0.0+${SRCREV}"
PR = "r3"

FILES_${PN}-dev = "${layout_includedir}"

RDEPENDS_${PN}-dev = ""
RRECOMMENDS_${PN}-dbg = "${PN}-dev (= ${DEBPV})"

INHIBIT_DEFAULT_DEPS = "1"

S = "${WORKDIR}/include"
HEADERDEST = "${WORKDIR}/headers-staging"

inherit autotools

EXTRA_OECONF = "--with-macosx-sdk=${WORKDIR}"
#EXTRA_OEMAKE = "ENABLE_OPTIMIZED=1"

export includedir = "${HEADERDEST}"

do_compile () {
	bash install-headers.sh
	# horrible hacks to make llvm-cross libstdc++ compile
	touch ${HEADERDEST}/stdio_ext.h
	touch ${HEADERDEST}/malloc.h
	# remove broken X11 link
	rm ${HEADERDEST}/X11
	cd ${HEADERDEST}
	ln -s OpenGLES GLES
	rm ${HEADERDEST}/c++
}

do_stage () {
	cp -dpR ${HEADERDEST}/* ${STAGING_INCDIR}/
	base=`readlink -f ${TMPDIR} | cut -d '/' -f 2`
	rm -f ${STAGING_DIR_TARGET}/$base
	ln -s /$base ${STAGING_DIR_TARGET}/$base
}

do_install () {
	install -d ${D}${layout_includedir}
	cp -dpR ${HEADERDEST}/* ${D}/${layout_includedir}/
}

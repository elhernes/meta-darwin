
SRC_URI = "svn://iphone-dev.googlecode.com/svn/trunk;proto=http;module=include \
           ${DARWINFILES}MacOSX10.4u.sdk.tgz \
	   file://headers-hack.patch;patch=1"

PV = "0.0+${SRCREV}"

INHIBIT_DEFAULT_DEPS = "1"

S = "${WORKDIR}/include"

inherit autotools

EXTRA_OECONF = "--with-macosx-sdk=${WORKDIR}"
#EXTRA_OEMAKE = "ENABLE_OPTIMIZED=1"

export includedir = "${STAGING_INCDIR}"

do_stage () {
	bash install-headers.sh
	# horrible hacks to make llvm-cross libstdc++ compile
	touch ${STAGING_INCDIR}/stdio_ext.h
	touch ${STAGING_INCDIR}/malloc.h
	# remove broken X11 link
	rm ${STAGING_INCDIR}/X11
	cd ${STAGING_INCDIR}
	ln -s OpenGLES GLES
}

do_install () {
    :
}
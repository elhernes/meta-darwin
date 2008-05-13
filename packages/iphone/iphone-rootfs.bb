
SRC_URI = "${DARWINFILES}iphone-rootfs.tgz"

PV = "0.0"
PR = "r1"
DEPENDS = "apple-headers apple-csu"
PROVIDES = "virtual/${TARGET_PREFIX}libc-for-gcc virtual/libc virtual/libiconv virtual/libintl libsegfault"
#RPROVIDES = "libsegfault"

S = "${WORKDIR}"

INHIBIT_DEFAULT_DEPS = "1"
EXCLUDE_FROM_SHLIBS = "1"

FILES_${PN} += "/System ${layout_libdir}/*"

do_compile () {
	:
}

do_install () {
	install -d ${D}${layout_libdir}/
	cp -apR ${S}/usr/lib/* ${D}${layout_libdir}/
	cp -apR ${S}/System ${D}/
	rm -rf ${D}/System/Library/Fonts
	rm -rf ${D}/System/Library/Audio
	rm -rf ${D}/System/Library/Caches
}

do_stage () {
	cp -apR ${S}/usr/lib/* ${STAGING_LIBDIR}/
	cp -apR ${S}/System ${STAGING_DIR_TARGET}/
	rm -rf ${STAGING_DIR_TARGET}/System/Library/Fonts
	rm -rf ${STAGING_DIR_TARGET}/System/Library/Audio
	rm -rf ${STAGING_DIR_TARGET}/System/Library/Caches
}

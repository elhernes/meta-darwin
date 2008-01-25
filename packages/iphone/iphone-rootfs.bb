
SRC_URI = "${DARWINFILES}iphone-rootfs.tgz"

PV = "0.0"
DEPENDS = "apple-headers apple-csu"
PROVIDES = "virtual/${TARGET_PREFIX}libc-for-gcc virtual/libc virtual/libiconv virtual/libintl libsegfault"
#RPROVIDES = "libsegfault"

S = "${WORKDIR}"

INHIBIT_DEFAULT_DEPS = "1"

do_compile () {
	:
}

do_install () {
	:
}

do_stage () {
	cp -apR ${S}/usr/lib/* ${STAGING_LIBDIR}/
}

DESCRIPTION = "Target packages for the Darwin standalone SDK"
PR = "r0"
LICENSE = "MIT"
ALLOW_EMPTY = "1"

PACKAGES = "${PN} ${PN}-dbg"

DARWIN_DEPENDENCIES = "\
    apple-csu-dev \
    apple-headers-dev \
    iphone-rootfs \
    "

RDEPENDS_${PN}_append_darwin = "${DARWIN_DEPENDENCIES}"
RDEPENDS_${PN}_append_darwin8 = "${DARWIN_DEPENDENCIES}"



FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
    file://0001-darwin9.patch \
"

TOOLCHAIN_OPTIONS_prepend_darwin9_class-nativesdk = "-L. "

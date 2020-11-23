FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
    file://0001-darwin.patch \
"

TOOLCHAIN_OPTIONS_prepend_darwin17_class-nativesdk = "-L. "

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_class-nativesdk_darwin19 = "\
    file://0001-scanner-include-flexdevh-at-top-block-of-scanl.patch \
    "

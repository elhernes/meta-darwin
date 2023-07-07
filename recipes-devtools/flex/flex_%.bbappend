FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:class-nativesdk:darwin21 = "\
    file://0001-scanner-include-flexdevh-at-top-block-of-scanl.patch \
    "

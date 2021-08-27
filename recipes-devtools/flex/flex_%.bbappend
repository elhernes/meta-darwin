FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:class-nativesdk:darwin19 = "\
    file://0001-scanner-include-flexdevh-at-top-block-of-scanl.patch \
    "

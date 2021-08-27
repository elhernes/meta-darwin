FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = "\
    file://0099-nativesdk-gcc-darwin.patch \
"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = "\
    file://0099-nativesdk-gcc-darwin.patch \
    file://0100-change-macosx-version-min-to-10.15.patch \
"

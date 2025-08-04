FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://0099-nativesdk-gcc-darwin.patch \
    file://0100-change-macosx-version-min-to-12.3.patch \
"

# Patch created using https://github.com/iains/gcc-13-branch/tree/gcc-13-4-darwin
SRC_URI:append = " \
    file://0101-aarch64-Darwin-support-gcc-13-darwin.patch \
"

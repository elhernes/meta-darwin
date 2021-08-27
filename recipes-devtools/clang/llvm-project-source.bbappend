FILESEXTRAPATHS:prepend := "${THISDIR}/clang:"
SRC_URI:append = " \
    file://0001-Fixes_for_Darwin_SDKs.patch \
"

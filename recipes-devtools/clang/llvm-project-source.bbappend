FILESEXTRAPATHS:prepend := "${THISDIR}/clang:"
SRC_URI:append = " \
    file://0037-Fixes_for_Darwin_SDKs.patch \
"

FILESEXTRAPATHS_prepend := "${THISDIR}/clang:"
SRC_URI_append = " \
    file://0001-Fixes_for_Darwin_SDKs.patch \
"

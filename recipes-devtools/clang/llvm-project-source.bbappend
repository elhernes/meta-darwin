FILESEXTRAPATHS_prepend := "${THISDIR}/clang:"
SRC_URI_append = " \
    file://0001-darwin.patch \
    file://9999-rpath.patch \
    file://9999-include.patch \
"

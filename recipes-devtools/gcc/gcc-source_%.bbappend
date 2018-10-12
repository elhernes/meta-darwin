FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_remove = "file://0036-handle-sysroot-support-for-nativesdk-gcc.patch"
SRC_URI_append = " file://0036-handle-sysroot-support-for-nativesdk-gcc-darwin.patch"

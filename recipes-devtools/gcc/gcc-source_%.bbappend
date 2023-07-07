FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = "\
    file://0099-nativesdk-gcc-darwin.patch \
    file://0100-change-macosx-version-min-to-12.3.patch \
    file://0101-optional-libstdc.patch \
    file://0001-libstdcxx-Rename-null-terminated-to-avoid-collision.patch \
"

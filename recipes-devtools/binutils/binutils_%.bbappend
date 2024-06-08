FILESEXTRAPATHS:prepend := "${THISDIR}/binutils:"

SRC_URI:append = " \
    file://0001-OS-1142-Do-not-use-nm-B-for-Darwin-s-nm.patch \
"

# Add dylib files to package nativesdk-binutils
FILES:${PN} += " \
    ${libdir} \
"

# TODO: Needs to be fixed by packaging this right
# We should filter .debug out to the dbg package
INSANE_SKIP:nativesdk-binutils = "debug-files"

# nativesdk-binutils's libctf doesn't compile. disable it
PACKAGECONFIG[libctf] = "--enable-libctf=yes,--enable-libctf=no"

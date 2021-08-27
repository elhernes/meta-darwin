FILESEXTRAPATHS:prepend := "${THISDIR}/binutils:"

SRC_URI:append = " \
    file://9999-disable-darwin-logic.patch \
"

FILES:${PN} += " \
    ${libdir} \
"

# TODO: Needs to be fixed by packaging this right
# We should filter .debug out to the dbg package
INSANE_SKIP:nativesdk-binutils = "debug-files"

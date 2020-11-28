FILESEXTRAPATHS_prepend := "${THISDIR}/binutils:"

SRC_URI_append = " \
    file://9999-disable-darwin-logic.patch \
"

FILES_${PN} += " \
    ${libdir} \
"

# TODO: Needs to be fixed by packaging this right
# We should filter .debug out to the dbg package
INSANE_SKIP_nativesdk-binutils = "debug-files"

# Darwin's linker has neither -Wl,-soname nor HP's -Wl,+h; sqlite's own
# configure already sets -install_name for Mac targets independently of
# this flag, so don't force the ELF/HP-style soname check to be fatal here.
EXTRA_OECONF:remove:darwin21 = "--soname=legacy"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# The shell binary's "-L. -lsqlite3" link resolves against the macOS SDK's
# own (feature-incomplete) libsqlite3 stub instead of the library just built
# here - see the patch for details.
SRC_URI:append:darwin21 = " \
    file://0001-shell-link-against-libsqlite3-by-path-not-l.patch \
"

# The Darwin libraries are named libsqlite3.<version>.dylib, which the default
# "${libdir}/*.so.*" doesn't match.
FILES:lib${BPN}:append:darwin21 = " ${libdir}/libsqlite3*.dylib"

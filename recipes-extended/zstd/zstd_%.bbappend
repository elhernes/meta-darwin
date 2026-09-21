FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

EXTRA_OEMAKE:append:darwin21 = " UNAME='Darwin'"

# LC_RPATH is a Mach-O/macOS linker concept; class-nativesdk also covers
# other SDK hosts (e.g. mingw32), where this patch doesn't apply. Scope to
# darwin21 like EXTRA_OEMAKE above.
SRC_URI:append:darwin21 = " file://0001-Fix-duplicate-LC_RPATH-error-on-MacOS.patch"

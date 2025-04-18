FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

EXTRA_OEMAKE:append:darwin21 = " UNAME='Darwin'"

SRC_URI:append:class-nativesdk = " file://0001-Fix-duplicate-LC_RPATH-error-on-MacOS.patch"

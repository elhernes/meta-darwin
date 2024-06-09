FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

PACKAGES += "gettext-alias"
# For some unknown reason this file isn't packaged while building nativesdk-gettext
FILES:gettext-alias = "${datadir}/locale/locale.alias"

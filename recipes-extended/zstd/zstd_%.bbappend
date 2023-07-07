FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

EXTRA_OEMAKE:append:darwin21 = " UNAME='Darwin'"

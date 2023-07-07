FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

EXTRA_OEMAKE:append:darwin21 = " TARGET_OS='Darwin'"

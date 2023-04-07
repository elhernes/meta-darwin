FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

EXTRA_OEMAKE:append:darwin19 = " TARGET_OS='Darwin'"

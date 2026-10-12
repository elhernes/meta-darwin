FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:darwin21 = " \
    file://0001-chartype.h-don-t-include-stdc-predef.h-on-Apple.patch \
"

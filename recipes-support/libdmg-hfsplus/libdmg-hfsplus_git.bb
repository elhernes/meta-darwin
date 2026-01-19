SUMMARY = "Utilities for manipulating macOS dmg files"
DESCRIPTION = "This is a set of utilities for manipulating macOS dmg and hfs files"
HOMEPAGE = "https://github.com/elhernes/libdmg-hfsplus"

LICENSE = "GPL-3.0-only"

SRC_URI = "git://github.com/elhernes/libdmg-hfsplus.git;branch=master;protocol=https"
SRCREV = "c5339301dc02b3357e7cc03cdf0a67d7a7d5f83b"

LIC_FILES_CHKSUM = "file://${WORKDIR}/git/LICENSE;md5=d32239bcb673463ab874e80d47fae504"

S = "${WORKDIR}/git"

inherit cmake

BBCLASSEXTEND = "native nativesdk"

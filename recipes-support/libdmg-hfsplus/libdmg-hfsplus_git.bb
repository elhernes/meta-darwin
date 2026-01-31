SUMMARY = "Utilities for manipulating macOS dmg files"
DESCRIPTION = "This is a set of utilities for manipulating macOS dmg and hfs files"
HOMEPAGE = "https://github.com/elhernes/libdmg-hfsplus"

LICENSE = "GPL-3.0-only"

SRC_URI = "git://github.com/elhernes/libdmg-hfsplus.git;branch=master;protocol=https"
SRCREV = "3c3ce87a7e2f036f771f81147f9e125a2bb207f1"

LIC_FILES_CHKSUM = "file://${WORKDIR}/git/LICENSE;md5=d32239bcb673463ab874e80d47fae504"

S = "${WORKDIR}/git"

inherit cmake

BBCLASSEXTEND = "native"

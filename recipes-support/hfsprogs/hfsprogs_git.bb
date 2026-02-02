SUMMARY = "HFS+ filesystem utilities for Linux"
DESCRIPTION = "Apple's HFS+ filesystem utilities (mkfs.hfsplus, fsck.hfsplus) \
adapted to work on Linux systems. Based on Apple's diskdev-cmds source code."
HOMEPAGE = "https://github.com/Artoria2e5/hfsprogs "

LICENSE = "APSL-2.0"
LIC_FILES_CHKSUM = "file://README.md;md5=ea27fd14a7e575753270cc5527d29023"

SRCREV = "064b7fece00d069f206fd2d4a9a4493dd2777d9f"
SRC_URI = "git://github.com/elhernes/hfsprogs.git;branch=master;protocol=https"

S = "${WORKDIR}/git"

DEPENDS = "openssl libbsd"

inherit cmake native

BBCLASSEXTEND += "native"

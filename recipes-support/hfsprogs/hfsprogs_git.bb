SUMMARY = "HFS+ filesystem utilities for Linux"
DESCRIPTION = "Apple's HFS+ filesystem utilities (mkfs.hfsplus, fsck.hfsplus) \
adapted to work on Linux systems. Based on Apple's diskdev-cmds source code."
HOMEPAGE = "https://github.com/Artoria2e5/hfsprogs"

LICENSE = "APSL-2.0"
LIC_FILES_CHKSUM = "file://README.md;md5=ea27fd14a7e575753270cc5527d29023"

SRCREV = "47e4944b2abc57f5d8456ab399671a06031bbfb5"
SRC_URI = "git://github.com/elhernes/hfsprogs.git;branch=master;protocol=https"

S = "${WORKDIR}/git"

DEPENDS = "openssl libbsd"

EXTRA_OEMAKE = "-f Makefile.lnx"

CFLAGS += "-DDEBUG_BUILD=0 -D_FILE_OFFSET_BITS=64 -DLINUX=1 -DBSD=1 -I${S}/include"

do_compile() {
    oe_runmake ${EXTRA_OEMAKE}
}

do_install() {
    install -d ${D}${sbindir}
    install -d ${D}${mandir}/man8

    install -m 0755 ${S}/newfs_hfs.tproj/newfs_hfs ${D}${sbindir}/mkfs.hfsplus
    install -m 0755 ${S}/fsck_hfs.tproj/fsck_hfs ${D}${sbindir}/fsck.hfsplus

    install -m 0644 ${S}/newfs_hfs.tproj/newfs_hfs.8 ${D}${mandir}/man8/mkfs.hfsplus.8
    install -m 0644 ${S}/fsck_hfs.tproj/fsck_hfs.8 ${D}${mandir}/man8/fsck.hfsplus.8
}

BBCLASSEXTEND = "native"

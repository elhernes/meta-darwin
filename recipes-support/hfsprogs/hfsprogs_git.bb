SUMMARY = "HFS+ filesystem utilities for Linux"
DESCRIPTION = "Apple's HFS+ filesystem utilities (mkfs.hfsplus, fsck.hfsplus) \
adapted to work on Linux systems. Based on Apple's diskdev-cmds source code."
HOMEPAGE = "https://github.com/Artoria2e5/hfsprogs"
SECTION = "utils"

LICENSE = "APSL-2.0"
LIC_FILES_CHKSUM = "file://README.md;md5=49594e90ec5d532840efc48a464977a3"

SRCREV = "8caed30fc3609537ecf5f5ebcccf10509ac7d8f2"
SRC_URI = "git://github.com/Artoria2e5/hfsprogs.git;branch=master;protocol=https"

S = "${WORKDIR}/git"

# Apply the debian patches in order
SRC_URI += " \
    file://debian-patches/0001-Create-short-Makefiles-for-Debian.patch \
    file://debian-patches/0002-Add-exclude-Darwin-specific-code.patch \
    file://debian-patches/0003-Add-helper-include-files-absent-from-the-upstream-pa.patch \
    file://debian-patches/0004-Fix-compilation-on-64-bit-arches.patch \
    file://debian-patches/0005-Remove-Apple-specific-p-from-strings.patch \
    file://debian-patches/0006-Adjust-types-for-printing.patch \
    file://debian-patches/0007-Fix-path-for-HFS-wrapper-block.patch \
    file://debian-patches/0008-Provide-command-line-option-a.patch \
    file://debian-patches/0009-Rename-dprintf-to-dbg_printf.patch \
    file://debian-patches/0010-Rename-custom-macro-nil-with-NULL.patch \
    file://debian-patches/0011-Fix-types.patch \
    file://debian-patches/0012-Fix-mkfs-not-creating-UUIDs-for-new-filesystems.patch \
    file://debian-patches/0013-Fix-manpages.patch \
"

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

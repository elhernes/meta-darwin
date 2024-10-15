SUMMARY = "eXtensible ARchiver"
HOMEPAGE = "https://github.com/tpoechtrager/xar"
LICENSE = "BSD-3-Clause"
SECTION = "devel"

SRCREV = "5fa4675419cfec60ac19a9c7f7c2d0e7c831a497"
SRC_URI = " \
    git://github.com/tpoechtrager/xar.git;branch=master;protocol=https \
    file://0001-fix-compilation-error.patch \
"

inherit autotools pkgconfig

LIC_FILES_CHKSUM = "file://${WORKDIR}/git/xar/LICENSE;md5=64becc7b238f5b2d599c009ab19c2c27"

DEPENDS = "libxml2"

BBCLASSEXTEND = "native"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build"

do_configure() {
    ${S}/xar/configure --enable-autogen --prefix=${STAGING_EXECPREFIXDIR}
}

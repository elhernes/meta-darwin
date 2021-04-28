SUMMARY = "eXtensible ARchiver"
HOMEPAGE = "https://github.com/tpoechtrager/xar"
LICENSE = "BSD-3-Clause"
SECTION = "devel"

SRCREV = "2b9a4ab7003f1db8c54da4fea55fcbb424fdecb0"
SRC_URI = " \
    git://github.com/tpoechtrager/xar.git;branch=master;protocol=https \
    file://xar.patch \
"

DEPENDS = "libxml2"
PACKAGES = "${PN}-dbg ${PN} ${PN}-dev"

LIC_FILES_CHKSUM = "file://${WORKDIR}/git/xar/LICENSE;md5=64becc7b238f5b2d599c009ab19c2c27"

BBCLASSEXTEND = "native"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build"

do_configure() {
    cd ${B}
    ${S}/xar/configure --enable-autogen --prefix=${STAGING_EXECPREFIXDIR}
}

do_compile() {
    cd ${B}
    oe_runmake
}

do_install() {
   oe_runmake install 'DESTDIR=${D}'
}

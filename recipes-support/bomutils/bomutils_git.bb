SUMMARY = "Bill Of Materials Utils"
HOMEPAGE = "https://github.com/hogliux/bomutils"
LICENSE = "GPL-2.0-only"
SECTION = "devel"

SRCREV = "c247002e2f49878bab32dd0fcf805810ae0992cb"
SRC_URI = " \
    git://github.com/hogliux/bomutils.git;branch=master;protocol=https \
    file://00-dotfiles.patch \
"

LIC_FILES_CHKSUM = "file://${WORKDIR}/git/LICENSE;md5=55d923cdeef7e46b4d6415cb173b345a"

BBCLASSEXTEND = "native"

S = "${WORKDIR}/git"
B = "${WORKDIR}/git/build"

do_compile() {
    make -C ${S}
}

do_install() {
  install -d ${D}${bindir}
  install -d ${D}${mandir}/man1

  install -m 0755 ${B}/bin/ls4mkbom ${D}${bindir}
  install -m 0755 ${B}/bin/dumpbom ${D}${bindir}
  install -m 0755 ${B}/bin/lsbom ${D}${bindir}
  install -m 0755 ${B}/bin/mkbom ${D}${bindir}

  install -m 0444 ${B}/man/ls4mkbom.1.gz ${D}${mandir}/man1
  install -m 0444 ${B}/man/dumpbom.1.gz ${D}${mandir}/man1
  install -m 0444 ${B}/man/lsbom.1.gz ${D}${mandir}/man1
  install -m 0444 ${B}/man/mkbom.1.gz ${D}${mandir}/man1
}

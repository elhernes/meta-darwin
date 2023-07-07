FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "\
    file://0001-fix-wrong-libtool-path.patch \
"
do_configure:darwin21 () {
    uname=darwin ./configure --prefix=${prefix} --shared --libdir=${libdir}
}

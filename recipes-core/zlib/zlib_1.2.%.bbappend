FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "\
    file://0001-fix-wrong-libtool-path.patch \
"
do_configure:darwin19 () {
    uname=darwin ./configure --prefix=${prefix} --shared --libdir=${libdir}
}

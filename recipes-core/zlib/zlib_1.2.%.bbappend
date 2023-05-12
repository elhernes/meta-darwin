FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "\
    file://zlib-darwin.patch \
"
do_configure:darwin19 () {
    uname=darwin ./configure --prefix=${prefix} --shared --libdir=${libdir}
}

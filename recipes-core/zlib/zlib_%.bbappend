FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

DEPENDS += "libtool"

SRC_URI += "\
    file://0001-fix-wrong-libtool-path.patch \
"
do_configure:darwin21 () {
    LDCONFIG=true ${S}/configure --prefix=${prefix} --shared --libdir=${libdir} --uname=darwin
}

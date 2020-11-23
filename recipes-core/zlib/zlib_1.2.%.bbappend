FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "\
    file://zlib-darwin.patch \
"
do_configure_darwin17 (){
	uname=darwin ./configure --prefix=${prefix} --shared --libdir=${libdir}
}

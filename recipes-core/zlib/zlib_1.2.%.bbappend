FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "\
    file://zlib-darwin.patch \
"
do_configure_darwin19 (){
	uname=darwin ./configure --prefix=${prefix} --shared --libdir=${libdir}
}

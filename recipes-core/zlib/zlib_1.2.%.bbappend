FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "\
    file://zlib-darwin.patch \
"
do_configure_darwin9 (){
	uname=darwin ./configure --prefix=${prefix} --shared --libdir=${libdir}
}

FILES_${PN}_append_darwin9 = " ${libdir}/*.dylib"

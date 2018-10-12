do_configure_prepend_darwin9 () {
       sed -i  -e '3d' -e 's/lib.c/lib.c malloc.c realloc.c/' ${S}/lib/Makefile.am
}

do_compile_prepend_darwin9 () {
       sed -i ${B}/Makefile -e 's/-no-undefined//;'
}

FILES_${PN}_append_darwin9 = " ${libdir}/*.dylib"

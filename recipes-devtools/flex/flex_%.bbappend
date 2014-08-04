do_configure_prepend_darwin () {
       sed -i  -e '3d' -e 's/lib.c/lib.c malloc.c realloc.c/' ${S}/lib/Makefile.am
}

do_compile_prepend_darwin () {
       sed -i ${B}/Makefile -e 's/-no-undefined//;'
}
EX_TERMLIB_darwin9 = "yes"

base_libdir_class-nativesdk = "${libdir}"

do_install_append_class-nativesdk_darwin9() {
    rm -f ${D}${libdir}/libcurses.so
}

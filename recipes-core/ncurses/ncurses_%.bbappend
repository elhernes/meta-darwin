EX_TERMLIB_darwin17 = "yes"

base_libdir_class-nativesdk = "${libdir}"

do_install_append_class-nativesdk_darwin17() {
    rm -f ${D}${libdir}/libcurses.so
}

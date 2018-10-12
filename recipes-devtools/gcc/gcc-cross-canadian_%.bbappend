LTO_darwinsdk = "--disable-lto"
ELFUTILS_darwinsdk = ""

EXTRA_OECONF_append_darwinsdk = " \
    --with-gmp=${STAGING_EXECPREFIXDIR} \
    --with-mpft=${STAGING_EXECPREFIXDIR} \
    --with-mpc=${STAGING_EXECPREFIXDIR} \
"

EXTRA_OECONF_remove_darwinsdk = "--enable-clocale=gnu"
EXTRA_OECONF_remove_darwinsdk = "--enable-clocale=generic"

do_configure_prepend_darwinsdk() {
    export ac_cv_func_fread_unlocked="no"
}

do_compile_prepend_darwinsdk() {
    export ac_cv_func_fread_unlocked="no"
}

# Remove -rpath-link and -rpath
LDFLAGS_darwinsdk = "${BUILDSDK_LDFLAGS}"

RDEPENDS_${PN}_append_darwinsdk = " \
    nativesdk-gettext \
    nativesdk-gmp \
    nativesdk-mpfr \
    nativesdk-libmpc \
"

LTO_darwinsdk = "--disable-lto"
ELFUTILS_darwinsdk = ""

EXTRA_OECONF_append_darwinsdk = " \
    --with-gmp=${STAGING_EXECPREFIXDIR} \
    --with-mpft=${STAGING_EXECPREFIXDIR} \
    --with-mpc=${STAGING_EXECPREFIXDIR} \
"

EXTRA_OECONF_remove_darwinsdk = "--enable-clocale=gnu"
EXTRA_OECONF_remove_darwinsdk = "--enable-clocale=generic"

# Remove -rpath-link and -rpath
LDFLAGS_darwinsdk = "${BUILDSDK_LDFLAGS}"

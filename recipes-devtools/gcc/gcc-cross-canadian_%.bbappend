LTO:darwinsdk = "--disable-lto"
ELFUTILS:darwinsdk = ""

EXTRA_OECONF:append:darwinsdk = " \
    --with-gmp=${STAGING_EXECPREFIXDIR} \
    --with-mpft=${STAGING_EXECPREFIXDIR} \
    --with-mpc=${STAGING_EXECPREFIXDIR} \
"

EXTRA_OECONF:remove:darwinsdk = "--enable-clocale=gnu"
EXTRA_OECONF:remove:darwinsdk = "--enable-clocale=generic"

# Remove -rpath-link and -rpath
LDFLAGS:darwinsdk = "${BUILDSDK_LDFLAGS}"

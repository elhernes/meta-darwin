PACKAGECONFIG:remove = "python"
PACKAGECONFIG:remove = "debuginfod"

EXTRA_OECONF:append:darwinsdk = " \
    --with-gmp=${STAGING_EXECPREFIXDIR} \
    --with-mpft=${STAGING_EXECPREFIXDIR} \
    --with-mpc=${STAGING_EXECPREFIXDIR} \
"

EXTRA_OECONF:remove:darwinsdk = "--disable-gas"
EXTRA_OECONF:remove:darwinsdk = "--disable-binutils"
EXTRA_OECONF:remove:darwinsdk = "--disable-ld"
EXTRA_OECONF:remove:darwinsdk = "--disable-gold"
EXTRA_OECONF:remove:darwinsdk = "--with-system-readline"

# Remove -rpath-link and -rpath
LDFLAGS:darwinsdk = "${BUILDSDK_LDFLAGS}"

INSANE_SKIP:append:darwin21 = " buildpaths"

PACKAGECONFIG:remove = "python"
PACKAGECONFIG:remove = "debuginfod"

EXTRA_OECONF:append:darwinsdk = " \
    --with-gmp=${STAGING_EXECPREFIXDIR} \
    --with-mpfr=${STAGING_EXECPREFIXDIR} \
    --with-mpc=${STAGING_EXECPREFIXDIR} \
"

EXTRA_OECONF:remove:darwinsdk = "--disable-gas"
EXTRA_OECONF:remove:darwinsdk = "--disable-binutils"
EXTRA_OECONF:remove:darwinsdk = "--disable-ld"
EXTRA_OECONF:remove:darwinsdk = "--disable-gold"
EXTRA_OECONF:remove:darwinsdk = "--with-system-readline"

# Remove -rpath-link and -rpath
LDFLAGS:darwinsdk = "${BUILDSDK_LDFLAGS}"

do_compile:append:darwinsdk() {
    ${SDK_PREFIX}install_name_tool -change libexpat.1.dylib @loader_path/../../lib/libexpat.1.dylib ${B}/gdb/gdb
}

DEPENDS:append:darwinsdk = " nativesdk-zlib "

INSANE_SKIP:append:darwinsdk = " buildpaths"

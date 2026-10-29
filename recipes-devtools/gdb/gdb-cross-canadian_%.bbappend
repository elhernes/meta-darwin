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

# The PACKAGECONFIG's --with-liblzma-prefix=${STAGING_DIR_HOST} doesn't find
# lzma.h/liblzma, which are installed below the SDK prefix in the sysroot.
EXTRA_OECONF:append:darwinsdk = " --with-liblzma-prefix=${STAGING_EXECPREFIXDIR}"

# The Darwin cross-GCC places its section anchor (lANCHOR0, an alt_entry
# symbol) at the start of __TEXT,__const when a switch table is the first
# atom there (elfread.o), and ld64 rejects the object: "N_ALT_ENTRY bit set
# on first atom in section __TEXT/__const".
CFLAGS:append:darwinsdk = " -fno-section-anchors"
CXXFLAGS:append:darwinsdk = " -fno-section-anchors"

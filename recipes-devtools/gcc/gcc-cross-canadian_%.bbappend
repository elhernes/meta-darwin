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

# zstd uses uname to determine the compiler's target and makes the assumption that the host OS is the target,
# so it does not support Darwin as a cross-compiler target.
# zstd is not really needed as a dependency of gcc, and zstd would need to be fixed to compile for Darwin
DEPENDS:remove = "nativesdk-zstd"

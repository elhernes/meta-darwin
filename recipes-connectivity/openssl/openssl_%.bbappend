
do_configure:darwin21 () {
    target="${@'darwin64-arm64-cc' if d.getVar('SDK_ARCH') == 'aarch64' else 'darwin64-x86_64-cc'}"

    useprefix=${prefix}
    if [ "x$useprefix" = "x" ]; then
        useprefix=/
    fi
    # WARNING: do not set compiler/linker flags (-I/-D etc.) in EXTRA_OECONF, as they will fully replace the
    # environment variables set by bitbake. Adjust the environment variables instead.
    PERLEXTERNAL="$(realpath ${S}/external/perl/Text-Template-*/lib)"
    test -d "$PERLEXTERNAL" || bberror "PERLEXTERNAL '$PERLEXTERNAL' not found!"
    HASHBANGPERL="/usr/bin/env perl" PERL=perl PERL5LIB="$PERLEXTERNAL" \
    perl ${S}/Configure ${EXTRA_OECONF} ${PACKAGECONFIG_CONFARGS} ${DEPRECATED_CRYPTO_FLAGS} --prefix=$useprefix --openssldir=${libdir}/ssl-3 --libdir=${libdir} $target
    perl ${B}/configdata.pm --dump
}

RDEPENDS:${PN}-misc:remove = "perl"
RDEPENDS:${PN}-ptest:remove = "openssl-bin"
RDEPENDS:${PN}-ptest:remove = "perl"
RDEPENDS:${PN}-ptest:remove = "perl-modules"
RDEPENDS:${PN}-ptest:remove = "bash"
RDEPENDS:${PN}-ptest:remove = "sed"
RDEPENDS:${PN}-ptest:remove = "openssl-engines"
RDEPENDS:${PN}-ptest:remove = "openssl-ossl-module-legacy"


do_configure:darwin21 () {
    target=darwin64-arm64-cc

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

RDEPENDS:remove:${PN}-misc = "perl"
RDEPENDS:remove:${PN}-ptest = "openssl-bin"
RDEPENDS:remove:${PN}-ptest = "perl"
RDEPENDS:remove:${PN}-ptest = "perl-modules"
RDEPENDS:remove:${PN}-ptest = "bash"
RDEPENDS:remove:${PN}-ptest = "sed"
RDEPENDS:remove:${PN}-ptest = "openssl-engines"
RDEPENDS:remove:${PN}-ptest = "openssl-ossl-module-legacy"

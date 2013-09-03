LTO_darwin = "--disable-lto"
SYSTEMHEADERS_darwin = "/usr/include/"

EXTRA_OECONF_darwin := "${@oe_filter_out('--with-linker-hash-style=${LINKER_HASH_STYLE}', '${EXTRA_OECONF}', d)}"
EXTRA_OECONF_darwin := "${@oe_filter_out('--with-gnu-ld', '${EXTRA_OECONF}', d)}"
EXTRA_OECONF_darwin := "${@oe_filter_out('--enable-libssp', '${EXTRA_OECONF}', d)}"
EXTRA_OECONF_darwin := "${@oe_filter_out('--with-gxx-include-dir=${STAGING_DIR_TARGET}${target_includedir}/c\+\+', '${EXTRA_OECONF}', d)}"
EXTRA_OECONF_append_darwin = " --disable-libssp"
EXTRA_OECONF_append_darwin = " --with-gxx-include-dir=${STAGING_DIR_TARGET}/usr/include/c++/4.2.1"

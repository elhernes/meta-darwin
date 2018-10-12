LTO_darwin9 = "--disable-lto"
SYSTEMHEADERS_darwin9 = "${SDKPATHNATIVE}/runtime/usr/include/"

EXTRA_OECONF_remove_darwin9 = "--with-linker-hash-style=${LINKER_HASH_STYLE}"
EXTRA_OECONF_remove_darwin9 = "--with-gnu-ld"
EXTRA_OECONF_remove_darwin9 = "--enable-clocale=gnu"
EXTRA_OECONF_remove_darwin9 = "--enable-clocale=generic"

EXTRA_OECONF_remove_darwin9 = "--enable-initfini-array"
EXTRA_OECONF_append_darwin9 = " --disable-initfini-array"

do_configure_prepend_darwin9 () {
    export ARCH_FLAGS_FOR_TARGET=" $ARCH_FLAGS_FOR_TARGET \
        -L${STAGING_DIR_TARGET}${SDKPATHNATIVE}/usr/lib \
        -L${STAGING_DIR_TARGET}${SDKPATHNATIVE}/runtime/usr/lib \
        -L${STAGING_DIR_TARGET}${SDKPATHNATIVE}/runtime/usr/lib/system \
    "
}

do_compile_append_darwin9 () {
    oe_runmake all-target-libgcc MULTIBUILDTOP=${B}/${TARGET_SYS}/libgcc/
}
do_install_append_darwin9 () {
    oe_runmake 'DESTDIR=${D}' MULTIBUILDTOP=${B}/${TARGET_SYS}/libgcc/ install-target-libgcc
}

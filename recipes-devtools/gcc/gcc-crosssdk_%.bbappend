SYSTEMHEADERS_darwin19 = "${SDKPATHNATIVE}/runtime/usr/include/"

LINKER_HASH_STYLE_darwin19 = ""

EXTRA_OECONF_remove_darwin19 = "--enable-clocale=gnu"
EXTRA_OECONF_remove_darwin19 = "--enable-clocale=generic"

EXTRA_OECONF_remove_darwin19 = "--enable-initfini-array"
EXTRA_OECONF_append_darwin19 = " --disable-initfini-array"

LTO_darwin19 = "--disable-lto"
EXTRA_OECONF_remove_darwin19 = "--enable-lto"
EXTRA_OECONF_append_darwin19 = " --disable-lto"

DEPENDS_append_darwin19 = " nativesdk-osx-runtime"

do_configure_prepend_darwin19 () {
    export ARCH_FLAGS_FOR_TARGET=" $ARCH_FLAGS_FOR_TARGET \
        -L${SDKPATHNATIVE}/usr/lib \
        -L${SDKPATHNATIVE}/runtime/usr/lib \
        -L${SDKPATHNATIVE}/runtime/usr/lib/system \
    "
}

#do_compile_append_darwin19 () {
#    oe_runmake all-target-libgcc MULTIBUILDTOP=${B}/${TARGET_SYS}/libgcc/
#}
#do_install_append_darwin19 () {
#    oe_runmake 'DESTDIR=${D}' MULTIBUILDTOP=${B}/${TARGET_SYS}/libgcc/ install-target-libgcc
#}

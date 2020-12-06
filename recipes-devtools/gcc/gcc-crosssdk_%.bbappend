SYSTEMHEADERS_darwin17 = "${SDKPATHNATIVE}/runtime/usr/include/"

LINKER_HASH_STYLE_darwin17 = ""

EXTRA_OECONF_remove_darwin17 = "--enable-clocale=gnu"
EXTRA_OECONF_remove_darwin17 = "--enable-clocale=generic"

EXTRA_OECONF_remove_darwin17 = "--enable-initfini-array"
EXTRA_OECONF_append_darwin17 = " --disable-initfini-array"

LTO_darwin17 = "--disable-lto"
EXTRA_OECONF_remove_darwin17 = "--enable-lto"
EXTRA_OECONF_append_darwin17 = " --disable-lto"

DEPENDS_append_darwin17 = " nativesdk-osx-runtime"

do_configure_prepend_darwin17 () {
    export ARCH_FLAGS_FOR_TARGET=" $ARCH_FLAGS_FOR_TARGET \
        -L${SDKPATHNATIVE}/usr/lib \
        -L${SDKPATHNATIVE}/runtime/usr/lib \
        -L${SDKPATHNATIVE}/runtime/usr/lib/system \
    "
}

#do_compile_append_darwin17 () {
#    oe_runmake all-target-libgcc MULTIBUILDTOP=${B}/${TARGET_SYS}/libgcc/
#}
#do_install_append_darwin17 () {
#    oe_runmake 'DESTDIR=${D}' MULTIBUILDTOP=${B}/${TARGET_SYS}/libgcc/ install-target-libgcc
#}

SYSTEMHEADERS:darwin19 = "${SDKPATHNATIVE}/runtime/usr/include/"

LINKER_HASH_STYLE:darwin19 = ""

EXTRA_OECONF:remove:darwin19 = "--enable-clocale=gnu"
EXTRA_OECONF:remove:darwin19 = "--enable-clocale=generic"

EXTRA_OECONF:remove:darwin19 = "--enable-initfini-array"
EXTRA_OECONF:append:darwin19 = " --disable-initfini-array"

LTO:darwin19 = "--disable-lto"
EXTRA_OECONF:remove:darwin19 = "--enable-lto"
EXTRA_OECONF:append:darwin19 = " --disable-lto"

DEPENDS:append:darwin19 = " nativesdk-osx-runtime"

do_configure:prepend:darwin19 () {
    export ARCH_FLAGS_FOR_TARGET=" $ARCH_FLAGS_FOR_TARGET \
        -L${SDKPATHNATIVE}/usr/lib \
        -L${SDKPATHNATIVE}/runtime/usr/lib \
        -L${SDKPATHNATIVE}/runtime/usr/lib/system \
    "
}

#do_compile:append:darwin19 () {
#    oe_runmake all-target-libgcc MULTIBUILDTOP=${B}/${TARGET_SYS}/libgcc/
#}
#do_install:append:darwin19 () {
#    oe_runmake 'DESTDIR=${D}' MULTIBUILDTOP=${B}/${TARGET_SYS}/libgcc/ install-target-libgcc
#}

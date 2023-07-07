SYSTEMHEADERS:darwin21 = "${SDKPATHNATIVE}/runtime/usr/include/"

LINKER_HASH_STYLE:darwin21 = ""

EXTRA_OECONF:remove:darwin21 = "--enable-clocale=gnu"
EXTRA_OECONF:remove:darwin21 = "--enable-clocale=generic"

EXTRA_OECONF:remove:darwin21 = "--enable-initfini-array"
EXTRA_OECONF:append:darwin21 = " --disable-initfini-array"

LTO:darwin21 = "--disable-lto"
EXTRA_OECONF:remove:darwin21 = "--enable-lto"
EXTRA_OECONF:append:darwin21 = " --disable-lto"

DEPENDS:append:darwin21 = " nativesdk-osx-runtime"

do_configure:prepend:darwin21 () {
    export ARCH_FLAGS_FOR_TARGET=" $ARCH_FLAGS_FOR_TARGET \
        -L${SDKPATHNATIVE}/usr/lib \
        -L${SDKPATHNATIVE}/runtime/usr/lib \
        -L${SDKPATHNATIVE}/runtime/usr/lib/system \
    "
}

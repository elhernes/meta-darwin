SRC_URI = "git://git.saurik.com/llvm-gcc-4.2;protocol=git \
           file://gcc41-configure.in.patch;patch=1 \
           file://hacking.patch;patch=1"

PV = "0.0+${SRCREV}"
PR = "r3"

S = "${WORKDIR}/git"
B = "${S}/build.${HOST_SYS}.${TARGET_SYS}"

DEPENDS = "bison-native flex-native apple-headers iphone-rootfs"

inherit autotools sdk

EXTRA_OECONF += "\
    --enable-languages=c,c++,objc,obj-c++ \
    --target=arm-apple-darwin8 \
    --enable-sjlj-exceptions \
    --enable-wchar_t=no \
    --with-gxx-include-dir=${STAGING_DIR_TARGET}/${layout_includedir}/c++ \
    --with-sysroot=${prefix}/${TARGET_SYS} \
    --with-build-sysroot=${STAGING_DIR_TARGET} \
    --with-local-prefix=${STAGING_DIR_TARGET}${layout_prefix} \
    "

do_configure () {
	(cd ${S} && gnu-configize) || die "failure running gnu-configize"
	oe_runconf
}

export ARCH_FLAGS_FOR_TARGET = "--sysroot=${STAGING_DIR_TARGET}"

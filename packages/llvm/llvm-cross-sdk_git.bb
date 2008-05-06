SRC_URI = "git://git.saurik.com/llvm-gcc-4.2;protocol=git"

PV = "0.0+${SRCREV}"
PR = "r2"

S = "${WORKDIR}/git"
B = "${S}/build.${HOST_SYS}.${TARGET_SYS}"

DEPENDS = "bison-native flex-native apple-headers iphone-rootfs"

inherit autotools sdk

EXTRA_OECONF += "\
    --enable-languages=c,c++,objc,obj-c++ \
    --target=arm-apple-darwin8 \
    --enable-sjlj-exceptions \
    --enable-wchar_t=no \
    --with-sysroot=${prefix}/${TARGET_SYS} \
    --with-build-sysroot=${STAGING_DIR_TARGET} \
    --with-local-prefix=${STAGING_DIR_TARGET}${layout_prefix} \
    "

do_configure () {
	(cd ${S} && gnu-configize) || die "failure running gnu-configize"
	oe_runconf
}
	
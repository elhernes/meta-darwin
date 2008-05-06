
SRC_URI = "git://git.saurik.com/llvm-gcc-4.2;protocol=git"

PV = "0.0+${SRCREV}"

S = "${WORKDIR}/git"

B = "${S}/build.${HOST_SYS}.${TARGET_SYS}"

export LLVMOBJDIR = "${TMPDIR}/work/${MULTIMACH_ARCH}${HOST_VENDOR}-${HOST_OS}//llvm-native-0.0+42498-r0"

DEPENDS = "llvm-native bison-native flex-native apple-headers iphone-rootfs"

#CC[unexport] = "1"
#CFLAGS[unexport] = "1"
#LDFLAGS[unexport] = "1"
#CPPFLAGS[unexport] = "1"

inherit autotools sdk

#    --enable-llvm=`llvm-config --obj-root` \
#    --with-heavenly=${TMPDIR}/work/${MULTIMACH_ARCH}${TARGET_VENDOR}-${TARGET_OS}/iphone-rootfs-0.0-r0 \

EXTRA_OECONF = "\
    --enable-languages=c,c++,objc,obj-c++ \
    --target=arm-apple-darwin8 \
    --enable-sjlj-exceptions \
    --enable-wchar_t=no \
    --with-as=${CROSS_DIR}/bin/arm-apple-darwin8-as \
    --with-ld=${CROSS_DIR}/bin/arm-apple-darwin8-ld \
    "

#EXTRA_OEMAKE = "LLVM_VERSION_INFO=2.0-svn-iphone-dev-0.3-svn"

do_configure () {
	# No --host since it gets passed to sub configures and isn't always
	# right for sections like libstdc++
	# --host=${HOST_SYS}
	${S}/configure \
	--build=${BUILD_SYS} \
	--host=${HOST_SYS} \
	--target=${TARGET_SYS} \
	--prefix=${prefix} \
	--exec_prefix=${exec_prefix} \
	--bindir=${bindir} \
	--sbindir=${sbindir} \
	--libexecdir=${libexecdir} \
	--datadir=${datadir} \
	--sysconfdir=${sysconfdir} \
	--sharedstatedir=${sharedstatedir} \
	--localstatedir=${localstatedir} \
	--libdir=${libdir} \
	--includedir=${includedir} \
	--oldincludedir=${oldincludedir} \
	--infodir=${infodir} \
	--mandir=${mandir} \
	--with-sysroot=${prefix}/${TARGET_SYS} \
	--with-build-sysroot=${STAGING_DIR_TARGET} \
        --with-local-prefix=${STAGING_DIR_TARGET}${layout_prefix} \
	${EXTRA_OECONF}
}

#	--with-local-prefix=${STAGING_DIR_TARGET}${layout_prefix} \
#	--with-sysroot=${prefix}${TARGET_SYS} \
#	--with-build-sysroot=${STAGING_DIR_TARGET} \



SRC_URI = "svn://iphone-dev.googlecode.com/svn/trunk;proto=http;module=llvm-gcc-4.0-iphone"

PV = "0.0+${SRCREV}"

S = "${WORKDIR}/llvm-gcc-4.0-iphone"

B = "${S}/build.${HOST_SYS}.${TARGET_SYS}"

export LLVMOBJDIR = "${TMPDIR}/work/${MULTIMACH_ARCH}${HOST_VENDOR}-${HOST_OS}//llvm-native-0.0+42498-r0"
#PARALLEL_MAKE = ""

PROVIDES = "virtual/${TARGET_PREFIX}gcc virtual/${TARGET_PREFIX}g++"
DEPENDS = "virtual/${TARGET_PREFIX}binutils llvm-native bison-native flex-native"

CC[unexport] = "1"
CFLAGS[unexport] = "1"
LDFLAGS[unexport] = "1"
CPPFLAGS[unexport] = "1"

inherit autotools cross

#    --enable-languages=c,c++,objc,obj-c++ \

EXTRA_OECONF = "\
    --enable-llvm=`llvm-config --obj-root` \
    --enable-languages=c,c++,objc,obj-c++ \
    --target=arm-apple-darwin \
    --enable-sjlj-exceptions \
    --with-heavenly=${TMPDIR}/work/${MULTIMACH_ARCH}${TARGET_VENDOR}-${TARGET_OS}/iphone-rootfs-0.0-r0 \
    --with-as=${CROSS_DIR}/bin/arm-apple-darwin-as \
    --with-ld=${CROSS_DIR}/bin/arm-apple-darwin-ld \
    "

EXTRA_OEMAKE = "LLVM_VERSION_INFO=2.0-svn-iphone-dev-0.3-svn"

do_configure () {
	# No --host since it gets passed to sub configures and isn't always
	# right for sections like libstdc++
	# --host=${HOST_SYS}
	${S}/configure \
	--build=${BUILD_SYS} \
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
	${EXTRA_OECONF}
}

#	--with-local-prefix=${STAGING_DIR_TARGET}${layout_prefix} \
#	--with-sysroot=${STAGING_DIR_TARGET} \
#	--with-build-sysroot=${STAGING_DIR_TARGET} \


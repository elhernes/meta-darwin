DEPENDS:remove:class-nativesdk:darwin21 = "nativesdk-python3"
DEPENDS:remove:class-nativesdk:darwin21 = "libxml2"
DEPENDS:remove:class-nativesdk:darwin21 = "libffi"
DEPENDS:append:class-nativesdk:darwin21 = " xz"
PACKAGECONFIG:remove:class-nativesdk:darwin21 = "libedit"
PACKAGECONFIG:remove:class-nativesdk:darwin21 = "shared-libs"

DEPENDS:remove:class-nativesdk = "clang-crosssdk-${SDK_ARCH}"
DEPENDS:append:class-nativesdk = " clang-crosssdk-${SDK_SYS}"

# perl tries to call readelf, which does not exist on darwin (it would need
# to call objdump instead but the detection logic does not work for some reason)
RDEPENDS:${PN}-tools:remove:class-nativesdk:darwin21 = " \
    perl-module-digest-md5 \
    perl-module-file-basename \
    perl-module-file-copy \
    perl-module-file-find \
    perl-module-file-path \
    perl-module-findbin \
    perl-module-hash-util \
    perl-module-sys-hostname \
    perl-module-term-ansicolor \
"

COMPILER_RT:class-nativesdk:toolchain-clang:runtime-llvm:darwin21 = ""
LIBCPLUSPLUS:class-nativesdk:toolchain-clang:darwin21 = " -stdlib=libstdc++"

OSXSDK:class-nativesdk:darwin21 = "${STAGING_DIR_TARGET}${SDKPATHNATIVE}/runtime"
do_compile:prepend:class-nativesdk:darwin21() {
    export YOCTO_SDKPATH="${OSXSDK}/usr/include"
}

LDFLAGS:toolchain-clang:class-nativesdk:darwin21 = " \
    ${BUILDSDK_LDFLAGS} \
    -lgcc_s \
"
LDFLAGS:remove:toolchain-clang:class-nativesdk:x86-64:darwin21 = " -Wl,-dynamic-linker,${base_libdir}/ld-linux-x86-64.so.2"
LDFLAGS:remove:toolchain-clang:class-nativesdk:x86:darwin21 = " -Wl,-dynamic-linker,${base_libdir}/ld-linux.so.2"
LDFLAGS:remove:toolchain-clang:class-nativesdk:aarch64:darwin21 = " -Wl,-dynamic-linker,${base_libdir}/ld-linux-aarch64.so.1"

CFLAGS:append:class-nativesdk:darwin21 = " \
    -femulated-tls \
    -I${OSXSDK}/usr/include \
    -include TargetConditionals.h \
"

CXXFLAGS:append:class-nativesdk:darwin21 = " \
    -femulated-tls \
    -Wno-elaborated-enum-base \
    -I${OSXSDK}/usr/include \
    -include TargetConditionals.h \
    -F${OSXSDK}/System/Library/Frameworks \
    -F${OSXSDK}/System/Library/Frameworks/CoreServices.framework/Frameworks \
"

EXTRA_OECMAKE:remove:class-nativesdk:darwin21 = "-DPYTHON_LIBRARY=${STAGING_LIBDIR}/lib${PYTHON_DIR}${PYTHON_ABI}.so"
EXTRA_OECMAKE:remove:class-nativesdk:darwin21 = "-DPYTHON_INCLUDE_DIR=${STAGING_INCDIR}/${PYTHON_DIR}${PYTHON_ABI}"
EXTRA_OECMAKE:remove:class-nativesdk:darwin21 = "-DPYTHON_EXECUTABLE='${PYTHON}'"
EXTRA_OECMAKE:append:class-nativesdk:darwin21 = " \
    -DCMAKE_FRAMEWORK_PATH='${OSXSDK}/System/Library/Frameworks'\
    -DLLDB_USE_SYSTEM_DEBUGSERVER=ON \
    -DLLDB_INCLUDE_TESTS=OFF \
    -DLLDB_ENABLE_PYTHON=OFF \
    \
    -DLLDB_ENABLE_LZMA=ON \
    \
    -DLLVM_ENABLE_LIBEDIT=ON -DLLDB_ENABLE_LIBEDIT=ON \
    -DLibEdit_LIBRARIES=${OSXSDK}/usr/lib/libedit.tbd \
    -DLibEdit_INCLUDE_DIRS=${OSXSDK}/usr/include \
    \
    -DCURSES_INCLUDE_DIRS=${OSXSDK}/usr/include \
    -DCURSES_LIBRARIES=${OSXSDK}/usr/lib/libcurses.tbd \
    -DPANEL_LIBRARIES=${OSXSDK}/usr/lib/libpanel.tbd \
    \
    -DLIBXML2_INCLUDE_DIR=${OSXSDK}/usr/include/libxml2 \
    -DLIBXML2_LIBRARY=${OSXSDK}/usr/lib/libxml2.tbd \
    \
    -DFFI_LIBRARY_PATH=${OSXSDK}/usr/lib/libffi.tbd \
    -DFFI_INCLUDE_PATH=${OSXSDK}/usr/include \
"

FILES:${PN} += " \
   ${libdir}/LLVMgold.dylib \
"

do_compile:append:class-nativesdk:darwin21() {
    ${SDK_PREFIX}install_name_tool -change liblldb.18.1.6.dylib @loader_path/../lib/liblldb.18.1.6.dylib ${B}/bin/lldb-dap
}

INSANE_SKIP:${PN}:class-nativesdk:darwin21 += " file-rdeps"

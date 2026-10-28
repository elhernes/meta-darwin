OSXSDK:class-nativesdk:darwin21 = "${STAGING_DIR_TARGET}${SDKPATHNATIVE}/runtime"

# The base recipe's COMPATIBLE_HOST only matches "-linux" host triples,
# filtering out this darwin21 SDK build entirely.
COMPATIBLE_HOST:class-nativesdk:darwin21 = ".*-darwin.*"

# On darwin21 we link against the target OSX SDK's own stub (.tbd) libraries
# instead of cross-building libedit for the target, mirroring the darwin
# nativesdk-clang bbappend's own PACKAGECONFIG:remove for "libedit".
PACKAGECONFIG:remove:class-nativesdk:darwin21 = "libedit"

CFLAGS:append:class-nativesdk:darwin21 = " \
    -I${OSXSDK}/usr/include \
    -include TargetConditionals.h \
"
CXXFLAGS:append:class-nativesdk:darwin21 = " \
    -I${OSXSDK}/usr/include \
    -include TargetConditionals.h \
    -F${OSXSDK}/System/Library/Frameworks \
    -F${OSXSDK}/System/Library/Frameworks/CoreServices.framework/Frameworks \
"

EXTRA_OECMAKE:append:class-nativesdk:darwin21 = " \
    -DCMAKE_FRAMEWORK_PATH='${OSXSDK}/System/Library/Frameworks' \
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
    \
    -DCMAKE_INSTALL_RPATH=@loader_path/../lib \
"

# Without CMAKE_INSTALL_RPATH above, lldb's only rpath is the hardcoded build
# path from LDFLAGS (-Wl,-rpath,${libdir}).  finalize-sdk.sh only relocates
# text files, so lldb, lldb-dap, liblldb etc. couldn't find libLLVM,
# libclang-cpp or liblldb once installed.  Everything lldb ships sits in
# bin/ or lib/, so @loader_path/../lib reaches usr/lib from both.

do_compile:append:class-nativesdk:darwin21() {
    ${SDK_PREFIX}install_name_tool -change liblldb.${PV}.dylib @loader_path/../lib/liblldb.${PV}.dylib ${B}/bin/lldb-dap
}

# lldb-dap's rewritten @loader_path reference to liblldb.dylib trips the
# same file-rdeps QA check that nativesdk-clang already skips for darwin21.
INSANE_SKIP:${PN}:class-nativesdk:darwin21 += " file-rdeps"

# Python support is disabled above (LLDB_ENABLE_PYTHON=OFF), but lldb inherits
# python3targetconfig, which adds nativesdk-python3 to DEPENDS. That recipe
# doesn't configure for darwin21 (sw_vers is missing), so drop the dependency.
EXTRA_PYTHON_DEPENDS:class-nativesdk:darwin21 = ""

# lldb's macOS host support is Objective-C++ (Host.mm etc.), which the Darwin
# cross-GCC can't compile. Build with the clang-crosssdk compiler instead, with
# the same toolchain-clang adjustments as the nativesdk-clang bbappend.
PREFERRED_TOOLCHAIN_SDK = "clang"

COMPILER_RT:class-nativesdk:toolchain-clang:runtime-llvm:darwin21 = ""
LIBCPLUSPLUS:class-nativesdk:toolchain-clang:darwin21 = " -stdlib=libstdc++"

LDFLAGS:toolchain-clang:class-nativesdk:darwin21 = " \
    ${BUILDSDK_LDFLAGS} \
    -lgcc_s \
"
LDFLAGS:remove:toolchain-clang:class-nativesdk:x86-64:darwin21 = " -Wl,-dynamic-linker,${base_libdir}/ld-linux-x86-64.so.2"
LDFLAGS:remove:toolchain-clang:class-nativesdk:aarch64:darwin21 = " -Wl,-dynamic-linker,${base_libdir}/ld-linux-aarch64.so.1"

CFLAGS:append:class-nativesdk:toolchain-clang:darwin21 = " -femulated-tls"
CXXFLAGS:append:class-nativesdk:toolchain-clang:darwin21 = " -femulated-tls -Wno-elaborated-enum-base"

# clang.bbclass adds compiler-rt and libcxx to BASE_DEFAULT_DEPS, but the
# nativesdk uses GCC's libgcc_s and libstdc++ (see LDFLAGS/LIBCPLUSPLUS above).
BASE_DEFAULT_DEPS:remove:class-nativesdk:toolchain-clang:darwin21 = " compiler-rt libcxx"

# clang defaults to libc++, but the nativesdk ships GCC's libstdc++. The Darwin
# clang driver patch (0037) finds its headers via YOCTO_SDKPATH.
CXXFLAGS:append:class-nativesdk:toolchain-clang:darwin21 = " -stdlib=libstdc++"
LDFLAGS:append:class-nativesdk:toolchain-clang:darwin21 = " -stdlib=libstdc++"

do_configure:prepend:class-nativesdk:darwin21() {
    export YOCTO_SDKPATH="${OSXSDK}/usr/include"
}
do_compile:prepend:class-nativesdk:darwin21() {
    export YOCTO_SDKPATH="${OSXSDK}/usr/include"
}

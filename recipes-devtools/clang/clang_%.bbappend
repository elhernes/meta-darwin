DEPENDS_remove_class-nativesdk_darwin19 = "nativesdk-python3"
DEPENDS_remove_class-nativesdk_darwin19 = "libxml2"
DEPENDS_remove_class-nativesdk_darwin19 = "libffi"
DEPENDS_append_class-nativesdk_darwin19 = " xz"
PACKAGECONFIG_remove_class-nativesdk_darwin19 = "libedit"
PACKAGECONFIG_remove_class-nativesdk_darwin19 = "shared-libs"

DEPENDS_remove_class-nativesdk = "clang-crosssdk-${SDK_ARCH}"
DEPENDS_append_class-nativesdk = " clang-crosssdk-${SDK_SYS}"

LDFLAGS_toolchain-clang_class-nativesdk_darwin19 = "${BUILDSDK_LDFLAGS}"
LDFLAGS_remove_toolchain-clang_class-nativesdk_x86-64_darwin19 = " -Wl,-dynamic-linker,${base_libdir}/ld-linux-x86-64.so.2"
LDFLAGS_remove_toolchain-clang_class-nativesdk_x86_darwin19 = " -Wl,-dynamic-linker,${base_libdir}/ld-linux.so.2"
LDFLAGS_remove_toolchain-clang_class-nativesdk_aarch64_darwin19 = " -Wl,-dynamic-linker,${base_libdir}/ld-linux-aarch64.so.1"

OSXSDK_class-nativesdk_darwin19 = "${STAGING_DIR_TARGET}${SDKPATHNATIVE}/runtime"

cmake_do_generate_toolchain_file_append_class-nativesdk_darwin19() {
    sed -i ${WORKDIR}/toolchain.cmake -e"s/set( CMAKE_SYSTEM_NAME darwin19 )/set( CMAKE_SYSTEM_NAME Darwin )/g"
    cat >> ${WORKDIR}/toolchain.cmake <<EOF
set(CMAKE_SHARED_LINKER_FLAGS "\${CMAKE_SHARED_LINKER_FLAGS} -lgcc_s")
set(CMAKE_EXE_LINKER_FLAGS "\${CMAKE_EXE_LINKER_FLAGS} -lgcc_s")
set(CMAKE_C_FLAGS "\${CMAKE_C_FLAGS} -include TargetConditionals.h -I${OSXSDK}/usr/include -femulated-tls -Wno-elaborated-enum-base -Wno-gnu-zero-variadic-macro-arguments")
set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -include TargetConditionals.h -I${OSXSDK}/usr/include -F${OSXSDK}/System/Library/Frameworks -F${OSXSDK}/System/Library/Frameworks/CoreServices.framework/Frameworks -femulated-tls -Wno-elaborated-enum-base -Wno-gnu-zero-variadic-macro-arguments")
EOF
}

do_generate_native_toolchain_file_append_class-nativesdk_darwin19() {
    cat >> ${WORKDIR}/toolchain-native.cmake <<EOF
set(CMAKE_EXE_LINKER_FLAGS "${BUILD_LDFLAGS}" CACHE STRING "LDFLAGS" )
set(CMAKE_SHARED_LINKER_FLAGS "${BUILD_LDFLAGS}" CACHE STRING "LDFLAGS" )
EOF
}

EXTRA_OECMAKE_remove_class-nativesdk_darwin19 = "-DPYTHON_LIBRARY=${STAGING_LIBDIR}/lib${PYTHON_DIR}${PYTHON_ABI}.so"
EXTRA_OECMAKE_remove_class-nativesdk_darwin19 = "-DPYTHON_INCLUDE_DIR=${STAGING_INCDIR}/${PYTHON_DIR}${PYTHON_ABI}"
EXTRA_OECMAKE_remove_class-nativesdk_darwin19 = "-DPYTHON_EXECUTABLE='${PYTHON}'"
EXTRA_OECMAKE_append_class-nativesdk_darwin19 = " \
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
EXTRA_OECMAKE_append_class-native = " \
    -DCLANG_DEFAULT_CXX_STDLIB=libstdc++ \
"

FILES_${PN} += " \
   ${libdir}/LLVMgold.dylib \
"

INSANE_SKIP_${PN}_class-nativesdk_darwin19 += " file-rdeps"

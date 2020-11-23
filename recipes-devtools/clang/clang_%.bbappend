TOOLCHAIN_OPTIONS_prepend_darwin17_class-nativesdk = " \
    -I${STAGING_DIR_TARGET}${SDKPATHNATIVE}/runtime/usr/include \
"

DEPENDS_remove_class-nativesdk_darwin17 = "nativesdk-python3"

LDFLAGS_toolchain-clang_class-nativesdk_darwin17 = "${BUILDSDK_LDFLAGS}"
LDFLAGS_remove_class-nativesdk_darwin17 = "-fuse-ld=gold"
LDFLAGS_remove_toolchain-clang_class-nativesdk_x86-64_darwin17 = " -Wl,-dynamic-linker,${base_libdir}/ld-linux-x86-64.so.2"
LDFLAGS_remove_toolchain-clang_class-nativesdk_x86_darwin17 = " -Wl,-dynamic-linker,${base_libdir}/ld-linux.so.2"
LDFLAGS_remove_toolchain-clang_class-nativesdk_aarch64_darwin17 = " -Wl,-dynamic-linker,${base_libdir}/ld-linux-aarch64.so.1"

# change cmake.class to target Darwin instead of darwin17
cmake_do_generate_toolchain_file_append_class-nativesdk_darwin17() {
    sed -i ${WORKDIR}/toolchain.cmake -e"s/set( CMAKE_SYSTEM_NAME darwin17 )/set( CMAKE_SYSTEM_NAME Darwin )/g"
    cat >> ${WORKDIR}/toolchain.cmake <<EOF
set( CMAKE_SHARED_LINKER_FLAGS "\${CMAKE_SHARED_LINKER_FLAGS} -lgcc_s" )
set( CMAKE_EXE_LINKER_FLAGS "\${CMAKE_EXE_LINKER_FLAGS} -lgcc_s" )
set( CMAKE_C_FLAGS "\${CMAKE_C_FLAGS} -femulated-tls" )
set( CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -femulated-tls" )
EOF
}

do_generate_native_toolchain_file_append_class-nativesdk_darwin17() {
    cat >> ${WORKDIR}/toolchain-native.cmake <<EOF
set( CMAKE_EXE_LINKER_FLAGS "${BUILD_LDFLAGS}" CACHE STRING "LDFLAGS" )
set( CMAKE_SHARED_LINKER_FLAGS "${BUILD_LDFLAGS}" CACHE STRING "LDFLAGS" )
EOF
}

EXTRA_OECMAKE_remove_class-nativesdk_darwin17 = "-DPYTHON_LIBRARY=${STAGING_LIBDIR}/lib${PYTHON_DIR}${PYTHON_ABI}.so"
EXTRA_OECMAKE_remove_class-nativesdk_darwin17 = "-DPYTHON_INCLUDE_DIR=${STAGING_INCDIR}/${PYTHON_DIR}${PYTHON_ABI}"
EXTRA_OECMAKE_remove_class-nativesdk_darwin17 = "-DPYTHON_EXECUTABLE='${PYTHON}'"
EXTRA_OECMAKE_append_class-nativesdk_darwin17 = " \
    -DCMAKE_FRAMEWORK_PATH='${STAGING_DIR_TARGET}${SDKPATHNATIVE}/runtime/System/Library/Frameworks' \
    -DC_INCLUDE_DIRS='${SDKPATHNATIVE}/runtime/usr/include' \
    -DLLDB_USE_SYSTEM_DEBUGSERVER=ON \
    -DLLDB_INCLUDE_TESTS=OFF \
"
EXTRA_OECMAKE_append_class-native = " -DCLANG_DEFAULT_CXX_STDLIB=libstdc++"

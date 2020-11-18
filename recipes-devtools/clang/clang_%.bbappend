TOOLCHAIN_OPTIONS_prepend_darwin9_class-nativesdk = " \
    -I${STAGING_DIR_TARGET}${SDKPATHNATIVE}/runtime/usr/include \
"

DEPENDS_remove_class-nativesdk_darwin9 = "nativesdk-python3"

LDFLAGS_toolchain-clang_class-nativesdk_darwin9 = "${BUILDSDK_LDFLAGS}"

LDFLAGS_remove_class-nativesdk_darwin9 = "-fuse-ld=gold"
LDFLAGS_remove_toolchain-clang_class-nativesdk_x86-64_darwin9 = " -Wl,-dynamic-linker,${base_libdir}/ld-linux-x86-64.so.2"
LDFLAGS_remove_toolchain-clang_class-nativesdk_x86_darwin9 = " -Wl,-dynamic-linker,${base_libdir}/ld-linux.so.2"
LDFLAGS_remove_toolchain-clang_class-nativesdk_aarch64_darwin9 = " -Wl,-dynamic-linker,${base_libdir}/ld-linux-aarch64.so.1"

PACKAGECONFIG[lldbtests] = ",-DLLDB_INCLUDE_TESTS=OFF -DLLDB_BUILD_FRAMEWORK=OFF,"

# change cmake.class to target Darwin instead of darwin9
cmake_do_generate_toolchain_file_append_class-nativesdk_darwin9() {
    sed -i ${WORKDIR}/toolchain.cmake -e"s/set( CMAKE_SYSTEM_NAME darwin9 )/set( CMAKE_SYSTEM_NAME Darwin )/g"
    cat >> ${WORKDIR}/toolchain.cmake <<EOF
set( CMAKE_SHARED_LINKER_FLAGS "\${CMAKE_SHARED_LINKER_FLAGS} -lgcc_s" )
set( CMAKE_EXE_LINKER_FLAGS "\${CMAKE_EXE_LINKER_FLAGS} -lgcc_s" )
set( CMAKE_C_FLAGS "\${CMAKE_C_FLAGS} -femulated-tls" )
set( CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -femulated-tls" )
EOF
}

do_generate_native_toolchain_file_append_class-nativesdk_darwin9() {
    cat >> ${WORKDIR}/toolchain-native.cmake <<EOF
set( CMAKE_EXE_LINKER_FLAGS "${BUILD_LDFLAGS}" CACHE STRING "LDFLAGS" )
set( CMAKE_SHARED_LINKER_FLAGS "${BUILD_LDFLAGS}" CACHE STRING "LDFLAGS" )
EOF
}

EXTRA_OECMAKE_remove_class-nativesdk_darwin9 = "-DPYTHON_LIBRARY=${STAGING_LIBDIR}/lib${PYTHON_DIR}${PYTHON_ABI}.so"
EXTRA_OECMAKE_remove_class-nativesdk_darwin9 = "-DPYTHON_INCLUDE_DIR=${STAGING_INCDIR}/${PYTHON_DIR}${PYTHON_ABI}"
EXTRA_OECMAKE_remove_class-nativesdk_darwin9 = "-DPYTHON_EXECUTABLE='${PYTHON}'"
EXTRA_OECMAKE_append_class-nativesdk_darwin9 = " -DCMAKE_FRAMEWORK_PATH='${STAGING_DIR_TARGET}${SDKPATHNATIVE}/runtime/System/Library/Frameworks'"
EXTRA_OECMAKE_append_class-nativesdk_darwin9 = " -DC_INCLUDE_DIRS='${SDKPATHNATIVE}/runtime/usr/include'"

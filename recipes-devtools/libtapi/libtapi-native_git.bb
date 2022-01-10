# Copyright (C) 2020 Dominik Schnitzer <dominik@snap.com>
# Released under the MIT license (see COPYING.MIT for the terms)

TAPI_REPOSITORY="1100.0.11"
TAPI_VERSION="11.0.0"

SUMMARY = "Apple libtapi for tdb support"
HOMEPAGE = "https://github.com/tpoechtrager/apple-libtapi"
LICENSE = "NCSA"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/LICENSE.APPLE-LIBTAPI.txt;md5=ecd05d65aa93d096452d196dcd233f1e"

SECTION = "devel"

SRCREV = "664b8414f89612f2dfd35a9b679c345aa5389026"
SRC_URI = "git://github.com/tpoechtrager/apple-libtapi.git;branch=${TAPI_REPOSITORY};protocol=https"

PACKAGES = "${PN}-dbg ${PN} ${PN}-dev"

OECMAKE_GENERATOR = "Unix Makefiles"

inherit cmake native

S = "${WORKDIR}/git/src/llvm"
B = "${WORKDIR}/build"

DEPENDS += "clang-native libcxx-native"

TOOLCHAIN:class-native = "clang"
COMPILER_RT:class-native = "-rtlib=libgcc --unwindlib=libgcc"
LIBCPLUSPLUS:class-native = "-stdlib=libc++ -lc++abi"

CXXFLAGS:append = " -I${WORKDIR}/git/src/llvm/projects/clang/include -I${B}/projects/clang/include"

EXTRA_OECMAKE:append = " \
 -DLLVM_INCLUDE_TESTS=OFF \
 -DTAPI_REPOSITORY_STRING=${TAPI_REPOSITORY} \
 -DTAPI_FULL_VERSION=${TAPI_VERSION} \
 -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
"

do_compile() {
    cd ${B}
    make -j clangBasic
    make -j libtapi
}

do_install() {
    DESTDIR='${D}' make install-libtapi install-tapi-headers
}

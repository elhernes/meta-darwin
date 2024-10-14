# Copyright (C) 2020 Dominik Schnitzer <dominik@snap.com>
# Released under the MIT license (see COPYING.MIT for the terms)

TAPI_VERSION="1300.6.5"

SUMMARY = "Apple libtapi for tdb support"
HOMEPAGE = "https://github.com/tpoechtrager/apple-libtapi"
LICENSE = "NCSA"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/LICENSE.APPLE-LIBTAPI.txt;md5=ecd05d65aa93d096452d196dcd233f1e"

SECTION = "devel"

SRCREV = "aa37c11ad1a817248c9d1578ac99e133875b4eb5"
SRC_URI = "git://github.com/tpoechtrager/apple-libtapi.git;nobranch=1;protocol=https"

PACKAGES = "${PN}-dbg ${PN} ${PN}-dev"

inherit cmake native

S = "${WORKDIR}/git/src/llvm"
B = "${WORKDIR}/build"

DEPENDS += " \
    clang-native \
    libcxx-native \
"

TOOLCHAIN:class-native = "clang"
COMPILER_RT:class-native = "-rtlib=libgcc --unwindlib=libgcc"
LIBCPLUSPLUS:class-native = "-stdlib=libc++ -lc++abi"

CXXFLAGS += " \
    -I${WORKDIR}/git/src/llvm/projects/clang/include \
    -I${B}/projects/clang/include \
"

EXTRA_OECMAKE:append = " \
 -DLLVM_INCLUDE_TESTS=OFF \
 -DLLVM_ENABLE_PROJECTS='tapi;clang' \
 -DTAPI_REPOSITORY_STRING=${TAPI_VERSION} \
 -DTAPI_FULL_VERSION=${TAPI_VERSION} \
 -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
"

do_compile() {
    cd ${B}
    ninja clangBasic
    ninja libtapi
}

do_install() {
    DESTDIR='${D}' ninja install-libtapi install-tapi-headers
}

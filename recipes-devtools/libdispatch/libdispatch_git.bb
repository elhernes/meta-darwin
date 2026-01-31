# Copyright (C) 2025, Snap Inc.
# SPDX-License-Identifier: MIT

SUMMARY = "Apple Grand Central Dispatch (libdispatch)"
HOMEPAGE = "https://github.com/tpoechtrager/apple-libdispatch"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/LICENSE;md5=1cd73afe3fb82e8d5c899b9d926451d0"

SECTION = "devel"

SRCREV = "e85f6a0d5c9ea1f32f5013c3fa34e4fc146cd0eb"
SRC_URI = "git://github.com/swiftlang/swift-corelibs-libdispatch.git;nobranch=1;protocol=https"

inherit cmake native

BBCLASSEXTEND = "native"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build"

DEPENDS += " \
    clang-native \
    libcxx-native \
"

TC_CXX_RUNTIME:class-native = "llvm"
TOOLCHAIN:class-native = "clang"

# Use indirection to stop these being expanded prematurely
BINUTILS = "binutils-cross-canadian-${TRANSLATED_TARGET_ARCH}"
GCC = "gcc-cross-canadian-${TRANSLATED_TARGET_ARCH}"
GDB = "gdb-cross-canadian-${TRANSLATED_TARGET_ARCH}"
CLANG = "clang-cross-canadian-${TRANSLATED_TARGET_ARCH}"

RDEPENDS:${PN}:darwinsdk = "\
    ${@all_multilib_tune_values(d, 'BINUTILS')} \
    ${@all_multilib_tune_values(d, 'GCC')} \
    ${GDB} \
    meta-environment-${MACHINE} \
    "

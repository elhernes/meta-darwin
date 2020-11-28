# Use indirection to stop these being expanded prematurely
BINUTILS = "binutils-cross-canadian-${TRANSLATED_TARGET_ARCH}"
GCC = "gcc-cross-canadian-${TRANSLATED_TARGET_ARCH}"

RDEPENDS_${PN}_darwinsdk = "\
    ${@all_multilib_tune_values(d, 'BINUTILS')} \
    ${@all_multilib_tune_values(d, 'GCC')} \
    meta-environment-${MACHINE} \
    "

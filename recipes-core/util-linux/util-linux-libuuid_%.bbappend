FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# GCC's Mach-O backend ICEs on __attribute__((weak, alias())) in
# uuid_time.c; use the asm alias path for GCC too.
SRC_URI:append:darwin21 = " \
    file://0001-libuuid-use-asm-alias-for-uuid_time-on-all-Apple-com.patch \
"

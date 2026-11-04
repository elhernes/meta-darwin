RDEPENDS:${PN}:darwin21 = "\
    nativesdk-flex \
    nativesdk-ninja \
    nativesdk-bison \
    nativesdk-sdk-provides-dummy \
    "

# clang-cross-canadian always links <triple>-<tool> to these, but oe-core
# doesn't install them all:
#  nativesdk-lld        <triple>-lld, -ld.lld; oe-core only adds it with ld-is-lld
#  nativesdk-llvm-bin   <triple>-llvm-ar, -ranlib, -nm, -objcopy, ...; llvm
#                       inherits lib_package, so its tools aren't in nativesdk-llvm
#  nativesdk-clang-tidy <triple>-clang-tidy
RDEPENDS:${PN}:darwin21 += "${@bb.utils.contains('CLANGSDK', '1', 'nativesdk-clang nativesdk-lldb nativesdk-lld nativesdk-llvm-bin nativesdk-clang-tidy', '', d)}"


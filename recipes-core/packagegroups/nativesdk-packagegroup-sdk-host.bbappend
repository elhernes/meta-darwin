RDEPENDS:${PN}:darwin21 = "\
    nativesdk-flex \
    nativesdk-ninja \
    nativesdk-bison \
    nativesdk-sdk-provides-dummy \
    "

# nativesdk-lld: clang-cross-canadian always links <triple>-lld and
# <triple>-ld.lld to it, but oe-core only adds it with ld-is-lld
RDEPENDS:${PN}:darwin21 += "${@bb.utils.contains('CLANGSDK', '1', 'nativesdk-clang nativesdk-lldb nativesdk-lld', '', d)}"


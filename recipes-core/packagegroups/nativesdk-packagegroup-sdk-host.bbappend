RDEPENDS:${PN}:darwin21 = "\
    nativesdk-flex \
    nativesdk-ninja \
    nativesdk-bison \
    nativesdk-sdk-provides-dummy \
    "


RDEPENDS:${PN}:darwin21 += "${@bb.utils.contains('CLANGSDK', '1', 'nativesdk-clang', '', d)}"

EX_TERMLIB:darwin21 = "yes"

base_libdir:class-nativesdk:darwin21 = "${libdir}"

do_install:append:class-nativesdk:darwin21() {
    rm -f ${D}${libdir}/*.so
}

PACKAGES:prepend:darwin21 = "${PN}-lib "

FILES:${PN}-lib:darwin21 = " \
    ${libdir}/*${SOLIBS} \
"

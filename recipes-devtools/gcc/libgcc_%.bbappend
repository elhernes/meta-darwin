do_install_append_darwin9 () {
    rmdir ${D}${base_libdir}
    install -d ${D}${libdir}
    cp ${B}/${TARGET_SYS}/${BPN}/*.dylib ${D}${libdir}
}

FILES_${PN}_append_darwin9 = " ${libdir}"

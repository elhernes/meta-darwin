do_install_append_darwin () {
	install -d ${D}${libdir}
	cp ${B}/${TARGET_SYS}/${BPN}/*.dylib ${D}${libdir}
	rmdir ${D}${base_libdir}
}

FILES_${PN}_append_darwin = " ${libdir}/libgcc*.dylib"

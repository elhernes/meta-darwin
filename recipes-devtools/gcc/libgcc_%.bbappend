SYSTEMHEADERS:darwin19 = "${SDKPATHNATIVE}/runtime/usr/include/"

do_compile:darwin19() {
     oe_runmake all-target-libgcc MULTIBUILDTOP=${B}/${TARGET_SYS}/${BPN}
}

do_install:darwin19 () {
    install -d ${D}${libdir}
    cp ${B}/${TARGET_SYS}/${BPN}/libgcc_s.1.dylib ${D}${libdir}
    ln -s libgcc_s.1.dylib ${D}${libdir}/libgcc.dylib
    ln -s libgcc_s.1.dylib ${D}${libdir}/libgcc_s.dylib
    ln -s libgcc_s.1.dylib ${D}${libdir}/libgcc_ext.10.4.dylib
    ln -s libgcc_s.1.dylib ${D}${libdir}/libgcc_ext.10.5.dylib
    ${TARGET_SYS}-install_name_tool -id ${libdir}/libgcc_s.1.dylib ${D}/${libdir}/libgcc_s.1.dylib
}

FILES:${PN}:append:darwin19 = " ${libdir}"

SYSTEMHEADERS:darwin21 = "${SDKPATHNATIVE}/runtime/usr/include/"

do_compile:darwin21() {
     oe_runmake all-target-libgcc MULTIBUILDTOP=${B}/${TARGET_SYS}/${BPN}
}

# See file gcc/config/darwin.h in the gcc repository to understand which library is being linked against,
# depending on the minimum version of os-x targetted (parameter "mmacosx-version-min").
do_install:darwin21 () {
    install -d ${D}${libdir}
    cp ${B}/${TARGET_SYS}/${BPN}/libgcc_s.1.1.dylib ${D}${libdir}
    cp ${B}/${TARGET_SYS}/${BPN}/libemutls_w.a ${D}${libdir}
    ln -s libgcc_s.1.1.dylib ${D}${libdir}/libgcc.dylib
    ln -s libgcc_s.1.1.dylib ${D}${libdir}/libgcc_s.dylib
    ${TARGET_SYS}-install_name_tool -id ${libdir}/libgcc_s.1.1.dylib ${D}/${libdir}/libgcc_s.1.1.dylib
}

FILES:${PN}:append:darwin21 = " ${libdir}"

EXTRA_OECONF_remove_darwin19 = "--enable-clocale=gnu"
EXTRA_OECONF_remove_darwin19 = "--enable-clocale=generic"

RUNTIMETARGET_remove_darwin19 = "libmpx"

FILES_libssp_append_darwin19 = " ${libdir}/libssp*.dylib"
FILES_libstdc++_append_darwin19 = " ${libdir}/libstdc++*.dylib"
FILES_libitm_append_darwin19 = " ${libdir}/libitm*.dylib"
FILES_libatomic_append_darwin19 = " ${libdir}/libatomic*.dylib"
FILES_libgomp_append_darwin19 = " ${libdir}/libgomp*.dylib"
FILES_${PN}-dbg_append_darwin19 = " ${libdir}/libstdc++.a-gdb.py"

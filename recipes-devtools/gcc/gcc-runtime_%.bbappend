EXTRA_OECONF_remove_darwin17 = "--enable-clocale=gnu"
EXTRA_OECONF_remove_darwin17 = "--enable-clocale=generic"

RUNTIMETARGET_remove_darwin17 = "libmpx"

FILES_libssp_append_darwin17 = " ${libdir}/libssp*.dylib"
FILES_libstdc++_append_darwin17 = " ${libdir}/libstdc++*.dylib"
FILES_libitm_append_darwin17 = " ${libdir}/libitm*.dylib"
FILES_libatomic_append_darwin17 = " ${libdir}/libatomic*.dylib"
FILES_libgomp_append_darwin17 = " ${libdir}/libgomp*.dylib"
FILES_${PN}-dbg_append_darwin17 = " ${libdir}/libstdc++.a-gdb.py"

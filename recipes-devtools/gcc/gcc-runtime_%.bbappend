EXTRA_OECONF:remove:darwin19 = "--enable-clocale=gnu"
EXTRA_OECONF:remove:darwin19 = "--enable-clocale=generic"

RUNTIMETARGET:remove:darwin19 = "libmpx"

FILES:libssp:append:darwin19 = " ${libdir}/libssp*.dylib"
FILES:libstdc++:append:darwin19 = " ${libdir}/libstdc++*.dylib"
FILES:libitm:append:darwin19 = " ${libdir}/libitm*.dylib"
FILES:libatomic:append:darwin19 = " ${libdir}/libatomic*.dylib"
FILES:libgomp:append:darwin19 = " ${libdir}/libgomp*.dylib"
FILES:${PN}-dbg:append:darwin19 = " ${libdir}/libstdc++.a-gdb.py"

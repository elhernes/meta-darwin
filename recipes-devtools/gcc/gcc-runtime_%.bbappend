EXTRA_OECONF_remove_darwin17 = "--enable-initfini_array"
EXTRA_OECONF_append_darwin17 = " --disable-initfini_array"

EXTRA_OECONF_remove_darwin17 = "--enable-clocale=gnu"
EXTRA_OECONF_remove_darwin17 = "--enable-clocale=generic"

RUNTIMETARGET_remove_darwin17 = "libmpx"

do_configure_darwin17() {
    export CXX_LOCAL="$CXX"
    export CXX="$(echo $CXX_LOCAL | sed -e 's/-static-libgcc//')"
    for d in libgcc ${RUNTIMETARGET}; do
#        if [ "$d" = "libstdc++v3" ]; then
#        else
#            export CXX="$CXX_LOCAL"
#        fi
        echo "Configuring $d"
        rm -rf ${B}/${TARGET_SYS}/$d/
        mkdir -p ${B}/${TARGET_SYS}/$d/
        cd ${B}/${TARGET_SYS}/$d/
        chmod a+x ${S}/$d/configure
        relpath=${@os.path.relpath("${S}/$d", "${B}/${TARGET_SYS}/$d")}
        echo "$relpath/configure ${CONFIGUREOPTS} ${EXTRA_OECONF}"
        $relpath/configure ${CONFIGUREOPTS} ${EXTRA_OECONF}
        if [ "$d" = "libgcc" ]; then
            (cd ${B}/${TARGET_SYS}/libgcc; oe_runmake enable-execute-stack.c unwind.h md-unwind-support.h sfp-machine.h gthr-default.h)
        fi
    done
}

FILES_libssp_append_darwin17 = " ${libdir}/libssp*.dylib"
FILES_libstdc++_append_darwin17 = " ${libdir}/libstdc++*.dylib"
FILES_libitm_append_darwin17 = " ${libdir}/libitm*.dylib"
FILES_libatomic_append_darwin17 = " ${libdir}/libatomic*.dylib"
FILES_libgomp_append_darwin17 = " ${libdir}/libgomp*.dylib"
FILES_${PN}-dbg_append_darwin17 = " ${libdir}/libstdc++.a-gdb.py"

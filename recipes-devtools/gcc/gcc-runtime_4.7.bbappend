export lt_cv_ld_exported_symbols_list = "yes"
export ac_cv_lib_dl_dlopen = "yes"

RUNTIMETARGET_darwin = "libssp"

FILES_libssp_append_darwin = " ${libdir}/libssp*.dylib"
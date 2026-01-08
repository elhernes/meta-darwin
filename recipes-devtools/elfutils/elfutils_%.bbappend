PACKAGECONFIG:darwin21 = ""

#PACKAGECONFIG[bzip2] = "--with-bzlib,--without-bzlib,${DEPENDS_BZIP2}"
#PACKAGECONFIG[xz] = "--with-lzma,--without-lzma,xz"
#PACKAGECONFIG[zstd] = "--with-zstd,--without-zstd,zstd"
PACKAGECONFIG:darwin21[libdebuginfod] = ""
PACKAGECONFIG:darwin21[debuginfod] = ""

#READELF:darwin21 = "readelf"
CACHED_CONFIGUREVARS:darwin21 = "ac_cv_buildid=no"
EXTRA_OECONF = "--disable-debuginfod"
PACKAGECONFIG:darwin21 = ""

#PACKAGECONFIG[bzip2] = "--with-bzlib,--without-bzlib,${DEPENDS_BZIP2}"
#PACKAGECONFIG[xz] = "--with-lzma,--without-lzma,xz"
#PACKAGECONFIG[zstd] = "--with-zstd,--without-zstd,zstd"
PACKAGECONFIG:darwin21[libdebuginfod] = ""
PACKAGECONFIG:darwin21[debuginfod] = ""

#READELF:darwin21 = "readelf"

# We lie to elfutils config because it doesn't seem to understand cross compiling
# Here, it runs the cross compiler with the build-id flag.  This would generate a
# macOS macho object file, if it didn't error out on not supporting the build-id
# option.  Elfutils gets hung up on needing a buildid, which it will eventually get
# when run on the target, so we just tell a little white lie here.
CACHED_CONFIGUREVARS:darwin21 = "ac_cv_buildid=yes"

EXTRA_OECONF = "--disable-debuginfod --disable-symbol-versioning"

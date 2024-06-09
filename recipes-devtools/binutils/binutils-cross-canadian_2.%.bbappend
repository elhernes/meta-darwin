# Remove -rpath-link and -rpath
LDFLAGS:darwinsdk = "${BUILDSDK_LDFLAGS}"

# gold uses uchar.h which doesn't exist on MacOS
LDGOLD = "--enable-gold=no"

QEMU_TARGETS_darwin = "i386 x86_64"
EXTRA_OECONF_append_class-nativesdk_darwin = "--disable-linux-user --disable-sdl --disable-cocoa --disable-vnc --disable-stack-protector --disable-fdt"
PACKAGECONFIG_class-nativesdk_darwin = ""

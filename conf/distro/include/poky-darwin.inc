#
# Copyright (c) 2007 Openedhand Ltd.
#
# Set Poky up to build for darwin - work around compiler and header issues 
# in really gross ways...
#  

TARGET_OS = "darwin"
TARGET_VENDOR = "-apple"
PREFERRED_PROVIDER_virtual/${TARGET_PREFIX}libc-for-gcc = "iphone-rootfs"
PREFERRED_PROVIDER_virtual/libc = "iphone-rootfs"
PREFERRED_PROVIDER_virtual/${TARGET_PREFIX}binutils = "odcctools-cross"
PREFERRED_PROVIDER_virtual/${TARGET_PREFIX}gcc = "llvm-cross"
PREFERRED_PROVIDER_virtual/${TARGET_PREFIX}g++ = "llvm-cross"
PREFERRED_PROVIDER_virtual/linux-libc-headers = "apple-headers"
PREFERRED_PROVIDER_virtual/libiconv = "iphone-rootfs"
PREFERRED_PROVIDER_virtual/libintl = "gettext"

export TARGET_LDFLAGS = "-L${STAGING_DIR_TARGET}${layout_libdir} -Wl,-L${STAGING_DIR_TARGET}${layout_libdir}"
#CXXFLAGS += "-fvisibility-inlines-hidden"

# Work around assert being buggy on Darwin
# assert needs __eprintf from libgcc but it is not present
#TARGET_CFLAGS_append_darwin_pn-fontconfig = " -DNDEBUG"
#TARGET_CFLAGS_append_darwin_pn-cairo = " -DNDEBUG"
#TARGET_CFLAGS_append_darwin_pn-gtk+ = " -DNDEBUG"
#TARGET_CFLAGS_append_darwin_pn-gettext = " -DNDEBUG"
#TARGET_CFLAGS_append_darwin_pn-expat = " -DNDEBUG"
##TARGET_CFLAGS_append_pn-gettext_append_darwin_append = " -DNDEBUG"
CFLAGSHACK = ""
CFLAGSHACK_darwin = " -DNDEBUG"
TARGET_CFLAGS_append_pn-fontconfig = "${CFLAGSHACK}"
TARGET_CFLAGS_append_pn-cairo = "${CFLAGSHACK}"
TARGET_CFLAGS_append_pn-gtk+ = "${CFLAGSHACK}"
TARGET_CFLAGS_append_pn-glib-2.0 = "${CFLAGSHACK}"
TARGET_CFLAGS_append_pn-gettext = "${CFLAGSHACK}"
TARGET_CFLAGS_append_pn-expat = "${CFLAGSHACK}"
TARGET_CFLAGS_append_pn-libxml2 = "${CFLAGSHACK}"

PREFERRED_VERSION_clutter = "0.5.0+svnr1495"

SRCREV_pn-llvm-native = "42498"
#SRCREV_pn-llvm-native = 46956
SRCREV_pn-apple-csu = "202"
SRCREV_pn-llvm-cross = "184"
SRCREV_pn-apple-headers = "198"
SRCREV_pn-odcctools-cross = "204"
#SRCREV_pn-odcctools-cross = "209"
SRCREV_pn-clutter = "1495"
#SRCREV_pn-clutter = "${AUTOREV}"
#SRCREV_pn-tidy = "${AUTOREV}"


#
# Clutter
#
DEPENDS_pn-clutter = "${STDDEPENDS}"
EXTRA_OECONF_pn-clutter = "${BASE_CONF} --with-flavour=eglnative"
PACKAGE_ARCH_pn-clutter = "${MACHINE_ARCH}"
SRC_URI_append_pn-clutter = " file://darwin-hacks/clutter-hack.patch;patch=1"

#
# Pango
#
TARGET_LDFLAGS_append_pn-pango = "-lpng12 -lfreetype -lfontconfig -lexpat -lXrender -lX11"
SRC_URI_append_pn-pango = " file://darwin-hacks/pango-hack.patch;patch=1"

#
# GTK+
# 
DEPENDS_pn-gtk+ = "glib-2.0 pango atk jpeg libpng libxext libxcursor gtk-doc-native"
SRC_URI_append_pn-gtk+ = " file://darwin-hacks/gtk-hack.patch;patch=1"
SRC_URI_append_pn-gtk+ = " file://darwin-hacks/gtk-no-c++.patch;patch=1"
EXTRA_OECONF_pn-gtk+ = "--without-libtiff --disable-xkb --disable-glibtest --enable-display-migration --disable-visibility"
TARGET_LDFLAGS_append_pn-gtk+  = "-lpng12 -lfreetype -lfontconfig -lexpat -lXrender -lX11 -lXau -lXdmcp"
RRECOMMENDS_gtk+_pn-gtk+ = "gdk-pixbuf-loader-png gdk-pixbuf-loader-jpeg gdk-pixbuf-loader-gif gdk-pixbuf-loader-xpm"

#
# GLib
#
SRC_URI_append_pn-glib-2.0 = " file://darwin-hacks/glib-hack.patch;patch=1"
EXTRA_OECONF_pn-glib-2.0 = "--disable-debug --disable-visibility"
 
#
# Xtrans
#
SRC_URI_append_pn-xtrans = " file://darwin-hacks/xtrans-hack.patch;patch=1"

#
# libxml2
#
SRC_URI_append_pn-libxml2 = " file://darwin-hacks/libxml2-hack.patch;patch=1"

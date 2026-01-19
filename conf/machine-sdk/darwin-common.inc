SDK_OS = "darwin21"

SOLIBS:darwin21 = ".dylib"
SOLIBSDEV:darwin21 = ".dylibbroken"

PREFERRED_PROVIDER_virtual/nativesdk-${SDK_PREFIX}libc-for-gcc = "nativesdk-osx-runtime"
PREFERRED_PROVIDER_virtual/nativesdk-${SDK_PREFIX}libc-initial = "nativesdk-osx-runtime"
PREFERRED_PROVIDER_virtual/${SDK_PREFIX}binutils = "cctools-port-crosssdk"
PREFERRED_PROVIDER_virtual/nativesdk-libc = "nativesdk-osx-runtime"
PREFERRED_PROVIDER_virtual/nativesdk-libintl = "nativesdk-osx-runtime"
PREFERRED_PROVIDER_virtual/nativesdk-libiconv = "nativesdk-osx-runtime"

SDKUSE_NLS = "no"
SDKIMAGE_LINGUAS = ""
SDK_DEPENDS:remove = "nativesdk-glibc-locale nativesdk-qemuwrapper-cross"

SDK_DEPENDS:append = "${@bb.utils.contains('DARWIN_INSTALLER_PKG', '1', ' bomutils-native xar-native', '', d)}"
SDK_DEPENDS:append = "${@bb.utils.contains('DARWIN_INSTALLER_DMG', '1', ' libdmg-hfsplus-native', '', d)}"

SDKPKGSUFFIX = "nativesdk-darwin"

OSX_TOOLCHAIN_OPTIONS = " \
    -mmacosx-version-min=12.3 \
    -L${STAGING_DIR_TARGET}${SDKPATHNATIVE}/usr/lib \
    -L${STAGING_DIR_TARGET}${SDKPATHNATIVE}/runtime/usr/lib \
    -L${STAGING_DIR_TARGET}${SDKPATHNATIVE}/runtime/usr/lib/system \
"

TOOLCHAIN_OPTIONS:append:darwin21 = " \
    ${OSX_TOOLCHAIN_OPTIONS}"
TOOLCHAIN_OPTIONS:append:class-cross-canadian = " \
    ${OSX_TOOLCHAIN_OPTIONS}"

# Remove -rpath-link
BUILDSDK_LDFLAGS = " \
    -L${STAGING_LIBDIR} \
    -Wl,-rpath,${libdir} \
"

MACHINEOVERRIDES .= ":darwinsdk"

TOOLCHAIN_SHAR_EXT_TMPL ?= "${DARWINBASE}/conf/files/darwin-toolchain-shar-extract.sh"

SDK_POSTPROCESS_COMMAND:append = "${@bb.utils.contains('DARWIN_INSTALLER_PKG', '1', ' dw_create_macos_pkg', '', d)}"
SDK_POSTPROCESS_COMMAND:append = "${@bb.utils.contains('DARWIN_INSTALLER_DMG', '1', ' dw_create_macos_dmg', '', d)}"

fakeroot dw_create_macos_pkg() {
   echo dw_create_macos_pkg

   # SDKDEPLOYDIR is local to recipe work; SDK_DEPLOY is from
	 sdk_pkg="${SDKDEPLOYDIR}/${TOOLCHAIN_OUTPUTNAME}.pkg"

   (cd ${B}; ${DARWINBASE}/conf/files/mk-macos-pkg.sh "${SDK_TITLE}" "${SDK_NAME}" "${SDK_ARCH}" "${DISTRO_VERSION}.${SDK_VERSION}" "${SDK_OUTPUT}/${SDKPATH}" "${sdk_pkg}")
   ls -lh "${sdk_pkg}"
}

fakeroot dw_create_macos_dmg() {
   echo dw_create_macos_dmg
   #
   # SDKDEPLOYDIR is local to recipe work; SDK_DEPLOY is from
   sdk_dmg="${SDKDEPLOYDIR}/${TOOLCHAIN_OUTPUTNAME}.dmg"
   echo dw_create_macos_dmg: ${sdk_dmg}

#   (cd ${B}; ${DARWINBASE}/conf/files/mk-macos-pkg.sh "${SDK_TITLE}" "${SDK_NAME}" "${SDK_ARCH}" "${DISTRO_VERSION}.${SDK_VERSION}" "${SDK_OUTPUT}/${SDKPATH}" "${sdk_pkg}")
#   ls -lh "${sdk_pkg}"
}

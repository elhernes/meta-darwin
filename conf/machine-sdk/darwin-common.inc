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
SDK_DEPENDS:append = "${@bb.utils.contains('DARWIN_INSTALLER_DMG', '1', ' hfsprogs-native libdmg-hfsplus-native', '', d)}"

SDKPKGSUFFIX = "nativesdk-darwin"

DARWIN_INSTALL_LOC = "${@d.getVar('DARWIN_INSTALLER_PATH') or '/Library/Developer/org.openembedded.sdk'}"

OSX_TOOLCHAIN_OPTIONS = " \
    -mmacosx-version-min=12.3 \
    -L${STAGING_DIR_TARGET}${SDKPATHNATIVE}/usr/lib \
    -L${STAGING_DIR_TARGET}${SDKPATHNATIVE}/runtime/usr/lib \
    -L${STAGING_DIR_TARGET}${SDKPATHNATIVE}/runtime/usr/lib/system \
"

TOOLCHAIN_OPTIONS:append:darwin21 = " \
    ${OSX_TOOLCHAIN_OPTIONS} \
"

TOOLCHAIN_OPTIONS:append:class-cross-canadian = " \
    ${OSX_TOOLCHAIN_OPTIONS} \
"

# Remove -rpath-link
BUILDSDK_LDFLAGS = " \
    -L${STAGING_LIBDIR} \
    -Wl,-rpath,${libdir} \
"

MACHINEOVERRIDES .= ":darwinsdk"

TOOLCHAIN_SHAR_EXT_TMPL ?= "${DARWINBASE}/conf/files/darwin-toolchain-shar-extract.sh"

SDK_POSTPROCESS_COMMAND:append = "${@bb.utils.contains('DARWIN_INSTALLER_PKG', '1', ' create_macos_pkg', '', d)}"
SDK_POSTPROCESS_COMMAND:append = "${@bb.utils.contains('DARWIN_INSTALLER_DMG', '1', ' create_macos_dmg', '', d)}"

#
# remove the .xz and .sh creation if we want to save a bit of time
SDK_POSTPROCESS_COMMAND:remove = "${@bb.utils.contains('DARWIN_INSTALLER_SH', '0', ' archive_sdk', '', d)}"
SDK_POSTPROCESS_COMMAND:remove = "${@bb.utils.contains('DARWIN_INSTALLER_SH', '0', ' create_shar', '', d)}"

fakeroot create_macos_pkg() {
    sdk_pkg="${SDKDEPLOYDIR}/${TOOLCHAIN_OUTPUTNAME}.pkg"
    native_sysroot=$(basename ${SDKPATHNATIVE})

    sed -e "s#@target_prefix@#${TARGET_PREFIX}#g" \
        -e "s#@native_sysroot@#${native_sysroot}#g" \
         ${DARWINBASE}/conf/files/finalize-sdk.sh \
         > "${B}/finalize-pkg"
    chmod +x "${B}/finalize-pkg"

    (cd ${B}; \
        ${DARWINBASE}/conf/files/mk-macos-pkg.sh "${SDK_TITLE}" "${SDK_NAME}" "${SDK_ARCH}" "${DISTRO_VERSION}.${SDK_VERSION}" "${SDK_OUTPUT}/${SDKPATH}" "${sdk_pkg}" "${B}/finalize-pkg" ${DARWIN_INSTALL_LOC}/${SDK_NAME} \
    )

   ls -lh "${sdk_pkg}"
}

fakeroot create_macos_dmg() {
    sdk_dmg="${SDKDEPLOYDIR}/${TOOLCHAIN_OUTPUTNAME}.dmg"
    native_sysroot=$(basename ${SDKPATHNATIVE})
    sed -e "s#@target_prefix@#${TARGET_PREFIX}#g" \
        -e "s#@native_sysroot@#${native_sysroot}#g" \
         ${DARWINBASE}/conf/files/finalize-sdk.sh \
         > "${B}/finalize-dmg"

    echo 'rm ${0}' >> "${B}/finalize-dmg"
    chmod +x "${B}/finalize-dmg"

    ( cd ${B}; \
        ${DARWINBASE}/conf/files/mk-macos-dmg.sh "${SDK_TITLE}" "${SDK_NAME}" "${SDK_ARCH}" "${DISTRO_VERSION}.${SDK_VERSION}" "${SDK_OUTPUT}/${SDKPATH}" "${sdk_dmg}" "${B}/finalize-dmg" "${DARWIN_INSTALL_LOC}/${SDK_NAME}" \
    )
   ls -lh "${sdk_dmg}"
}

INSANE_SKIP_${PN}_append_darwinsdk = " staticdev"
EXTRA_OECONF_append_darwinsdk = " --disable-nls"
ELFUTILS_darwinsdk = ""

#Remove -rpath-link and -rpath
LDFLAGS_darwinsdk = "${BUILDSDK_LDFLAGS} -L${libdir}/.."

# Change gxx-include-dir
EXTRA_OECONF_PATHS_darwinsdk = "--with-gxx-include-dir=${SDKPATH}/sysroots/${TUNE_PKGARCH}${TARGET_VENDOR}-${TARGET_OS}/usr/include/c++ \
                      --with-build-time-tools=${STAGING_DIR_NATIVE}${prefix_native}/${TARGET_SYS}/bin \
                      --with-sysroot=${SDKPATH}/sysroots/${TUNE_PKGARCH}${TARGET_VENDOR}-${TARGET_OS} \
                      --with-build-sysroot=${STAGING_DIR_TARGET}"

RDEPENDS_${PN}_append_darwinsdk = " nativesdk-gettext nativesdk-gmp"

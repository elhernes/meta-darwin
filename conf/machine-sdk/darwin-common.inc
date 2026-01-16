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
SDK_NAME_PREFIX = "oecore-darwin"

SDK_DEPENDS:append = " bomutils-native"
SDK_DEPENDS:append = " xar-native"

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

TOOLCHAIN_SHAR_EXT_TMPL ?= "${DARWINBASE}/conf/files/dw-toolchain-shar-extract.sh"
SDK_PACKAGING_FUNC ?= "dw_create_bundle"
SDK_POSTPROCESS_COMMAND:prepend = " dw_gen_cross_toolchain_files "
SDK_POSTPROCESS_COMMAND:append = " dw_create_macos_pkg "

#
# remove these to speed up testing the macos pkg
SDK_POSTPROCESS_COMMAND:remove = " ${SDK_PACKAGING_FUNC}"
SDK_POSTPROCESS_COMMAND:remove = " archive_sdk"

#
# it might be better to .bbappend and include with the cmake/meson nativesdk recipes.
# it is more related to the SDK than the individual recipes though.
fakeroot dw_gen_cross_toolchain_files() {

  # this is mostly copied/simplified from
  #  poky/meta/classes-recipe/toolchain-scripts.bbclass
  sdkpathnative=${SDKPATHNATIVE}
  bindir=${bindir_nativesdk}
  sbindir=$sbindir_nativesdk}
  base_bindir=${base_bindir_nativesdk}
  base_sbindir=${base_sbindir_nativesdk}
  extrapath=""
  for i in ${CANADIANEXTRAOS}; do
    extrapath="$extrapath:$sdkpathnative$bindir/${TARGET_ARCH}${TARGET_VENDOR}-$i"
  done

  exe_path="$sdkpathnative$bindir:$sdkpathnative$sbindir:$sdkpathnative$base_bindir:$sdkpathnative$base_sbindir:$sdkpathnative$bindir/../${HOST_SYS}/bin:$sdkpathnative$bindir/${TARGET_SYS}:$extrapath"

  # substitute variables in cross toolchain files:

  sed -e "s#@oecore_target_arch@#${TARGET_ARCH}#g" \
    -e "s#@target_prefix@#${TARGET_PREFIX}#g" \
    -e "s#@sdk_target_sysroot@#${SDKTARGETSYSROOT}#g" \
    -e "s#@oecore_native_sysroot@#${sdkpathnative}#g" \
    -e "s#@sdk_exec_path@#${exe_path}#g" \
    ${DARWINBASE}/conf/files/oesdk-toolchain.cmake.in \
    > ${SDK_OUTPUT}/${SDKPATH}/oesdk-toolchain.cmake

  sed -e "s#@oecore_target_arch@#${TARGET_ARCH}#g" \
    -e "s#@target_prefix@#${TARGET_PREFIX}#g" \
    -e "s#@sdk_target_sysroot@#${SDKTARGETSYSROOT}#g" \
    -e "s#@oecore_native_sysroot@#${sdkpathnative}#g" \
    -e "s#@sdk_exec_path@#${exe_path}#g" \
    ${DARWINBASE}/conf/files/oesdk-toolchain.meson.in \
    > ${SDK_OUTPUT}/${SDKPATH}/oesdk-toolchain.meson

}

fakeroot dw_create_macos_pkg() {
   echo dw_create_macos_pkg
   #
   # SDKDEPLOYDIR is local to recipe work; SDK_DEPLOY is from
   sdk_pkg="${SDKDEPLOYDIR}/${TOOLCHAIN_OUTPUTNAME}.pkg"

   (cd ${B}; ${DARWINBASE}/conf/files/mk-macos-pkg.sh "${SDK_TITLE}" "${SDK_NAME}" "${SDK_ARCH}" "${DISTRO_VERSION}.${SDK_VERSION}" "${SDK_OUTPUT}/${SDKPATH}" "${sdk_pkg}")
   ls -lh "${sdk_pkg}"
}

fakeroot dw_create_bundle() {
# copy in the template shar extractor script

	cp ${TOOLCHAIN_SHAR_EXT_TMPL} ${SDKDEPLOYDIR}/${TOOLCHAIN_OUTPUTNAME}.sh

	rm -f ${T}/pre_install_command ${T}/post_install_command

	if [ "${SDK_RELOCATE_AFTER_INSTALL}" = "1" ] ; then
		cp ${TOOLCHAIN_SHAR_REL_TMPL} ${T}/post_install_command
	fi
	cat << "EOF" >> ${T}/pre_install_command
${SDK_PRE_INSTALL_COMMAND}
EOF

	cat << "EOF" >> ${T}/post_install_command
${SDK_POST_INSTALL_COMMAND}
EOF
	sed -i -e '/@SDK_PRE_INSTALL_COMMAND@/r ${T}/pre_install_command' \
		-e '/@SDK_POST_INSTALL_COMMAND@/r ${T}/post_install_command' \
		${SDKDEPLOYDIR}/${TOOLCHAIN_OUTPUTNAME}.sh

	# substitute variables
	sed -i -e 's#@SDK_ARCH@#${SDK_ARCH}#g' \
		-e 's#@SDKPATH@#${SDKPATH}#g' \
		-e 's#@SDKPATHINSTALL@#${SDKPATHINSTALL}#g' \
		-e 's#@SDKEXTPATH@#${SDKEXTPATH}#g' \
		-e 's#@OLDEST_KERNEL@#${SDK_OLDEST_KERNEL}#g' \
		-e 's#@REAL_MULTIMACH_TARGET_SYS@#${REAL_MULTIMACH_TARGET_SYS}#g' \
		-e 's#@SDK_TITLE@#${@d.getVar("SDK_TITLE").replace('&', '\\&')}#g' \
		-e 's#@SDK_VERSION@#${SDK_VERSION}#g' \
		-e '/@SDK_PRE_INSTALL_COMMAND@/d' \
		-e '/@SDK_POST_INSTALL_COMMAND@/d' \
		-e 's#@SDK_GCC_VER@#${@oe.utils.host_gcc_version(d, taskcontextonly=True)}#g' \
		-e 's#@SDK_ARCHIVE_TYPE@#${SDK_ARCHIVE_TYPE}#g' \
		${SDKDEPLOYDIR}/${TOOLCHAIN_OUTPUTNAME}.sh

	# add execution permission
	chmod +x ${SDKDEPLOYDIR}/${TOOLCHAIN_OUTPUTNAME}.sh

	# append the SDK tarball
	cat ${SDKDEPLOYDIR}/${TOOLCHAIN_OUTPUTNAME}.${SDK_ARCHIVE_TYPE} >> ${SDKDEPLOYDIR}/${TOOLCHAIN_OUTPUTNAME}.sh

	# delete the old tarball, we don't need it anymore
#	rm ${SDKDEPLOYDIR}/${TOOLCHAIN_OUTPUTNAME}.${SDK_ARCHIVE_TYPE}
}

#
# Standalone CMake and meson toolchain files for an SDK image, usable without
# sourcing environment-setup (from an IDE, or CMakePresets.json):
#
#   oesdk-toolchain.cmake, oesdk-toolchain-clang.cmake   cmake --toolchain <file>
#   oesdk-toolchain.meson, oesdk-toolchain-clang.meson   meson setup --cross-file <file>
#
# The SDK carries no cmake or meson of its own; these work with the host's.
# With CLANGSDK, it also writes <triple>.cfg next to the clang driver, so
# clang links with the SDK's lld rather than the host's ld.
#
# Inherit in the SDK image recipe. OESDK_TOOLCHAIN_FILES_LIST then names, one
# per line relative to the SDK root, every file written, for later
# SDK_POSTPROCESS_COMMAND steps (e.g. to checksum them); a step that reads it
# deletes it.
#
# Parts of this class were written with an AI tool (Claude Code).

SDK_POSTPROCESS_COMMAND:prepend = "oesdk_toolchain_files "

OESDK_TOOLCHAIN_FILES_LIST = "${WORKDIR}/oesdk-toolchain-files.list"

fakeroot oesdk_toolchain_files() {
  sdkpathnative=${SDKPATHNATIVE}
  bindir=${bindir_nativesdk}
  sdkpath=${SDKPATH}
  tc_prefix="$sdkpathnative$bindir/${TARGET_SYS}/${TARGET_SYS}"

  # The compiler and linker flags come from the SDK's own environment-setup
  # (meta-environment, installed before this runs), so CMake and meson
  # builds get exactly the CPU tune and hardening flags $CC/$CLANGCC have.
  # The image recipe's own variables can differ: an SDK image built with the
  # clang toolchain has a different TARGET_CC_ARCH.
  envsetup=
  for f in ${SDK_OUTPUT}${SDKPATH}/environment-setup-*; do
    [ -f "$f" ] || continue
    [ -z "$envsetup" ] || bbfatal "more than one environment-setup in the SDK"
    envsetup=$f
  done
  [ -n "$envsetup" ] || bbfatal "no environment-setup in the SDK"
  env_var() { # env_var <name>: the value of `export <name>="..."`
    v=$(sed -n "s/^export $1=\"\(.*\)\"\$/\1/p" "$envsetup")
    [ -n "$v" ] || bbfatal "no $1 in $envsetup"
    echo "$v"
  }
  cc_flags() { # cc_flags <$CC value>: the flags, less the compiler, --sysroot, -O* and fortify
    out= first=1
    set -f
    for w in $1; do
      if [ "$first" = 1 ]; then first=0; continue; fi
      case $w in
        --sysroot=*|-O*|-D_FORTIFY_SOURCE=*) ;;
        *) out="$out $w" ;;
      esac
    done
    set +f
    echo "${out# }"
  }
  meson_list() { # meson_list <words>: 'w1', 'w2', (with a trailing comma)
    out=
    set -f
    for w in $1; do out="$out'$w', "; done
    set +f
    echo "$out"
  }
  cc=$(env_var CC)
  clangcc=$(env_var CLANGCC)
  ldflags=$(env_var LDFLAGS)
  gcc_flags=$(cc_flags "$cc")
  clang_flags=$(cc_flags "$clangcc")
  fortify=$(echo " $cc " | sed -n 's/.* \(-D_FORTIFY_SOURCE=[0-9]*\) .*/\1/p')

  # One CMake file for both compilers: it picks clang when its file name
  # contains "clang".
  sed -e "s#@oecore_target_arch@#${TARGET_ARCH}#g" \
    -e "s#@target_prefix@#${tc_prefix}-#g" \
    -e "s#@sdk_target_sysroot@#${SDKTARGETSYSROOT}#g" \
    -e "s#@oecore_native_sysroot@#$sdkpathnative#g" \
    -e "s#@gcc_flags@#$gcc_flags#g" \
    -e "s#@clang_flags@#$clang_flags#g" \
    -e "s#@fortify@#$fortify#g" \
    -e "s#@ldflags@#$ldflags#g" \
    ${DARWINBASE}/conf/files/oesdk-toolchain.cmake.in \
    > ${SDK_OUTPUT}/${SDKPATH}/oesdk-toolchain.cmake
  ln -s "oesdk-toolchain.cmake" "${SDK_OUTPUT}/${SDKPATH}/oesdk-toolchain-clang.cmake"
  list="oesdk-toolchain.cmake oesdk-toolchain-clang.cmake"

  # One meson cross file per compiler: meson reads only [binaries].
  gen_meson() { # gen_meson <out> <cc> <cxx> <ar> <strip> <flags>
    sed -e "s#@oecore_target_arch@#${TARGET_ARCH}#g" \
      -e "s#@host_prefix@#${HOST_PREFIX}#g" \
      -e "s#@host_sys@#${HOST_SYS}#g" \
      -e "s#@sdk_target_sysroot@#${SDKTARGETSYSROOT}#g" \
      -e "s#@oecore_native_sysroot@#$sdkpathnative#g" \
      -e "s#@cc@#$2#g" -e "s#@cxx@#$3#g" -e "s#@ar@#$4#g" -e "s#@strip@#$5#g" \
      -e "s#@cflags@#$(meson_list "$6")#g" \
      -e "s#@ldflags@#$(meson_list "$ldflags")#g" \
      ${DARWINBASE}/conf/files/oesdk-toolchain.meson.in \
      > ${SDK_OUTPUT}/${SDKPATH}/$1
  }
  gen_meson oesdk-toolchain.meson gcc g++ ar strip "$gcc_flags"
  gen_meson oesdk-toolchain-clang.meson clang clang++ llvm-ar llvm-strip "$clang_flags"
  list="$list oesdk-toolchain.meson oesdk-toolchain-clang.meson"

  # clang finds the linker as `ld` on PATH, which is Apple's Mach-O ld unless
  # environment-setup put the SDK first. clang reads <triple>.cfg from its
  # own directory for every <triple>-clang/-clang++ call, so this makes it use
  # the SDK's lld for CMake, meson and environment-setup builds alike.
  if [ "${CLANGSDK}" = "1" ]; then
    echo "-fuse-ld=lld" > "${SDK_OUTPUT}$sdkpathnative$bindir/${TARGET_SYS}.cfg"
    list="$list ${sdkpathnative#$sdkpath/}$bindir/${TARGET_SYS}.cfg"
  fi

  for f in $list; do echo "$f"; done > "${OESDK_TOOLCHAIN_FILES_LIST}"
}

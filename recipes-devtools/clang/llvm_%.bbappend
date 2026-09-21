# Unlike autotools recipes (nettle, curl), cmake.bbclass feeds CMAKE_C_FLAGS/
# CMAKE_CXX_FLAGS from CFLAGS/CXXFLAGS only, not CPPFLAGS, so the usual
# CPPFLAGS:append trick for missing nativesdk headers has no effect here.
# zstd's headers are staged in the nested nativesdk sysroot, not the runtime
# macOS SDK tree gcc's default search covers.
CFLAGS:append:class-nativesdk:darwin21 = " -I${STAGING_INCDIR}"
CXXFLAGS:append:class-nativesdk:darwin21 = " -I${STAGING_INCDIR}"

# OSXSDK is only set in clang's own bbappend, which doesn't carry over to this
# recipe's metadata, so redefine it here too.
OSXSDK:class-nativesdk:darwin21 = "${STAGING_DIR_TARGET}${SDKPATHNATIVE}/runtime"

# dsymutil (tools/dsymutil/CFBundle.cpp) needs the CoreFoundation framework;
# frameworks need -F, not -I.
CXXFLAGS:append:class-nativesdk:darwin21 = " -F${OSXSDK}/System/Library/Frameworks"

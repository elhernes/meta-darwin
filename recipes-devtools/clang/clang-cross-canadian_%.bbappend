# CMake 3.28+ looks for clang-scan-deps beside the C++ compiler, or with
# its target prefix, for every C++20 target. clang-cross-canadian links
# only clang, clang++ and a few tools with the prefix, so CMake finds
# nothing and every try_compile fails. nativesdk-clang-tools ships
# clang-scan-deps (same clang build); link it like the others. Prepended
# so cross_canadian_bindirlinks (do_install:append) picks it up too.
do_install:prepend() {
	install -d ${D}${bindir}
	ln -sf ../clang-scan-deps ${D}${bindir}/${TARGET_PREFIX}clang-scan-deps
}

RDEPENDS:${PN} += "nativesdk-clang-tools"

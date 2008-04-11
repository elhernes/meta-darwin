DESCRIPTION = "Meta package for building clutter"
LICENSE = "MIT"
DEPENDS = "opkg-native ipkg-utils-native fakeroot-native"

inherit meta

SDK_DIR = "${WORKDIR}/sdk"
SDK_OUTPUT = "${SDK_DIR}/image"
SDK_DEPLOY = "${TMPDIR}/deploy/images"

IPKG_TARGET = "opkg-cl -f ${IPKGCONF_TARGET} -o ${SDK_OUTPUT}/"

TARGET_TASK ?= "clutter clutter-examples gtk+"
TARBALL_OUTPUTNAME ?= "clutter"

RDEPENDS = "${TARGET_TASK}"

do_populate_sdk() {
	rm -rf ${SDK_OUTPUT}
	mkdir -p ${SDK_OUTPUT}

	package_update_index_ipk
	package_generate_ipkg_conf

	for arch in ${PACKAGE_ARCHS}; do
		revipkgarchs="$arch $revipkgarchs"
	done

	${IPKG_TARGET} update
	${IPKG_TARGET} install ${TARGET_TASK}

	#rm -rf ${SDK_OUTPUT}/usr/lib/ipkg/

	# Package it up
	mkdir -p ${SDK_DEPLOY}
	cd ${SDK_OUTPUT}
	fakeroot tar cfj ${SDK_DEPLOY}/${TARBALL_OUTPUTNAME}.tar.bz2 .
}

do_populate_sdk[nostamp] = "1"
do_populate_sdk[recrdeptask] = "do_package_write"
addtask populate_sdk before do_build after do_install

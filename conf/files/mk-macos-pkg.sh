#!/bin/sh
##################################################
## file: meta-darwin/conf/files/mk-macos-pkg.sh
##
## Original Author: Eric L. Hernes <eric@qinc.tv>
##
## /bin/sh script to do create macos .pkg installer for openembedded sdk
##

# $1 = SDK Title
# $2 = SDK Version
# $3 = path to SDK path files
# $4 = SDK pkg output filename

pkg_title=${1:-"OpenEmbedded SDK"}
pkg_name=${2:-"oesdk-darwin21"}
pkg_arch=${3:-"aarch64"}
pkg_vers=${4:-"x.x.x.y"}
sdk_path=${5:-".../tmp/work/armv8a-oe-linux/meta-toolchain/1.0/sdk/image"}
pkg_path=${6:-".../tmp/deploy/sdk/macos-test-sdk.pkg"}

echo "pkg_title: ${pkg_title}"
echo "pkg_name: ${pkg_name}"
echo "pkg_arch: ${pkg_arch}"
echo "pkg_vers: ${pkg_vers}"
echo "sdk_path: ${sdk_path}"
echo "pkg_path: ${pkg_path}"

count=$(find ${sdk_path} | wc -l)
set $(du -k -s ${sdk_path})
kbytes=$1

echo "SDK will contain ${count} files and consume ${kbytes}K bytes"

org_id=org.openembedded.sdk

pkg_id="${org_id}.${pkg_name}.pkg"

flat=dist/Package.pkg

build=build
mkbom=mkbom
xar=xar

files=$(realpath $(dirname $0))

rm -rf ${build}
rm -f "${pkg_path}"

mkdir ${build}
cd ${build}

mkdir -p ${flat}
mkdir scripts
dd if=/dev/random of=scripts/datafile bs=1024k count=3

( cd ${sdk_path} && find . | cpio -o --format odc --owner 0:80 | gzip -c ) > ${flat}/Payload

#
# Swift installs stuff to /Library/org.swift.swiftpm;
#
# So let's do somethign similar
# Install files to /Library/Developer/org.openembedded.sdk
#
cat > ${flat}/PackageInfo <<EOF
<pkg-info format-version="2" identifier="${pkg_id}" version="${pkg_version}" relocatable="false" overwrite-permissions="false" followSymLinks="false" install-location="/Library/Developer/org.openembedded.sdk/${sdk_name}" auth="root">
  <payload installKBytes="${kbytes}" numberOfFiles="${count}"/>
    <bundle-version/>
    <upgrade-bundle/>
    <update-bundle/>
    <atomic-update-bundle/>
    <strict-identifier/>
    <relocate/>
    <scripts>
      <preinstall file="./pre-install"/>
      <postinstall file="./post-install"/>
  </scripts>
</pkg-info>
EOF

sed -e 's,$,&,' ${files}/pre-install.in >scripts/pre-install
sed -e 's,$,&,' ${files}/post-install.in >scripts/post-install

chmod +x scripts/pre-install
chmod +x scripts/post-install

cp ${files}/xz-to-dmg.sh scripts
chmod +x scripts/xz-to-dmg.sh

( cd scripts && find . | cpio -o --format odc --owner 0:80 | gzip -c ) > ${flat}/Scripts
${mkbom} -u 0 -g 80 ${sdk_path} ${flat}/Bom

#
# XXX-ELH
#  1. should pick hostArchictecture from ${SDK_ARCH}
#

cat >dist/Distribution <<EOF
<?xml version="1.0" encoding="utf-8"?>
<installer-gui-script minSpecVersion="2">
    <title>${pkg_title}</title>
    <options customize="never" hostArchitectures="arm64"/>
    <domains enable_localSystem="true" enable_anywhere="true" enable_currentUserHome="true"/>
    <installation-check script="canInstall()"/>
    <script><![CDATA[
	function canInstall() {
		var version;
		var major;

		// ProductVersion is usually "major.minor.patch"
		if (!system || !system.version || !system.version.ProductVersion) {
			return false;
		}

		version = system.version.ProductVersion.split(".");
		major = parseInt(version[0], 10);

		if (isNaN(major)) {
			return false;
		}

		// Require macOS 13+
		if (major < 13) {
			return false;
		}

		return true;
	}

]]></script>
    <pkg-ref id="ibemizkrqf" version="1" onConclusion="none">#Package.pkg</pkg-ref>
    <pkg-ref id="ibemizkrqf" packageIdentifier="com.packagebuilder.built-installer.npwptrygwz" installKBytes="0" updateKBytes="0">
        <must-close/>
        <bundle-version/>
    </pkg-ref>
    <choices-outline>
        <line choice="ibemizkrqf"/>
    </choices-outline>
    <choice id="ibemizkrqf" title="Package" start_selected="true">
        <pkg-ref id="ibemizkrqf"/>
    </choice>
    <product id="org.openembedded.sdk.npwptrygwz" version="1"/>
</installer-gui-script>
EOF

( cd dist && ${xar} --compression none -cf "${pkg_path}" * )

ls -l ${pkg_path}

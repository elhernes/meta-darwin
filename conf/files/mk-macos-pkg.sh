#!/bin/bash
##################################################
## file: meta-darwin/conf/files/mk-macos-pkg.sh
##
## Original Author: Eric L. Hernes <eric@qinc.tv>
##
## /bin/sh script to do create macos .pkg installer for openembedded sdk
##

# $1 = SDK Title
# $2 = SDK Name
# $3 = SDK Architecture
# $4 = SDK Version
# $5 = path to SDK path files
# $6 = SDK pkg output filename
# $7 = path to finalize script
# $8 = destination path relative to the user's selected volume

pkg_title=${1:-"OpenEmbedded SDK"}
pkg_name=${2:-"oesdk-darwin21"}
pkg_arch=${3:-"aarch64"}
pkg_vers=${4:-"x.x.x.y"}
sdk_path=${5:-".../tmp/work/armv8a-oe-linux/meta-toolchain/1.0/sdk/image"}
pkg_path=${6:-".../tmp/deploy/sdk/macos-test-sdk.pkg"}
finalize_pkg=${7:-"finalize-pkg"}
dst_path=${8-"/Library/Developer/org.openembedded.sdk/${pkg_name}/x"}

echo "pkg_title: ${pkg_title}"
echo "pkg_name: ${pkg_name}"
echo "pkg_arch: ${pkg_arch}"
echo "pkg_vers: ${pkg_vers}"
echo "sdk_path: ${sdk_path}"
echo "pkg_path: ${pkg_path}"
echo "dst_path: ${dst_path}"

count=$(find ${sdk_path} -type f | wc -l)
set $(du -sk ${sdk_path})
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

( cd ${sdk_path} && find . | cpio -o --format odc --owner 0:80 | xz -c -T0 ) > ${flat}/Payload

#
# Swift installs stuff to /Library/org.swift.swiftpm;
#
# So let's do something similar
# Install files to /Library/Developer/org.openembedded.sdk
#
cat > ${flat}/PackageInfo <<EOF
<pkg-info format-version="2" identifier="${pkg_id}" version="${pkg_vers}" relocatable="false" overwrite-permissions="false" followSymLinks="false" install-location="${dst_path}" auth="root">
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

sed -e "s#@dst_path@#${dst_path}#g" \
    ${files}/pre-install.in >scripts/pre-install

cp ${files}/post-install.in scripts/post-install
cp ${finalize_pkg} scripts/finalize-pkg

chmod +x scripts/finalize-pkg
chmod +x scripts/pre-install
chmod +x scripts/post-install

( cd scripts && find . | cpio -o --format odc --owner 0:80 | gzip -c ) > ${flat}/Scripts
${mkbom} -u 0 -g 80 ${sdk_path} ${flat}/Bom

#
# linux calls it aarch64; apple calls it arm64
#

declare -A arch_map
arch_map["aarch64"]="arm64"
arch_map["x86_64"]="x86_64"

p_id=$(tr -dc 'a-z0-9' < /dev/urandom | head -c 16)
pki_id="org.openembedded.oesdk.installer.${p_id}"


cat >dist/Distribution <<EOF
<?xml version="1.0" encoding="utf-8"?>
<installer-gui-script minSpecVersion="2">
    <title>${pkg_title}</title>
    <options customize="allow" hostArchitectures="${arch_map[${pkg_arch}]}"/>
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

		// Darwin21 ==  macOS 12+
		if (major < 12) {
			return false;
		}

		return true;
	}

]]></script>
    <pkg-ref id="${p_id}" version="1" onConclusion="none">#Package.pkg</pkg-ref>
    <pkg-ref id="${p_id}" packageIdentifier="${pki_id}" installKBytes="0" updateKBytes="0">
        <must-close/>
        <bundle-version/>
    </pkg-ref>
    <choices-outline>
        <line choice="${p_id}"/>
    </choices-outline>
    <choice id="${p_id}" title="Package" start_selected="true">
        <pkg-ref id="${p_id}"/>
    </choice>
    <product id="${pkg_id}" version="${pkg_vers}"/>
</installer-gui-script>
EOF

( cd dist && ${xar} --compression none -cf "${pkg_path}" * )


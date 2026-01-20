#!/bin/bash
##################################################
## file: meta-darwin/conf/files/mk-macos-dmg.sh
##
## Original Author: Eric L. Hernes <eric@qinc.tv>
##
## /bin/sh script to do create macos .dmg image for openembedded sdk
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
dmg_path=${6:-".../tmp/deploy/sdk/macos-test-sdk.dmg"}

dest_path="/Library/Developer/org.openembedded.sdk/${pkg_name}"

set $(du -sm ${sdk_path})

# add 10% for overhead
size_mb=$((${1} * 11 / 10))

dd if=/dev/zero of="${dmg_path}" bs=1M count=${size_mb}
mkfs.hfsplus -s -v "${pkg_name}" "${dmg_path}"

hfsplus "${dmg_path}" mkdir-p "${dest_path}"

hfsplus "${dmg_path}" addall "${sdk_path}" "${dest_path}"

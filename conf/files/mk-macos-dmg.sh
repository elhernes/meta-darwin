#!/bin/bash
##################################################
## file: meta-darwin/conf/files/mk-macos-dmg.sh
##
## Original Author: Eric L. Hernes <eric@qinc.tv>
##
## /bin/sh script to do create macos .dmg image for openembedded sdk
##

# $1 = SDK Title
# $2 = SDK Name
# $3 = SDK Architecture
# $4 = SDK Version
# $5 = path to SDK path files
# $6 = SDK dmg output filename
# $7 = path to finalize script
# $8 = destination path within the DMG

pkg_title=${1:-"OpenEmbedded SDK"}
pkg_name=${2:-"oesdk-darwin21"}
pkg_arch=${3:-"aarch64"}
pkg_vers=${4:-"x.x.x.y"}
sdk_path=${5:-".../tmp/work/armv8a-oe-linux/meta-toolchain/1.0/sdk/image"}
dmg_path=${6:-".../tmp/deploy/sdk/macos-test-sdk.dmg"}
finalize_dmg=${7:-"finalize-dmg"}
dst_path=${8-"/Library/Developer/org.openembedded.sdk/${pkg_name}"}

dmg_finalize="${dst_path}/"$(basename "${finalize_dmg}")

set $(du -sm ${sdk_path})

# add 10% for overhead
size_mb=$((${1} * 11 / 10))

dd if=/dev/zero of="${dmg_path}" bs=1M count=${size_mb}
mkfs.hfsplus -s -v "${pkg_name}" "${dmg_path}"

hfsplus "${dmg_path}" mkdir-p "${dst_path}"

hfsplus "${dmg_path}" addall "${sdk_path}" "${dst_path}"

hfsplus "${dmg_path}" add "${finalize_dmg}" "${dmg_finalize}"
hfsplus "${dmg_path}" chmod 755 "${dmg_finalize}"

hfsplus "${dmg_path}" rm "${dst_path}/relocate_sdk.py"

hfsplus "${dmg_path}" rm "${dst_path}/post-relocate-setup.sh"



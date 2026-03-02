#!/bin/bash
##################################################
## file: meta-darwin/conf/files/mk-macos-img.sh
##
## Original Author: Eric L. Hernes <eric@qinc.tv>
##
## /bin/sh script to do create macos .img image for openembedded sdk
##

# $1 = SDK Title
# $2 = SDK Name
# $3 = SDK Architecture
# $4 = SDK Version
# $5 = path to SDK path files
# $6 = SDK img output filename
# $7 = path to finalize script
# $8 = destination path within the IMG

pkg_title=${1:-"OpenEmbedded SDK"}
pkg_name=${2:-"oesdk-darwin21"}
pkg_arch=${3:-"aarch64"}
pkg_vers=${4:-"x.x.x.y"}
sdk_path=${5:-".../tmp/work/armv8a-oe-linux/meta-toolchain/1.0/sdk/image"}
img_path=${6:-".../tmp/deploy/sdk/macos-test-sdk.img"}
finalize_img=${7:-"finalize-img"}
dst_path=${8-"/Library/Developer/org.openembedded.sdk/${pkg_name}"}

img_finalize="${dst_path}/"$(basename "${finalize_img}")

set $(du -sm ${sdk_path})

# add 10% for overhead
size_mb=$((${1} * 11 / 10))

dd if=/dev/zero of="${img_path}" bs=1M count=${size_mb}
mkfs.hfsplus -s -v "${pkg_name}" "${img_path}"

hfsplus "${img_path}" mkdir-p "${dst_path}"

hfsplus "${img_path}" addall "${sdk_path}" "${dst_path}"

hfsplus "${img_path}" add "${finalize_img}" "${img_finalize}"
hfsplus "${img_path}" chmod 755 "${img_finalize}"

hfsplus "${img_path}" rm "${dst_path}/relocate_sdk.py"

hfsplus "${img_path}" rm "${dst_path}/post-relocate-setup.sh"



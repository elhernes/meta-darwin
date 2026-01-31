#!/bin/sh
##################################################
## file: finalize-sdk.sh
##
##
## /bin/sh script to finalize oesdk files
##
## 1. change pathing from hardcoded path to install path
## 2. codesign binaries and dylibs
##
## This can be run on the final installed files; or during install in a staging area if we know
## what the final destination path will be.
##

x_path=$(realpath $(dirname "${0}"))
first_csid=$(security -qq find-identity -v -p codesigning |cut -c47- |head -1 | tr -d '"')

staging=${1:-"${x_path}"}
new_path=${2:-"${x_path}"}
codesign_id=${3:-"${first_csid}"}

native_sysroot="@native_sysroot@"

do_relocate=yes
do_codesign=yes

if [ "${do_relocate}" = yes ]; then
    old_path="/usr/local/oe-sdk-hardcoded-buildpath"

    find "${staging}" -type f -exec file {} +| grep -i ":.*\(ASCII\|script\|source\).*text" |cut -d: -f1  |
        while read fn; do
            sed -i "" "s,${old_path},${new_path},g" "${fn}" || echo "${fn}"
        done
fi

if [ "${do_codesign}" = yes ]; then
    if [ -z "${codesign_id}" ]; then
        echo "requested codesigning, but did not find a codesigning identity"
    else
        find "${staging}/sysroots/${native_sysroot}" -type f -exec file {} + |
            grep Mach-O | 
            cut -d: -f1 |
            sed -e "s,^,'," -e "s,$,'," |
            xargs codesign --continue --force --timestamp --sign "${codesign_id}"
    fi
fi

exit 0

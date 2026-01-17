#!/bin/sh
##################################################
## file: meta-darwin/conf/files/xz-to-dmg.sh
##
## Original Author: Eric L. Hernes <ehernes@portrait.com>
##
## /bin/sh script to do macOS SDK for OpenEmbedded during install
## this mostly to do things that cannot be done on Linux; or cannot
## be known until install time.
##
## 1. code signing - as far as I know, this cannot be done on linux
##
## 2. relocate paths and scripts to installed absolute paths
##
## 3. fix any loader pathing - this would best be done in the specific recipes,
##    but putting it here is a quick fix catch all
##
## 4. possibly build a DMG file of the installed files
##
##

##codesign_id="Apple Development: ehernes@portrait.com (2D6ABSHU57)"

sdk_name="oesdk-pdilx-v1"
codesign_id="Apple Development: Eric Hernes (548F5DVU9V)"

do_new_staging=no
do_extract=no
do_otool=no
do_codesign=no
do_relocate=yes
do_dmg=no

xz=$(realpath ${1})

staging=${sdk_name}

if [ ${do_new_staging} = yes ]; then
    rm -rf ${staging}
    mkdir ${staging}
fi

if [ ${do_extract} = yes ]; then
    (cd ${staging}; tar xf ${xz})
fi

if [ ${do_otool} = yes ]; then
    install_name_tool -change libexpat.1.dylib @loader_path/../../lib/libexpat.1.dylib ${staging}/sysroots/aarch64-oesdk-darwin21/usr/bin/aarch64-oe-linux/aarch64-oe-linux-gdb
    install_name_tool -change liblldb.18.1.6.dylib @loader_path/../lib/liblldb.18.1.6.dylib  ${staging}/sysroots/aarch64-oesdk-darwin21/usr/bin/lldb-dap
fi

if [ ${do_codesign} = yes ]; then
    security find-identity

    find ${staging}/sysroots/aarch64-oesdk-darwin21 -type f -exec file {} + |
        grep Mach-O |
        cut -d: -f1 |
        sed -e "s,^,'," -e "s,$,'," |
        xargs codesign --continue --force --timestamp --sign "${codesign_id}"
fi

set -x

if [ ${do_relocate} = yes ]; then
    old_path="/usr/local/oe-sdk-hardcoded-buildpath"
    new_path=/Volumes/${sdk_name}
    find ${staging} -type f -exec file {} +| grep -i 'ascii.*text' |cut -d: -f1  |
        while read fn; do
            echo "${fn}"
            gsed -i "s:${old_path}:${new_path}:g" "${fn}" || echo "${fn}"
        done
fi

if [ ${do_dmg} = yes ]; then
  hdiutil create -volname "${sdk_name}" -srcfolder "${sdk_name}" -ov -format UDIF "${sdk_name}.dmg"

  echo hdiutil attach -nobrowse "${sdk_name}.dmg"
fi

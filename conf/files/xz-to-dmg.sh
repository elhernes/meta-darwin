#!/bin/sh
##################################################
## file: ../work/pdi/Portrait-Displays/apps/os/pdi-linux/pdi-linux/work/sdk/xz-to-dmg.sh
##
## (C) Copyright Portrait Displays, Inc 2026
##
## Original Author: Eric L. Hernes <ehernes@portrait.com>
##
## /bin/sh script to do something
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

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
## Exits 1 without changing anything if signing can't work (no identity, or
## Apple's timestamp server unreachable), and exits 1 after the fact if any
## file failed to relocate or sign. Relocating twice is harmless, so after a
## failure fix the cause and run it again.
##

x_path=$(realpath $(dirname "${0}"))
first_csid=$(security -qq find-identity -v -p codesigning |cut -c47- |head -1 | tr -d '"')

staging=${1:-"${x_path}"}
new_path=${2:-"${x_path}"}
codesign_id=${3:-"${first_csid}"}

native_sysroot="@native_sysroot@"

do_relocate=yes
do_codesign=yes

# Every signature gets a secure timestamp from here; codesign waits on it
# without a timeout, one file at a time.
timestamp_url="http://timestamp.apple.com/ts01"

# progress <done> <total> <label>: one updating line on a terminal; in a log
# (the .pkg installer's) a line every 100 items and at the end.
progress() {
    if [ -t 1 ]; then
        printf '\r  %s %d/%d' "${3}" "${1}" "${2}"
        [ "${1}" -eq "${2}" ] && echo
    elif [ $(( ${1} % 100 )) -eq 0 ] || [ "${1}" -eq "${2}" ]; then
        echo "  ${3} ${1}/${2}"
    fi
    return 0
}

if [ "${do_codesign}" = yes ]; then
    if [ -z "${codesign_id}" ]; then
        echo "finalize: no codesigning identity found; nothing changed"
        exit 1
    fi
    if ! curl -s -m 15 -o /dev/null "${timestamp_url}"; then
        echo "finalize: can't reach ${timestamp_url}, which codesign needs; nothing changed."
        echo "finalize: check the network (DNS, VPN) and run ${0} again"
        exit 1
    fi
fi

work=$(mktemp -d -t finalize-sdk)
failed=0

if [ "${do_relocate}" = yes ]; then
    old_path="/usr/local/oe-sdk-hardcoded-buildpath"

    echo "finalize: finding text files to relocate..."
    find "${staging}" -type f -exec file {} +| grep -i ":.*\(ASCII\|script\|source\).*text" |cut -d: -f1 > "${work}/text"
    total=$(wc -l < "${work}/text" | tr -d ' ')
    echo "finalize: relocating ${total} files to ${new_path}"
    n=0
    while IFS= read -r fn; do
        n=$((n + 1))
        if ! sed -i "" "s,${old_path},${new_path},g" "${fn}" 2>> "${work}/log"; then
            echo "${fn}" >> "${work}/failed"
            failed=$((failed + 1))
        fi
        progress ${n} ${total} "relocated"
    done < "${work}/text"
fi

if [ "${do_codesign}" = yes ]; then
    echo "finalize: finding Mach-O files to sign..."
    # file adds a "<path> (for architecture ...)" line per slice of a
    # universal binary; the file itself is on its own line.
    find "${staging}/sysroots/${native_sysroot}" -type f -exec file {} + |
        grep Mach-O |
        grep -v ' (for architecture [^)]*):' |
        cut -d: -f1 > "${work}/macho"
    total=$(wc -l < "${work}/macho" | tr -d ' ')
    echo "finalize: signing ${total} files as ${codesign_id}"
    n=0
    while IFS= read -r fn; do
        n=$((n + 1))
        if ! codesign --force --timestamp --sign "${codesign_id}" "${fn}" >> "${work}/log" 2>&1; then
            echo "${fn}" >> "${work}/failed"
            failed=$((failed + 1))
        fi
        progress ${n} ${total} "signed"
    done < "${work}/macho"
fi

if [ ${failed} -gt 0 ]; then
    echo "finalize: ${failed} files failed:"
    sed 's/^/    /' "${work}/failed"
    echo "finalize: errors:"
    sed 's/^/    /' "${work}/log"
    echo "finalize: fix the cause and run ${0} again"
    rm -rf "${work}"
    exit 1
fi
rm -rf "${work}"
echo "finalize: done"

exit 0

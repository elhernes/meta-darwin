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
## Usage: finalize-sdk [-s identity] [-k keychain] [staging [new_path [identity]]]
##
##   -s identity  codesign identity: its SHA-1 hash, or a unique part of its
##                name. Default: the first valid codesigning identity found
##                (in the keychain, with -k).
##                (The third argument still works, for older callers.)
##                "-s -" signs ad-hoc: no certificate, keychain or timestamp,
##                for SDKs that stay inside the organization.
##   -k keychain  look for the identity only in this keychain file, which
##                need not be on the keychain search list. It must be
##                unlocked already.
##
## Exits 1 without changing anything if signing can't work (identity not
## found, or Apple's timestamp server unreachable; an ad-hoc signature needs
## neither), and exits 1 after the fact if any file failed to relocate or
## sign. Relocating twice is harmless, so after a failure fix the cause and
## run it again.
##

x_path=$(realpath $(dirname "${0}"))

opt_id=
keychain=
while getopts "s:k:" opt; do
    case ${opt} in
        s) opt_id=${OPTARG} ;;
        k) keychain=${OPTARG} ;;
        *) echo "usage: ${0} [-s identity] [-k keychain] [staging [new_path]]"; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

# find-identity lists '  1) <sha1> "<name>"' for each valid identity.
identities=$(security find-identity -v -p codesigning ${keychain:+"${keychain}"} 2>/dev/null |
    sed -n 's/^ *[0-9][0-9]*) //p')
# The default is the first one's hash: a name can be on more than one.
first_csid=$(echo "${identities}" | head -1 | cut -c1-40)

staging=${1:-"${x_path}"}
new_path=${2:-"${x_path}"}
codesign_id=${opt_id:-${3:-"${first_csid}"}}

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

# sign_one <file>: an ad-hoc signature has no keychain and can't carry a
# secure timestamp.
sign_one() {
    if [ "${codesign_id}" = - ]; then
        codesign --force --sign - "${1}"
    else
        codesign --force --timestamp --sign "${codesign_id}" ${keychain:+--keychain "${keychain}"} "${1}"
    fi
}

if [ "${do_codesign}" = yes ] && [ "${codesign_id}" != - ]; then
    if [ -z "${codesign_id}" ]; then
        echo "finalize: no codesigning identity found${keychain:+ in ${keychain}}; nothing changed"
        exit 1
    fi
    matches=$(echo "${identities}" | grep -cF -- "${codesign_id}")
    if [ "${matches}" -ne 1 ]; then
        echo "finalize: ${matches} valid codesigning identities match \"${codesign_id}\"${keychain:+ in ${keychain}}, need 1; nothing changed"
        [ "${matches}" -gt 1 ] && echo "${identities}" | grep -F -- "${codesign_id}" | sed 's/^/    /'
        echo "finalize: pass -s <sha1>, or -k <keychain>"
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
    if [ "${codesign_id}" = - ]; then
        echo "finalize: signing ${total} files ad-hoc"
    else
        echo "finalize: signing ${total} files as ${codesign_id}${keychain:+ from ${keychain}}"
    fi
    n=0
    while IFS= read -r fn; do
        n=$((n + 1))
        if ! sign_one "${fn}" >> "${work}/log" 2>&1; then
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

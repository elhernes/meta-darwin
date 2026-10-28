##################################################
## file: finalize-img-tail.sh
##
## appended to finalize-sdk.sh for the .img: once the SDK on the mounted
## volume is relocated and signed, turn the read-write .img into a compressed,
## read-only .dmg.  It mounts at the same /Volumes/<name>, so the relocated
## paths stay valid.
##

rm -f "${0}"

dev=$(df -P "${x_path}" | awk 'NR == 2 { print $1 }')
img=$(hdiutil info | awk -v dev="${dev}" '
    /^image-path/ { sub(/^image-path *: */, ""); path = $0 }
    $1 == dev { print path; exit }')

if [ -z "${img}" ]; then
    echo "finalize-img: can't find the image behind ${dev}; leaving it as is"
    exit 0
fi

# This script is open on the volume, which blocks the detach, so the rest
# runs from a copy outside it.
tail=$(mktemp -t finalize-img)
cat > "${tail}" <<'EOF'
dev="${1}"
img="${2}"
dmg="${img%.img}.dmg"
rm -f "${0}"

hdiutil detach "${dev}" || exit 1
hdiutil convert "${img}" -format ULFO -o "${dmg}" || exit 1
hdiutil attach "${dmg}" || exit 1
echo "finalize-img: ${dmg} is ready; ${img} can go"
EOF

cd /
exec /bin/sh "${tail}" "${dev}" "${img}"

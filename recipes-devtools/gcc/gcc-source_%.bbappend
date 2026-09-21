FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Patches 0016 and 0018 are automatically picked up from files/ directory by base recipe
# Only need to explicitly add Darwin-specific patches that come after OE patches

SRC_URI:append = " \
    file://0099-nativesdk-gcc-darwin.patch \
    file://0100-change-macosx-version-min-to-12.3.patch \
"

# Patch created using https://github.com/iains/gcc-15-branch/tree/gcc-15-3-darwin
# Applied on top of OE gcc-15.3.0 patches plus 0099/0100
SRC_URI:append = " \
    file://0101-aarch64-Darwin-support-gcc-darwin.patch \
"
# Patch to allow building aarch64 toolchain for mac on aarch64 linux
SRC_URI:append = " \
    file://0102-aarch64-on-aarch64.patch \
"

# gcc-15.3.0 tarball ships zlib/zlib.map with CRLF; 0101 tail hunk is LF-only.
python do_patch:prepend() {
    import pathlib
    p = pathlib.Path(d.getVar('S')) / 'zlib' / 'zlib.map'
    if p.is_file():
        p.write_bytes(p.read_bytes().replace(b'\r\n', b'\n'))
}

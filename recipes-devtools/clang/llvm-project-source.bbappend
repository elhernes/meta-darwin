FILESEXTRAPATHS:prepend := "${THISDIR}/clang:"
SRC_URI:append = " \
    file://0037-Fixes_for_Darwin_SDKs.patch \
"

python replace_sdk_vendor() {
    import subprocess
    bb.note("SDK_VENDOR: %s" % d.getVar('SDK_VENDOR'))
    cmd = d.expand("sed -i 's/#SDK_VENDOR#/%s/g' ${S}/clang/lib/Driver/ToolChains/Darwin.cpp" % d.getVar('SDK_VENDOR'))
    subprocess.check_output(cmd, stderr=subprocess.STDOUT, shell=True)
}

do_patch[postfuncs] += "replace_sdk_vendor"

# libattr/libacl are the GNU/Linux implementations of xattr and POSIX.1e ACL
# support; Darwin's own xattr/ACL syscalls are real but have a different,
# incompatible signature/model and neither upstream library has ever grown a
# Darwin port. Drop both PACKAGECONFIGs here: libarchive still reads/writes
# archives fine without xattr/ACL preservation.
PACKAGECONFIG:remove:class-nativesdk:darwin21 = "acl xattr"

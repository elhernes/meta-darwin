# Capability dropping is a Linux-only concept; libcap has no Darwin port
# and can't build for it (uses sys/prctl.h, byteswap.h, priority-numbered
# constructors, none of which exist on Mach-O/Darwin).
PACKAGECONFIG:remove:class-nativesdk:darwin21 = "capabilities"

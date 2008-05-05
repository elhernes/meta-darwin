#
# Copyright (C) 2008 OpenedHand Ltd.
#

DESCRIPTON = "Darwin Software Development Kit for OpenedHand Poky"
PR = "r0"

ALLOW_EMPTY = "1"

PACKAGES = "${PN} ${PN}-dbg"

RDEPENDS = "\
    task-poky-standalone-darwin-sdk-target \
    gtk+-dev \
    clutter-dev \
    "

#!/bin/bash

check() {
    return 0
}

depends() {
    return 0
}

install() {
    inst_multiple ntfs-3g kpartx losetup
    inst_hook initqueue/settled 91 "$moddir/mount-ntfsloop.sh"
}

installkernel() {
    hostonly='' instmods fuse loop
}

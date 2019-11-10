#!/bin/bash

command -v

check() {
    return 0
}

depends() {
    echo base dm
    return 0
}

install() {
    inst_multiple ntfs-3g kpartx umount losetup
    inst_script "$moddir/ntfsloop.sh" /sbin/ntfsloop
    inst_hook cmdline 90 "$moddir/parse-ntfsloop.sh"
    inst_hook shutdown 90 "$moddir/shutdown-ntfsloop.sh"

    dracut_need_initqueue
}

installkernel() {
    hostonly='' instmods ntfs fuse loop
}

#!/bin/bash

umount_ntfsloop() {
    local p

    for p in /run/initramfs/ntfsloop/*; do
        warn "Umounting ntfsloop $p"

        # shutdown the loop device
        #FIXME: we don't know which one, so we just kill them all
        losetup -D

        # umount the ntfs partition
        umount "$p/device" | (while read l; do warn "$l"; done)
    done
}

umount_ntfsloop

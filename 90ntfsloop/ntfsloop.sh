#!/bin/bash

. /lib/dracut-lib.sh

mount_ntfsloop() {
    local dev
    local uuid
    local path

    dev=$1
    uuid=$2
    path=$3

    mkdir -p "/run/initramfs/ntfsloop/$uuid/ntfs"

    # mount using ntfs-3g
    # the @ sign is so that systemd doesn't attempt to kill the ntfs-3g process
    ( exec -a @ntfs-3g ntfs-3g "$dev" "/run/initramfs/ntfsloop/$uuid/ntfs" ) | (while read l; do warn $l; done)

    # create a nice symlink for the loop device
    ln -s "/run/initramfs/ntfsloop/$uuid/ntfs/$path" "/run/initramfs/ntfsloop/$uuid/image"

    # create a symlink for the device path - this symlink will survive and
    # be there for the shutdown hook, the mount point won't
    ln -s "$dev" "/run/initramfs/ntfsloop/$uuid/device"

    # get the loop device up
    kpartx -afv "/run/initramfs/ntfsloop/$uuid/image" | (while read l; do warn $l; done)

    # make sure our shutdown script runs
    need_shutdown
}

mount_ntfsloop "$@"

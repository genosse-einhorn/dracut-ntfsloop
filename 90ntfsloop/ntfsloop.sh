#!/bin/bash

# Copyright © 2016-2019 Jonas Kümmerlin <jonas@kuemmerlin.eu>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

. /lib/dracut-lib.sh

mount_ntfsloop() {
    local dev
    local uuid
    local path

    dev=$1
    uuid=$2
    path=$3

    mkdir -p "/run/initramfs/ntfsloop/$uuid/ntfs"

    if ! ismounted "$dev"; then
        info "ntfsloop: Mounting $dev onto /run/initramfs/ntfsloop/$uuid/ntfs"

        # mount using ntfs-3g
        # the @ sign is so that systemd doesn't attempt to kill the ntfs-3g process
        ( exec -a @ntfs-3g ntfs-3g "$dev" "/run/initramfs/ntfsloop/$uuid/ntfs" ) | (while read l; do warn $l; done)

        # create a symlink for the device path - this symlink will survive and
        # be there for the shutdown hook, the mount point won't
        ln -s "$dev" "/run/initramfs/ntfsloop/$uuid/device"
    fi

    # get the loop device up
    info "ntfsloop: Creating loop device for $path"
    kpartx -afv "/run/initramfs/ntfsloop/$uuid/ntfs/$path" | (while read l; do warn $l; done)

    # make sure our shutdown script runs
    need_shutdown
}

mount_ntfsloop "$@"

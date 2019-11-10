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

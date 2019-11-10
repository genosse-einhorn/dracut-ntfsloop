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

parse_ntfsloop() {
    local n
    local dev
    local path

    # truncate rule file
    : > /etc/udev/rules.d/90-ntfsloop.rules

    for n in $(getargs rd.ntfsloop=); do
        dev=${n%%:*}
        path=${n##*:}

        if [ -z "$dev" ] || [ -z "$path" ]
        then
            warn "Wrong format: rd.ntfsloop=$n"
            continue
        fi

        # create udev rule for this device
        {
            printf '# rd.ntfsloop=%s\n' "$n"
            udevmatch "$dev" || {
                warn "Illegal device specification: $dev"
                continue
            }
            printf ', '

            printf 'RUN+="%s --settled --onetime ' $(command -v initqueue)
            printf '%s ' $(command -v ntfsloop)
            printf '$env{DEVNAME} $env{ID_FS_UUID} '\''%s'\''"\n\n' "$path"
        } >> /etc/udev/rules.d/90-ntfsloop.rules
    done
}

parse_ntfsloop

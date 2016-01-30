#!/bin/bash

parse_ntfsloop() {
    local n
    local dev
    local uuid
    local path

    # truncate rule file
    : > /etc/udev/rules.d/90-ntfsloop.rules

    for n in $(getargs rd.ntfsloop=); do
        dev=${n%%:*}
        path=${n##*:}
        uuid=${dev#UUID=}

        if [ -z "$dev" ] || [ -z "$path" ]
        then
            warn "Wrong format: rd.ntfsloop=$n"
            continue
        fi

        # create udev rule for this device
        {
            if [ "x$dev" = "x$uuid" ]; then
                # no uuid -> device path
                printf 'ENV{DEVNAME}=="%s", ' "${dev}"
            else
                printf 'ENV{ID_FS_UUID}=="%s", ' "${uuid}"
            fi

            printf 'RUN+="%s --settled --unique --onetime ' $(command -v initqueue)
            printf '%s ' $(command -v ntfsloop)
            printf '$env{DEVNAME} $env{ID_FS_UUID} '\''%s'\''"\n' "$path"
        } >> /etc/udev/rules.d/90-ntfsloop.rules
    done
}

parse_ntfsloop

#!/bin/bash

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

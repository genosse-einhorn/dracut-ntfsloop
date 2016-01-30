#!/bin/bash

. /lib/dracut-lib.sh

mount_ntfsloop()
{
    local n
    local uuid
    local path
    for n in $(getargs rd.ntfsloop=)
    do
        uuid=${n%%:*}
        path=${n##*:}

        if [ -z "$uuid" ] || [ -z "$path" ]
        then
            warn "Wrong format: rd.ntfsloop=$n"
            continue
        fi

        mkdir -p "/ntfsloop/$uuid"
        if [ ! -n "$(cat /proc/mounts | grep "/ntfsloop/$uuid")" ]
        then
            ( exec -a '@ntfs-3g' ntfs-3g "/dev/disk/by-uuid/$uuid" "/ntfsloop/$uuid" ) | ( while read l; do warn "ntfs-3g: $l"; done )

            kpartx -av /ntfsloop/$uuid/$path | ( while read l; do warn "kpartx: $l"; done )
        fi
    done
}

mount_ntfsloop

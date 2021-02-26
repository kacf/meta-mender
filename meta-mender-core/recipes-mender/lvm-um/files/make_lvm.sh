#!/bin/bash

set -e

VG_NAME="devicevg"

parse_size() {
    local part=${1%,*}
    local size=${1#*,}
    eval SIZE_$part=$size
}

while [ -n "$1" ]; do
    case "$1" in
        --size=*)
            parse_size "$1"
            ;;
        -s|--size)
            shift
            parse_size "$1"
            ;;

        --input-image=*)
            INPUT="${1#--input-image=}"
            ;;
        -i|--input-image)
            shift
            INPUT="$1"
            ;;

        --output-image=*)
            OUTPUT="${1#--output-image=}"
            ;;
        -o|--output-image)
            shift
            OUTPUT="$1"
            ;;

        --vg-name=*)
            VG_NAME="${1#--device=}"
            ;;
        -V|--vg-name)
            shift
            VG_NAME="$1"
            ;;
    esac
    shift
done

cleanup() {
    set +e

    vgchange -an "$VG_NAME"
    umount -l tmp-mount
    losetup -d "$INPUT_LO"
    losetup -d "$OUTPUT_LO"
    pvscan --cache
    rmdir tmp-mount
}
trap cleanup EXIT

# Start by copying the original.
cp "$INPUT" "$OUTPUT"

INPUT_LO="$(losetup -P -f --show "$INPUT")"
sleep 1

if file -s "${INPUT_LO}p1" | grep -q '\bFAT\b'; then
    BOOT_PARTITION=1
else
    BOOT_PARTITION=0
fi

mkdir -p tmp-mount

# Erase all other partitions from the copy, and recreate them inside the new VG
# instead.
for lo in "$INPUT_LO"p*; do
    if [ "$lo" = "${INPUT_LO}p1" -a "$BOOT_PARTITION" = 1 ]; then
        continue
    fi

    sfdisk -q --no-tell-kernel --delete "$OUTPUT" "${lo#${INPUT_LO}p}"
done
# The UUID is "Linux LVM".
echo type=E6D6D379-F507-44C2-A23C-238F2A3DF928 | sfdisk -q --no-tell-kernel "$OUTPUT" -a -X gpt

OUTPUT_LO="$(losetup -P -f --show "$OUTPUT")"

vgcreate -y "$VG_NAME" "${OUTPUT_LO}p$(($BOOT_PARTITION+1))"

DATA_NAME=data
for lo in "$INPUT_LO"p*; do
    if [ "$lo" = "${INPUT_LO}p1" -a "$BOOT_PARTITION" = 1 ]; then
        continue
    fi

    mount "$lo" tmp-mount -o ro
    if [ -e tmp-mount/etc/passwd ]; then
        if [ -z "$ROOTFS_A" ]; then
            ROOTFS_A="$lo"
        elif [ -z "$ROOTFS_B" ]; then
            ROOTFS_B="$lo"
        fi
    fi
    umount -l tmp-mount

    if [ "$lo" = "$ROOTFS_B" ]; then
        # Don't create a rootfs B, this will be the snapshot.
        continue
    fi

    if [ "$lo" = "$ROOTFS_A" ]; then
        NAME=rootfs1
    else
        NAME="$DATA_NAME"
        if [ "$DATA_NAME" = "data" ]; then
            DATA_NAME=data2
        else
            DATA_NAME="data$((${DATA_NAME#data}+1))"
        fi
    fi

    # Use specified size if possible, otherwise use the original size.
    if eval test -n \"\$SIZE_$NAME\"; then
        eval SIZE=\"\$SIZE_$NAME\"
    else
        SIZE=$(blockdev --getsize64 "$lo")
    fi

    lvcreate --size ${SIZE}b --name "$NAME" "$VG_NAME"
    dd if="$lo" of="/dev/$VG_NAME/$NAME"
    resize2fs "/dev/$VG_NAME/$NAME" $(($SIZE / 512))s
done

echo "OUTPUT: -----------------------------------------------------------------------"
sfdisk -l "$OUTPUT_LO"
echo "-------------------------------------------------------------------------------"
vgs "$VG_NAME"
echo "-------------------------------------------------------------------------------"
lvs "$VG_NAME"
echo "-------------------------------------------------------------------------------"

chown --reference "$(dirname "$OUTPUT")" "$OUTPUT"

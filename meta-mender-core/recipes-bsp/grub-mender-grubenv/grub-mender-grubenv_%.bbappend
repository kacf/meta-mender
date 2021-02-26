do_configure_append() {
    cat >> ${B}/mender_grubenv_defines <<EOF
mender_kernela_part=1
mender_kernelb_part=1
initrd_imagetype=initrd
EOF
}
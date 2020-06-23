FILESEXTRAPATHS_prepend_mender-enabled := "${THISDIR}/files:"
SRC_URI_append_arm_mender-enabled = " file://02_qemu_console_arm_grub.cfg;subdir=git"
SRC_URI_append_x86-64_mender-enabled = " file://02_qemu_console_x86_grub.cfg;subdir=git"

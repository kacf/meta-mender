FILESEXTRAPATHS_prepend_mender-grub := "${THISDIR}/files:"

inherit ${@mender_feature_is_enabled('mender-grub', 'mender-grub-efi-impl', '', d)}

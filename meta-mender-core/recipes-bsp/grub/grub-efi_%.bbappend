FILESEXTRAPATHS_prepend_mender-client-install := "${THISDIR}/files:"

inherit ${@mender_feature_is_enabled('mender-grub', 'mender-grub-efi-impl', '', d)}

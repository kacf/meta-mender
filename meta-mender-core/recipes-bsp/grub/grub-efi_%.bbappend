FILESEXTRAPATHS_prepend_mender-enabled := "${THISDIR}/files:"

# Using this syntax allows the primary implementation code to be
# conditionally included only when Mender is enabled. This allows
# these layers to be included in a configuration without changing
# the build unless specifically enabled.
GRUB_MENDER_EFI_IMPL=""
GRUB_MENDER_EFI_IMPL_mender-enabled="mender-grub-efi-impl"
inherit ${GRUB_MENDER_EFI_IMPL}

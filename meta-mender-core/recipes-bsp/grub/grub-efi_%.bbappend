FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append_cfg_file += " file://cfg"

EFI_PROVIDER ?= "${_MENDER_EFI_PROVIDER_DEFAULT}"
_MENDER_EFI_PROVIDER_DEFAULT = ""
_MENDER_EFI_PROVIDER_DEFAULT_mender-grub = "grub-efi"
_MENDER_EFI_PROVIDER_DEFAULT_mender-grub_mender-bios = ""

include grub-mender.inc

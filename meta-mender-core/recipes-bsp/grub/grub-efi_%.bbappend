FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append_cfg_file += " file://cfg"

# It's actually U-Boot that needs the dtb files to be in the boot partition, in
# order to load EFI apps correctly, but due to the wide range of U-Boot recipes
# out there, it's easier to add the dependency here.
RDEPENDS_${PN}_append_mender-image_mender-grub_arm = " boot-partition-devicetree"
RDEPENDS_${PN}_append_mender-image_mender-grub_aarch64 = " boot-partition-devicetree"

EFI_PROVIDER ?= "${_MENDER_EFI_PROVIDER_DEFAULT}"
_MENDER_EFI_PROVIDER_DEFAULT = ""
_MENDER_EFI_PROVIDER_DEFAULT_mender-grub = "grub-efi"
_MENDER_EFI_PROVIDER_DEFAULT_mender-grub_mender-bios = ""

do_check_config_efi_stub() {
}
do_check_config_efi_stub_mender-grub() {
    # The first "if" is just to make sure "file" is working correctly.
    if file -Lk ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE} | fgrep "Linux kernel"; then
        if ! file -Lk ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE} | fgrep "EFI application"; then
            bbwarn 'Kernel without CONFIG_EFI_STUB detected. This kernel will probably not boot with the current configuration (mender-grub). Mender tries to automatically apply the CONFIG_EFI_STUB configuration, but this does not always work. Consider adding the "enable_efi_stub.cfg" file, from the meta-mender repository, to the SRC_URI of your kernel recipe manually.'
        fi
    fi
}
do_check_config_efi_stub_mender-grub_mender-bios() {
}
addtask do_check_config_efi_stub before do_configure
do_check_config_efi_stub[depends] = "virtual/kernel:do_deploy"

include grub-mender.inc

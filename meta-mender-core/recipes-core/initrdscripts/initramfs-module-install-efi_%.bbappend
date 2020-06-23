FILESEXTRAPATHS_prepend_mender-enabled := "${THISDIR}/files:"

SRC_URI_append_mender-enabled = " file://init-install-efi-mender.sh "

do_install_append_mender-enabled() {
    # Overwrite the version of this file provided by upstream
    sed -ie 's#[@]MENDER_STORAGE_DEVICE[@]#${MENDER_STORAGE_DEVICE}#' ${WORKDIR}/init-install-efi-mender.sh
    install -m 0755 ${WORKDIR}/init-install-efi-mender.sh ${D}/init.d/install-efi.sh
}

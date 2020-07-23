FILESEXTRAPATHS_prepend_mender-enabled := "${THISDIR}/files:"

SRC_URI_append_mender-enabled = " file://wireless.network"

FILES_${PN}_append_mender-enabled = " \
    ${sysconfdir}/systemd/network/wireless.network \
"

do_install_append_mender-enabled() {
        install -d ${D}${sysconfdir}/systemd/network
        install -m 0755 ${WORKDIR}/wireless.network ${D}${sysconfdir}/systemd/network
}

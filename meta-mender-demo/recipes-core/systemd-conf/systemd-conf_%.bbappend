FILESEXTRAPATHS_prepend_mender-enabled := "${THISDIR}/files:"

SRC_URI_append_mender-enabled = " \
    file://eth.network \
    file://en.network \
"

FILES_${PN}_append_mender-enabled = " \
    ${sysconfdir}/systemd/network/eth.network \
    ${sysconfdir}/systemd/network/en.network \
"

do_install_append_mender-enabled() {
        install -d ${D}${sysconfdir}/systemd/network
        install -m 0755 ${WORKDIR}/eth.network ${D}${sysconfdir}/systemd/network
        install -m 0755 ${WORKDIR}/en.network ${D}${sysconfdir}/systemd/network
}

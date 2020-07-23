FILESEXTRAPATHS_prepend_mender-enabled := "${THISDIR}/files:"

SRC_URI_append_mender-enabled = " file://server.crt"

MENDER_UPDATE_POLL_INTERVAL_SECONDS_mender-enabled = "5"
MENDER_INVENTORY_POLL_INTERVAL_SECONDS_mender-enabled = "5"
MENDER_RETRY_POLL_INTERVAL_SECONDS_mender-enabled = "30"

PACKAGECONFIG_append_mender-enabled = " modules"

MENDER_CERT_LOCATION_mender-enabled ?= "${docdir}/mender-client/examples/demo.crt"

# We need this because the certificate will automatically end up in the
# mender-doc package when placed in ${docdir}.
RDEPENDS_${PN}_append_mender-enabled = " ${PN}-doc"

do_compile_prepend_mender-enabled() {
  bbwarn "You are building with the mender-demo layer, which is not intended for production use"
}

FILESEXTRAPATHS_prepend_mender-enabled := "${THISDIR}/files:"

SRC_URI_append_mender-enabled = " \
	file://mender.io.png \
"

SPLASH_IMAGES_mender-enabled = "file://mender.io.png;outsuffix=default"

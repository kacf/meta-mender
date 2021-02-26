FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = "file://lvm-um"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

S = "${WORKDIR}"

FILES_${PN} = "${datadir}/mender/modules/v3/lvm-um"

do_install() {
    install -d -m 755 ${D}${datadir}/mender/modules/v3
    install -m 755 ${S}/lvm-um ${D}${datadir}/mender/modules/v3/
}

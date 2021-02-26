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

inherit systemd

SYSTEMD_SERVICE_${PN}_append = " lvm-activation-workaround.service"
FILES_${PN}_append += " ${systemd_unitdir}/system/lvm-activation-workaround.service"

do_install_append() {
    install -d -m 755 ${D}${systemd_unitdir}/system
    cat > ${D}${systemd_unitdir}/system/lvm-activation-workaround.service <<EOF
[Unit]
Description=Workaround for LVM activation failure on Yocto
Requires=systemd-udevd.service
DefaultDependencies=no

[Install]
RequiredBy=$(echo ${MENDER_DATA_PART} | sed -e 's,^/,,; s,/,-,g').device

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'lvchange -an ${MENDER_DATA_PART} && lvchange -ay ${MENDER_DATA_PART}'
EOF
}

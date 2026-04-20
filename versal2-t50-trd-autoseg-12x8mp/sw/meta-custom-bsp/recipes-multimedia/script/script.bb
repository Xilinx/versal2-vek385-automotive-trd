SUMMARY = "script for pipelines running"
DESCRIPTION = "script for ISP 12x8MP and 6x8MP  pipelines"
LICENSE="CLOSED"

S = "${WORKDIR}"


SRC_URI = "file://imx728.sh \
"

do_install() {
    install -d ${D}${datadir}
    install -m 0644 ${WORKDIR}/imx728.sh ${D}${datadir}/imx728.sh

}
FILES:${PN} += "${datadir}/imx728.sh"




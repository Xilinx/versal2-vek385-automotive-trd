SUMMARY = "script for pipelines running"
DESCRIPTION = "script for ISP 12x pipelines"
LICENSE="CLOSED"

S = "${WORKDIR}"


SRC_URI = "file://12sensors_pipelines.sh \
"

do_install() {
    install -d ${D}${datadir}
    install -m 0644 ${WORKDIR}/12sensors_pipelines.sh ${D}${datadir}/12sensors_pipelines.sh

}
FILES:${PN} += "${datadir}/12sensors_pipelines.sh"




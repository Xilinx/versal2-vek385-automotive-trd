SUMMARY = "scripts for pipelines running"
DESCRIPTION = "scripts for ISP 12x and 4+1 pipelines"
LICENSE="CLOSED"

S = "${WORKDIR}"


SRC_URI = "file://run_4_1_pipelines.sh \
	   file://running_commands.sh \
"

do_install() {
    install -d ${D}${datadir}
    install -m 0644 ${WORKDIR}/run_4_1_pipelines.sh ${D}${datadir}/run_4_1_pipelines.sh
    install -m 0644 ${WORKDIR}/running_commands.sh ${D}${datadir}/running_commands.sh

}
FILES:${PN} += "${datadir}/run_4_1_pipelines.sh"
FILES:${PN} += "${datadir}/running_commands.sh"




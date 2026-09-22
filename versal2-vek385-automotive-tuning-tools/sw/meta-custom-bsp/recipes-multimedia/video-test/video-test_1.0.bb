SUMMARY = "ISP Validation Video Test Application"
DESCRIPTION = "Prebuilt video_test binary used to validate ISP video pipelines."
LICENSE = "CLOSED"

S = "${WORKDIR}"

SRC_URI = "file://video_test"

RDEPENDS:${PN} += "libdrm"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/video_test ${D}${bindir}/video_test
}

FILES:${PN} += "${bindir}/video_test"

INSANE_SKIP:${PN} += "ldflags"


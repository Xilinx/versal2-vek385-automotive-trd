# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
# -----------------------------------------------
#CLK


set_property PACKAGE_PIN AR41     [get_ports "MIPI3_clk_p"]
set_property PACKAGE_PIN AT42     [get_ports "MIPI3_clk_n"]


#D0


set_property PACKAGE_PIN AU41     [get_ports "MIPI3_data_p[0]"]
set_property PACKAGE_PIN AU42     [get_ports "MIPI3_data_n[0]"]

#D1


set_property PACKAGE_PIN AV37     [get_ports "MIPI3_data_p[1]"]
set_property PACKAGE_PIN AV38     [get_ports "MIPI3_data_n[1]"]


#D2


set_property PACKAGE_PIN AU38     [get_ports "MIPI3_data_p[2]"]
set_property PACKAGE_PIN AU39     [get_ports "MIPI3_data_n[2]"]

#D3


set_property PACKAGE_PIN AR38     [get_ports "MIPI3_data_p[3]"]
set_property PACKAGE_PIN AT39     [get_ports "MIPI3_data_n[3]"]

set_property IOSTANDARD MIPI_DPHY [get_ports "MIPI3_*"]
set_property DIFF_TERM_ADV TERM_100 [get_ports "MIPI3_*"]


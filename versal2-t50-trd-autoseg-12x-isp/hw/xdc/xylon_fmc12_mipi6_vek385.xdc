# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
# -----------------------------------------------
#CLK


set_property PACKAGE_PIN AW21     [get_ports "MIPI6_clk_p"]
set_property PACKAGE_PIN AY21     [get_ports "MIPI6_clk_n"]


#D0


set_property PACKAGE_PIN BB21     [get_ports "MIPI6_data_p[0]"]
set_property PACKAGE_PIN BB22     [get_ports "MIPI6_data_n[0]"]

#D1


set_property PACKAGE_PIN BB24     [get_ports "MIPI6_data_p[1]"]
set_property PACKAGE_PIN BB25     [get_ports "MIPI6_data_n[1]"]


#D2


set_property PACKAGE_PIN BC20     [get_ports "MIPI6_data_p[2]"]
set_property PACKAGE_PIN BC21     [get_ports "MIPI6_data_n[2]"]

#D3


set_property PACKAGE_PIN AY23     [get_ports "MIPI6_data_p[3]"]
set_property PACKAGE_PIN AY24     [get_ports "MIPI6_data_n[3]"]

set_property IOSTANDARD MIPI_DPHY [get_ports "MIPI6_*"]
set_property DIFF_TERM_ADV TERM_100 [get_ports "MIPI6_*"]


# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
# -----------------------------------------------
#CLK


set_property PACKAGE_PIN AL36     [get_ports "MIPI4_clk_p"]
set_property PACKAGE_PIN AM37     [get_ports "MIPI4_clk_n"]


#D0


set_property PACKAGE_PIN AL39     [get_ports "MIPI4_data_p[0]"]
set_property PACKAGE_PIN AM40     [get_ports "MIPI4_data_n[0]"]

#D1


set_property PACKAGE_PIN AR35     [get_ports "MIPI4_data_p[1]"]
set_property PACKAGE_PIN AP36     [get_ports "MIPI4_data_n[1]"]


#D2


set_property PACKAGE_PIN AP41     [get_ports "MIPI4_data_p[2]"]
set_property PACKAGE_PIN AP42     [get_ports "MIPI4_data_n[2]"]

#D3


set_property PACKAGE_PIN AM38     [get_ports "MIPI4_data_p[3]"]
set_property PACKAGE_PIN AL38     [get_ports "MIPI4_data_n[3]"]

set_property IOSTANDARD MIPI_DPHY [get_ports "MIPI4_*"]
set_property DIFF_TERM_ADV TERM_100 [get_ports "MIPI4_*"]


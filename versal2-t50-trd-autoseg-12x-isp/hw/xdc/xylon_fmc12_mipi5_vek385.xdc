# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
# -----------------------------------------------

#CLK


set_property PACKAGE_PIN AR44     [get_ports "MIPI5_clk_p"]
set_property PACKAGE_PIN AT45     [get_ports "MIPI5_clk_n"]


#D0


set_property PACKAGE_PIN AT43     [get_ports "MIPI5_data_p[0]"]
set_property PACKAGE_PIN AR43     [get_ports "MIPI5_data_n[0]"]

#D1


set_property PACKAGE_PIN AV40     [get_ports "MIPI5_data_p[1]"]
set_property PACKAGE_PIN AV41     [get_ports "MIPI5_data_n[1]"]


#D2


set_property PACKAGE_PIN AV43     [get_ports "MIPI5_data_p[2]"]
set_property PACKAGE_PIN AV44     [get_ports "MIPI5_data_n[2]"]

#D3


set_property PACKAGE_PIN AT40     [get_ports "MIPI5_data_p[3]"]
set_property PACKAGE_PIN AR40     [get_ports "MIPI5_data_n[3]"]

set_property IOSTANDARD MIPI_DPHY [get_ports "MIPI5_*"]
set_property DIFF_TERM_ADV TERM_100 [get_ports "MIPI5_*"]


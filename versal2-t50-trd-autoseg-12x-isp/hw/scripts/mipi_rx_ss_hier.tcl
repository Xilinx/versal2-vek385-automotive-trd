# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
# -----------------------------------------------


################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2026.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   common::send_gid_msg -ssname BD::TCL -id 2040 -severity "CRITICAL WARNING" "This script was generated using Vivado <$scripts_vivado_version> without IP versions in the create_bd_cell commands, but is now being run in <$current_vivado_version> of Vivado. There may have been changes to the IP between Vivado <$scripts_vivado_version> and <$current_vivado_version>, which could impact the functionality and configuration of the design."

}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:smartconnect:*\
xilinx.com:ip:axis_broadcaster:*\
xilinx.com:inline_hdl:ilvector_logic:*\
xilinx.com:inline_hdl:ilconcat:*\
xilinx.com:ip:visp_ss:*\
xilinx.com:ip:axi_noc2:*\
xilinx.com:ip:axi_iic:*\
xilinx.com:ip:mipi_csi2_rx_subsystem:*\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: hier_mipi_3
proc create_hier_cell_hier_mipi_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_mipi_3() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 mipi_phy_if

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_ctrl

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 sensor_axis_video


  # Create pins
  create_bd_pin -dir I -type clk dphy_clk_200M
  create_bd_pin -dir I -type clk sensor_aclk
  create_bd_pin -dir I -type rst sensor_aresetn
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir O header_valid
  create_bd_pin -dir O -from 31 -to 0 header_data
  create_bd_pin -dir O csirxss_csi_irq
  create_bd_pin -dir O rxwordclkhs_out
  create_bd_pin -dir O frame_rcvd_pulse_out
  create_bd_pin -dir I -type clk shared_pll_clkoutphy_in_0
  create_bd_pin -dir I -type clk cnts_rxwordclkhs_in_0
  create_bd_pin -dir I shared_pll_locked_in_0
  create_bd_pin -dir I shared_pll_clkoutphy_90_in_0

  # Create instance: mipi_csi2_rx_subsyst_0, and set properties
  set mipi_csi2_rx_subsyst_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mipi_csi2_rx_subsystem mipi_csi2_rx_subsyst_0 ]
  set_property -dict [list \
    CONFIG.CMN_NUM_LANES {4} \
    CONFIG.CMN_NUM_PIXELS {4} \
    CONFIG.CMN_PXL_FORMAT {RAW12} \
    CONFIG.CMN_VC {All} \
    CONFIG.CSI_BUF_DEPTH {4096} \
    CONFIG.C_CSI_EN_ACTIVELANES {true} \
    CONFIG.C_CSI_FILTER_USERDATATYPE {true} \
    CONFIG.C_DPHY_LANES {4} \
    CONFIG.C_SPRT_ISP_BRIDGE {true} \
    CONFIG.DPY_EN_REG_IF {true} \
    CONFIG.DPY_LINE_RATE {1500} \
    CONFIG.SupportLevel {0} \
  ] $mipi_csi2_rx_subsyst_0


  # Create interface connections
  connect_bd_intf_net -intf_net mipi_csi2_rx_subsyst_0_video_out [get_bd_intf_pins mipi_csi2_rx_subsyst_0/video_out] [get_bd_intf_pins sensor_axis_video]
  connect_bd_intf_net -intf_net mipi_phy_if [get_bd_intf_pins mipi_phy_if] [get_bd_intf_pins mipi_csi2_rx_subsyst_0/mipi_phy_if]
  connect_bd_intf_net -intf_net s_axi_ctrl [get_bd_intf_pins s_axi_ctrl] [get_bd_intf_pins mipi_csi2_rx_subsyst_0/csirxss_s_axi]

  # Create port connections
  connect_bd_net -net cnts_rxwordclkhs_in_0_1  [get_bd_pins cnts_rxwordclkhs_in_0] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/cnts_rxwordclkhs_in]
  connect_bd_net -net csirxss_csi_irq  [get_bd_pins mipi_csi2_rx_subsyst_0/csirxss_csi_irq] \
  [get_bd_pins csirxss_csi_irq]
  connect_bd_net -net dphy_clk_200M  [get_bd_pins dphy_clk_200M] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/dphy_clk_200M]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_frame_rcvd_pulse_out  [get_bd_pins mipi_csi2_rx_subsyst_0/frame_rcvd_pulse_out] \
  [get_bd_pins frame_rcvd_pulse_out]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_header_data  [get_bd_pins mipi_csi2_rx_subsyst_0/header_data] \
  [get_bd_pins header_data]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_header_valid  [get_bd_pins mipi_csi2_rx_subsyst_0/header_valid] \
  [get_bd_pins header_valid]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_rxwordclkhs_out  [get_bd_pins mipi_csi2_rx_subsyst_0/rxwordclkhs_out] \
  [get_bd_pins rxwordclkhs_out]
  connect_bd_net -net s_axi_aclk_1  [get_bd_pins s_axi_aclk] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/lite_aclk]
  connect_bd_net -net s_axi_aresetn_1  [get_bd_pins s_axi_aresetn] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/lite_aresetn]
  connect_bd_net -net sensor_aclk_1  [get_bd_pins sensor_aclk] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/video_aclk]
  connect_bd_net -net sensor_aresetn_1  [get_bd_pins sensor_aresetn] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/video_aresetn]
  connect_bd_net -net shared_pll_clkoutphy_90_in_0_1  [get_bd_pins shared_pll_clkoutphy_90_in_0] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/shared_pll_clkoutphy_90_in]
  connect_bd_net -net shared_pll_clkoutphy_in_0_1  [get_bd_pins shared_pll_clkoutphy_in_0] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/shared_pll_clkoutphy_in]
  connect_bd_net -net shared_pll_locked_in_0_1  [get_bd_pins shared_pll_locked_in_0] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/shared_pll_locked_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_mipi_2
proc create_hier_cell_hier_mipi_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_mipi_2() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 mipi_phy_if

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_ctrl

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 sensor_axis_video


  # Create pins
  create_bd_pin -dir I -type clk dphy_clk_200M
  create_bd_pin -dir I -type clk sensor_aclk
  create_bd_pin -dir I -type rst sensor_aresetn
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir O header_valid
  create_bd_pin -dir O -from 31 -to 0 header_data
  create_bd_pin -dir O csirxss_csi_irq
  create_bd_pin -dir O rxwordclkhs_out
  create_bd_pin -dir O frame_rcvd_pulse_out
  create_bd_pin -dir O clkoutphy_out
  create_bd_pin -dir O pll_clkoutphy_90_out
  create_bd_pin -dir O cnts_rxwordclkhs_out
  create_bd_pin -dir O pll_lock_out

  # Create instance: mipi_csi2_rx_subsyst_0, and set properties
  set mipi_csi2_rx_subsyst_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mipi_csi2_rx_subsystem mipi_csi2_rx_subsyst_0 ]
  set_property -dict [list \
    CONFIG.CMN_NUM_LANES {4} \
    CONFIG.CMN_NUM_PIXELS {4} \
    CONFIG.CMN_PXL_FORMAT {RAW12} \
    CONFIG.CMN_VC {All} \
    CONFIG.CSI_BUF_DEPTH {4096} \
    CONFIG.C_CSI_EN_ACTIVELANES {true} \
    CONFIG.C_CSI_FILTER_USERDATATYPE {true} \
    CONFIG.C_DPHY_LANES {4} \
    CONFIG.C_SPRT_ISP_BRIDGE {true} \
    CONFIG.DPY_EN_REG_IF {true} \
    CONFIG.DPY_LINE_RATE {1500} \
    CONFIG.SupportLevel {1} \
  ] $mipi_csi2_rx_subsyst_0


  # Create interface connections
  connect_bd_intf_net -intf_net mipi_csi2_rx_subsyst_0_video_out [get_bd_intf_pins mipi_csi2_rx_subsyst_0/video_out] [get_bd_intf_pins sensor_axis_video]
  connect_bd_intf_net -intf_net mipi_phy_if [get_bd_intf_pins mipi_phy_if] [get_bd_intf_pins mipi_csi2_rx_subsyst_0/mipi_phy_if]
  connect_bd_intf_net -intf_net s_axi_ctrl [get_bd_intf_pins s_axi_ctrl] [get_bd_intf_pins mipi_csi2_rx_subsyst_0/csirxss_s_axi]

  # Create port connections
  connect_bd_net -net csirxss_csi_irq  [get_bd_pins mipi_csi2_rx_subsyst_0/csirxss_csi_irq] \
  [get_bd_pins csirxss_csi_irq]
  connect_bd_net -net dphy_clk_200M  [get_bd_pins dphy_clk_200M] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/dphy_clk_200M]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_clkoutphy_out  [get_bd_pins mipi_csi2_rx_subsyst_0/clkoutphy_out] \
  [get_bd_pins clkoutphy_out]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_cnts_rxwordclkhs_out  [get_bd_pins mipi_csi2_rx_subsyst_0/cnts_rxwordclkhs_out] \
  [get_bd_pins cnts_rxwordclkhs_out]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_frame_rcvd_pulse_out  [get_bd_pins mipi_csi2_rx_subsyst_0/frame_rcvd_pulse_out] \
  [get_bd_pins frame_rcvd_pulse_out]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_header_data  [get_bd_pins mipi_csi2_rx_subsyst_0/header_data] \
  [get_bd_pins header_data]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_header_valid  [get_bd_pins mipi_csi2_rx_subsyst_0/header_valid] \
  [get_bd_pins header_valid]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_pll_clkoutphy_90_out  [get_bd_pins mipi_csi2_rx_subsyst_0/pll_clkoutphy_90_out] \
  [get_bd_pins pll_clkoutphy_90_out]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_pll_lock_out  [get_bd_pins mipi_csi2_rx_subsyst_0/pll_lock_out] \
  [get_bd_pins pll_lock_out]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_rxwordclkhs_out  [get_bd_pins mipi_csi2_rx_subsyst_0/rxwordclkhs_out] \
  [get_bd_pins rxwordclkhs_out]
  connect_bd_net -net s_axi_aclk_1  [get_bd_pins s_axi_aclk] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/lite_aclk]
  connect_bd_net -net s_axi_aresetn_1  [get_bd_pins s_axi_aresetn] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/lite_aresetn]
  connect_bd_net -net sensor_aclk_1  [get_bd_pins sensor_aclk] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/video_aclk]
  connect_bd_net -net sensor_aresetn_1  [get_bd_pins sensor_aresetn] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/video_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_mipi_1
proc create_hier_cell_hier_mipi_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_mipi_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 mipi_phy_if

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_ctrl

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 sensor_axis_video


  # Create pins
  create_bd_pin -dir I -type clk dphy_clk_200M
  create_bd_pin -dir I -type clk sensor_aclk
  create_bd_pin -dir I -type rst sensor_aresetn
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir O header_valid
  create_bd_pin -dir O -from 31 -to 0 header_data
  create_bd_pin -dir O csirxss_csi_irq
  create_bd_pin -dir O rxwordclkhs_out
  create_bd_pin -dir O frame_rcvd_pulse_out
  create_bd_pin -dir O clkoutphy_out
  create_bd_pin -dir O pll_clkoutphy_90_out
  create_bd_pin -dir O cnts_rxwordclkhs_out
  create_bd_pin -dir O pll_lock_out

  # Create instance: mipi_csi2_rx_subsyst_0, and set properties
  set mipi_csi2_rx_subsyst_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mipi_csi2_rx_subsystem mipi_csi2_rx_subsyst_0 ]
  set_property -dict [list \
    CONFIG.CMN_NUM_LANES {4} \
    CONFIG.CMN_NUM_PIXELS {4} \
    CONFIG.CMN_PXL_FORMAT {RAW12} \
    CONFIG.CMN_VC {All} \
    CONFIG.CSI_BUF_DEPTH {4096} \
    CONFIG.C_CSI_EN_ACTIVELANES {true} \
    CONFIG.C_CSI_FILTER_USERDATATYPE {true} \
    CONFIG.C_DPHY_LANES {4} \
    CONFIG.C_SPRT_ISP_BRIDGE {true} \
    CONFIG.DPY_EN_REG_IF {true} \
    CONFIG.DPY_LINE_RATE {1500} \
    CONFIG.SupportLevel {1} \
  ] $mipi_csi2_rx_subsyst_0


  # Create interface connections
  connect_bd_intf_net -intf_net mipi_csi2_rx_subsyst_0_video_out [get_bd_intf_pins mipi_csi2_rx_subsyst_0/video_out] [get_bd_intf_pins sensor_axis_video]
  connect_bd_intf_net -intf_net mipi_phy_if [get_bd_intf_pins mipi_phy_if] [get_bd_intf_pins mipi_csi2_rx_subsyst_0/mipi_phy_if]
  connect_bd_intf_net -intf_net s_axi_ctrl [get_bd_intf_pins s_axi_ctrl] [get_bd_intf_pins mipi_csi2_rx_subsyst_0/csirxss_s_axi]

  # Create port connections
  connect_bd_net -net csirxss_csi_irq  [get_bd_pins mipi_csi2_rx_subsyst_0/csirxss_csi_irq] \
  [get_bd_pins csirxss_csi_irq]
  connect_bd_net -net dphy_clk_200M  [get_bd_pins dphy_clk_200M] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/dphy_clk_200M]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_clkoutphy_out  [get_bd_pins mipi_csi2_rx_subsyst_0/clkoutphy_out] \
  [get_bd_pins clkoutphy_out]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_cnts_rxwordclkhs_out  [get_bd_pins mipi_csi2_rx_subsyst_0/cnts_rxwordclkhs_out] \
  [get_bd_pins cnts_rxwordclkhs_out]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_frame_rcvd_pulse_out  [get_bd_pins mipi_csi2_rx_subsyst_0/frame_rcvd_pulse_out] \
  [get_bd_pins frame_rcvd_pulse_out]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_header_data  [get_bd_pins mipi_csi2_rx_subsyst_0/header_data] \
  [get_bd_pins header_data]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_header_valid  [get_bd_pins mipi_csi2_rx_subsyst_0/header_valid] \
  [get_bd_pins header_valid]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_pll_clkoutphy_90_out  [get_bd_pins mipi_csi2_rx_subsyst_0/pll_clkoutphy_90_out] \
  [get_bd_pins pll_clkoutphy_90_out]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_pll_lock_out  [get_bd_pins mipi_csi2_rx_subsyst_0/pll_lock_out] \
  [get_bd_pins pll_lock_out]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_rxwordclkhs_out  [get_bd_pins mipi_csi2_rx_subsyst_0/rxwordclkhs_out] \
  [get_bd_pins rxwordclkhs_out]
  connect_bd_net -net s_axi_aclk_1  [get_bd_pins s_axi_aclk] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/lite_aclk]
  connect_bd_net -net s_axi_aresetn_1  [get_bd_pins s_axi_aresetn] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/lite_aresetn]
  connect_bd_net -net sensor_aclk_1  [get_bd_pins sensor_aclk] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/video_aclk]
  connect_bd_net -net sensor_aresetn_1  [get_bd_pins sensor_aresetn] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/video_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_mipi_0
proc create_hier_cell_hier_mipi_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_mipi_0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 mipi_phy_if

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_ctrl

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 sensor_axis_video


  # Create pins
  create_bd_pin -dir I -type clk dphy_clk_200M
  create_bd_pin -dir I -type clk sensor_aclk
  create_bd_pin -dir I -type rst sensor_aresetn
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir O header_valid
  create_bd_pin -dir O -from 31 -to 0 header_data
  create_bd_pin -dir O csirxss_csi_irq
  create_bd_pin -dir O rxwordclkhs_out
  create_bd_pin -dir O frame_rcvd_pulse_out
  create_bd_pin -dir O clkoutphy_out
  create_bd_pin -dir O pll_clkoutphy_90_out
  create_bd_pin -dir O cnts_rxwordclkhs_out
  create_bd_pin -dir O pll_lock_out

  # Create instance: mipi_csi2_rx_subsyst_0, and set properties
  set mipi_csi2_rx_subsyst_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mipi_csi2_rx_subsystem mipi_csi2_rx_subsyst_0 ]
  set_property -dict [list \
    CONFIG.CMN_NUM_LANES {4} \
    CONFIG.CMN_NUM_PIXELS {4} \
    CONFIG.CMN_PXL_FORMAT {RAW12} \
    CONFIG.CMN_VC {All} \
    CONFIG.CSI_BUF_DEPTH {4096} \
    CONFIG.C_CSI_EN_ACTIVELANES {true} \
    CONFIG.C_CSI_FILTER_USERDATATYPE {true} \
    CONFIG.C_DPHY_LANES {4} \
    CONFIG.C_SPRT_ISP_BRIDGE {true} \
    CONFIG.DPY_EN_REG_IF {true} \
    CONFIG.DPY_LINE_RATE {1500} \
    CONFIG.SupportLevel {1} \
  ] $mipi_csi2_rx_subsyst_0


  # Create interface connections
  connect_bd_intf_net -intf_net mipi_csi2_rx_subsyst_0_video_out [get_bd_intf_pins mipi_csi2_rx_subsyst_0/video_out] [get_bd_intf_pins sensor_axis_video]
  connect_bd_intf_net -intf_net mipi_phy_if [get_bd_intf_pins mipi_phy_if] [get_bd_intf_pins mipi_csi2_rx_subsyst_0/mipi_phy_if]
  connect_bd_intf_net -intf_net s_axi_ctrl [get_bd_intf_pins s_axi_ctrl] [get_bd_intf_pins mipi_csi2_rx_subsyst_0/csirxss_s_axi]

  # Create port connections
  connect_bd_net -net csirxss_csi_irq  [get_bd_pins mipi_csi2_rx_subsyst_0/csirxss_csi_irq] \
  [get_bd_pins csirxss_csi_irq]
  connect_bd_net -net dphy_clk_200M  [get_bd_pins dphy_clk_200M] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/dphy_clk_200M]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_clkoutphy_out  [get_bd_pins mipi_csi2_rx_subsyst_0/clkoutphy_out] \
  [get_bd_pins clkoutphy_out]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_cnts_rxwordclkhs_out  [get_bd_pins mipi_csi2_rx_subsyst_0/cnts_rxwordclkhs_out] \
  [get_bd_pins cnts_rxwordclkhs_out]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_frame_rcvd_pulse_out  [get_bd_pins mipi_csi2_rx_subsyst_0/frame_rcvd_pulse_out] \
  [get_bd_pins frame_rcvd_pulse_out]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_header_data  [get_bd_pins mipi_csi2_rx_subsyst_0/header_data] \
  [get_bd_pins header_data]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_header_valid  [get_bd_pins mipi_csi2_rx_subsyst_0/header_valid] \
  [get_bd_pins header_valid]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_pll_clkoutphy_90_out  [get_bd_pins mipi_csi2_rx_subsyst_0/pll_clkoutphy_90_out] \
  [get_bd_pins pll_clkoutphy_90_out]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_pll_lock_out  [get_bd_pins mipi_csi2_rx_subsyst_0/pll_lock_out] \
  [get_bd_pins pll_lock_out]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_rxwordclkhs_out  [get_bd_pins mipi_csi2_rx_subsyst_0/rxwordclkhs_out] \
  [get_bd_pins rxwordclkhs_out]
  connect_bd_net -net s_axi_aclk_1  [get_bd_pins s_axi_aclk] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/lite_aclk]
  connect_bd_net -net s_axi_aresetn_1  [get_bd_pins s_axi_aresetn] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/lite_aresetn]
  connect_bd_net -net sensor_aclk_1  [get_bd_pins sensor_aclk] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/video_aclk]
  connect_bd_net -net sensor_aresetn_1  [get_bd_pins sensor_aresetn] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/video_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_mipi_5
proc create_hier_cell_hier_mipi_5 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_mipi_5() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 mipi_phy_if

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_ctrl

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 sensor_axis_video


  # Create pins
  create_bd_pin -dir I -type clk dphy_clk_200M
  create_bd_pin -dir I -type clk sensor_aclk
  create_bd_pin -dir I -type rst sensor_aresetn
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir O header_valid
  create_bd_pin -dir O -from 31 -to 0 header_data
  create_bd_pin -dir O csirxss_csi_irq
  create_bd_pin -dir O rxwordclkhs_out
  create_bd_pin -dir O frame_rcvd_pulse_out
  create_bd_pin -dir I -type clk shared_pll_clkoutphy_in_0
  create_bd_pin -dir I -type clk cnts_rxwordclkhs_in_0
  create_bd_pin -dir I shared_pll_locked_in_0
  create_bd_pin -dir I shared_pll_clkoutphy_90_in_0

  # Create instance: mipi_csi2_rx_subsyst_0, and set properties
  set mipi_csi2_rx_subsyst_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mipi_csi2_rx_subsystem mipi_csi2_rx_subsyst_0 ]
  set_property -dict [list \
    CONFIG.CMN_NUM_LANES {4} \
    CONFIG.CMN_NUM_PIXELS {4} \
    CONFIG.CMN_PXL_FORMAT {RAW10} \
    CONFIG.CMN_VC {All} \
    CONFIG.CSI_BUF_DEPTH {4096} \
    CONFIG.C_CSI_EN_ACTIVELANES {true} \
    CONFIG.C_CSI_FILTER_USERDATATYPE {true} \
    CONFIG.C_DPHY_LANES {4} \
    CONFIG.C_SPRT_ISP_BRIDGE {true} \
    CONFIG.DPY_EN_REG_IF {true} \
    CONFIG.DPY_LINE_RATE {1500} \
    CONFIG.SupportLevel {0} \
  ] $mipi_csi2_rx_subsyst_0


  # Create interface connections
  connect_bd_intf_net -intf_net mipi_csi2_rx_subsyst_0_video_out [get_bd_intf_pins mipi_csi2_rx_subsyst_0/video_out] [get_bd_intf_pins sensor_axis_video]
  connect_bd_intf_net -intf_net mipi_phy_if [get_bd_intf_pins mipi_phy_if] [get_bd_intf_pins mipi_csi2_rx_subsyst_0/mipi_phy_if]
  connect_bd_intf_net -intf_net s_axi_ctrl [get_bd_intf_pins s_axi_ctrl] [get_bd_intf_pins mipi_csi2_rx_subsyst_0/csirxss_s_axi]

  # Create port connections
  connect_bd_net -net cnts_rxwordclkhs_in_0_1  [get_bd_pins cnts_rxwordclkhs_in_0] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/cnts_rxwordclkhs_in]
  connect_bd_net -net csirxss_csi_irq  [get_bd_pins mipi_csi2_rx_subsyst_0/csirxss_csi_irq] \
  [get_bd_pins csirxss_csi_irq]
  connect_bd_net -net dphy_clk_200M  [get_bd_pins dphy_clk_200M] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/dphy_clk_200M]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_frame_rcvd_pulse_out  [get_bd_pins mipi_csi2_rx_subsyst_0/frame_rcvd_pulse_out] \
  [get_bd_pins frame_rcvd_pulse_out]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_header_data  [get_bd_pins mipi_csi2_rx_subsyst_0/header_data] \
  [get_bd_pins header_data]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_header_valid  [get_bd_pins mipi_csi2_rx_subsyst_0/header_valid] \
  [get_bd_pins header_valid]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_rxwordclkhs_out  [get_bd_pins mipi_csi2_rx_subsyst_0/rxwordclkhs_out] \
  [get_bd_pins rxwordclkhs_out]
  connect_bd_net -net s_axi_aclk_1  [get_bd_pins s_axi_aclk] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/lite_aclk]
  connect_bd_net -net s_axi_aresetn_1  [get_bd_pins s_axi_aresetn] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/lite_aresetn]
  connect_bd_net -net sensor_aclk_1  [get_bd_pins sensor_aclk] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/video_aclk]
  connect_bd_net -net sensor_aresetn_1  [get_bd_pins sensor_aresetn] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/video_aresetn]
  connect_bd_net -net shared_pll_clkoutphy_90_in_0_1  [get_bd_pins shared_pll_clkoutphy_90_in_0] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/shared_pll_clkoutphy_90_in]
  connect_bd_net -net shared_pll_clkoutphy_in_0_1  [get_bd_pins shared_pll_clkoutphy_in_0] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/shared_pll_clkoutphy_in]
  connect_bd_net -net shared_pll_locked_in_0_1  [get_bd_pins shared_pll_locked_in_0] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/shared_pll_locked_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_mipi_4
proc create_hier_cell_hier_mipi_4 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_mipi_4() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 mipi_phy_if

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_ctrl

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 sensor_axis_video


  # Create pins
  create_bd_pin -dir I -type clk dphy_clk_200M
  create_bd_pin -dir I -type clk sensor_aclk
  create_bd_pin -dir I -type rst sensor_aresetn
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir O header_valid
  create_bd_pin -dir O -from 31 -to 0 header_data
  create_bd_pin -dir O csirxss_csi_irq
  create_bd_pin -dir O rxwordclkhs_out
  create_bd_pin -dir O frame_rcvd_pulse_out
  create_bd_pin -dir I -type clk shared_pll_clkoutphy_in_0
  create_bd_pin -dir I -type clk cnts_rxwordclkhs_in_0
  create_bd_pin -dir I shared_pll_locked_in_0
  create_bd_pin -dir I shared_pll_clkoutphy_90_in_0

  # Create instance: mipi_csi2_rx_subsyst_0, and set properties
  set mipi_csi2_rx_subsyst_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mipi_csi2_rx_subsystem mipi_csi2_rx_subsyst_0 ]
  set_property -dict [list \
    CONFIG.CMN_NUM_LANES {4} \
    CONFIG.CMN_NUM_PIXELS {4} \
    CONFIG.CMN_PXL_FORMAT {RAW12} \
    CONFIG.CMN_VC {All} \
    CONFIG.CSI_BUF_DEPTH {4096} \
    CONFIG.C_CSI_EN_ACTIVELANES {true} \
    CONFIG.C_CSI_FILTER_USERDATATYPE {true} \
    CONFIG.C_DPHY_LANES {4} \
    CONFIG.C_SPRT_ISP_BRIDGE {true} \
    CONFIG.DPY_EN_REG_IF {true} \
    CONFIG.DPY_LINE_RATE {1500} \
    CONFIG.SupportLevel {0} \
  ] $mipi_csi2_rx_subsyst_0


  # Create interface connections
  connect_bd_intf_net -intf_net mipi_csi2_rx_subsyst_0_video_out [get_bd_intf_pins mipi_csi2_rx_subsyst_0/video_out] [get_bd_intf_pins sensor_axis_video]
  connect_bd_intf_net -intf_net mipi_phy_if [get_bd_intf_pins mipi_phy_if] [get_bd_intf_pins mipi_csi2_rx_subsyst_0/mipi_phy_if]
  connect_bd_intf_net -intf_net s_axi_ctrl [get_bd_intf_pins s_axi_ctrl] [get_bd_intf_pins mipi_csi2_rx_subsyst_0/csirxss_s_axi]

  # Create port connections
  connect_bd_net -net cnts_rxwordclkhs_in_0_1  [get_bd_pins cnts_rxwordclkhs_in_0] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/cnts_rxwordclkhs_in]
  connect_bd_net -net csirxss_csi_irq  [get_bd_pins mipi_csi2_rx_subsyst_0/csirxss_csi_irq] \
  [get_bd_pins csirxss_csi_irq]
  connect_bd_net -net dphy_clk_200M  [get_bd_pins dphy_clk_200M] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/dphy_clk_200M]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_frame_rcvd_pulse_out  [get_bd_pins mipi_csi2_rx_subsyst_0/frame_rcvd_pulse_out] \
  [get_bd_pins frame_rcvd_pulse_out]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_header_data  [get_bd_pins mipi_csi2_rx_subsyst_0/header_data] \
  [get_bd_pins header_data]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_header_valid  [get_bd_pins mipi_csi2_rx_subsyst_0/header_valid] \
  [get_bd_pins header_valid]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_rxwordclkhs_out  [get_bd_pins mipi_csi2_rx_subsyst_0/rxwordclkhs_out] \
  [get_bd_pins rxwordclkhs_out]
  connect_bd_net -net s_axi_aclk_1  [get_bd_pins s_axi_aclk] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/lite_aclk]
  connect_bd_net -net s_axi_aresetn_1  [get_bd_pins s_axi_aresetn] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/lite_aresetn]
  connect_bd_net -net sensor_aclk_1  [get_bd_pins sensor_aclk] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/video_aclk]
  connect_bd_net -net sensor_aresetn_1  [get_bd_pins sensor_aresetn] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/video_aresetn]
  connect_bd_net -net shared_pll_clkoutphy_90_in_0_1  [get_bd_pins shared_pll_clkoutphy_90_in_0] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/shared_pll_clkoutphy_90_in]
  connect_bd_net -net shared_pll_clkoutphy_in_0_1  [get_bd_pins shared_pll_clkoutphy_in_0] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/shared_pll_clkoutphy_in]
  connect_bd_net -net shared_pll_locked_in_0_1  [get_bd_pins shared_pll_locked_in_0] \
  [get_bd_pins mipi_csi2_rx_subsyst_0/shared_pll_locked_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mipi_rx_ss_hier
proc create_hier_cell_mipi_rx_ss_hier { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_mipi_rx_ss_hier() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:inimm_rtl:1.0 S00_INI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:inimm_rtl:1.0 S01_INI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:inimm_rtl:1.0 S02_INI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 M00_INI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 M01_INI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 M02_INI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 M03_INI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 M04_INI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 M05_INI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 M06_INI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 M07_INI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 M08_INI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 M09_INI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 M10_INI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 M11_INI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 MIPI5

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 MIPI6

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 MIPI1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 MIPI2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 MIPI3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 MIPI4

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 FMC_IIC_4

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 FMC_IIC_6

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 FMC_IIC_7

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI1


  # Create pins
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir O -type intr tile0_isp0_fusa_irq
  create_bd_pin -dir O -type intr tile0_isp0_isp_irq
  create_bd_pin -dir O -type intr tile0_isp1_fusa_irq
  create_bd_pin -dir O -type intr tile0_isp1_isp_irq
  create_bd_pin -dir O -type intr tile0_isp_isr_irq
  create_bd_pin -dir O -type intr tile0_isp_xmpu_interrupt
  create_bd_pin -dir O -type intr tile1_isp0_fusa_irq
  create_bd_pin -dir O -type intr tile1_isp0_isp_irq
  create_bd_pin -dir O -type intr tile1_isp1_fusa_irq
  create_bd_pin -dir O -type intr tile1_isp1_isp_irq
  create_bd_pin -dir O -type intr tile1_isp_isr_irq
  create_bd_pin -dir O -type intr tile1_isp_xmpu_interrupt
  create_bd_pin -dir O -type intr tile2_isp0_fusa_irq
  create_bd_pin -dir O -type intr tile2_isp0_isp_irq
  create_bd_pin -dir O -type intr tile2_isp1_fusa_irq
  create_bd_pin -dir O -type intr tile2_isp1_isp_irq
  create_bd_pin -dir O -type intr tile2_isp_isr_irq
  create_bd_pin -dir O -type intr tile2_isp_xmpu_interrupt
  create_bd_pin -dir I -type clk dphy_clk_200M
  create_bd_pin -dir O csirxss_csi_irq
  create_bd_pin -dir O csirxss_csi_irq1
  create_bd_pin -dir O csirxss_csi_irq2
  create_bd_pin -dir O csirxss_csi_irq3
  create_bd_pin -dir O csirxss_csi_irq4
  create_bd_pin -dir O csirxss_csi_irq5
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir O -type intr iic2intc_irpt
  create_bd_pin -dir O -type intr iic2intc_irpt1
  create_bd_pin -dir O -type intr iic2intc_irpt2

  # Create instance: Smart_connect_mipi, and set properties
  set Smart_connect_mipi [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect Smart_connect_mipi ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {1} \
    CONFIG.NUM_MI {7} \
    CONFIG.NUM_SI {1} \
  ] $Smart_connect_mipi


  # Create instance: axis_broadcaster_0, and set properties
  set axis_broadcaster_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster axis_broadcaster_0 ]
  set_property -dict [list \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_TLAST {1} \
    CONFIG.HAS_TREADY {1} \
    CONFIG.HAS_TSTRB {0} \
    CONFIG.M_TDATA_NUM_BYTES {6} \
    CONFIG.M_TUSER_WIDTH {112} \
    CONFIG.S_TDATA_NUM_BYTES {6} \
    CONFIG.S_TUSER_WIDTH {112} \
    CONFIG.TDEST_WIDTH {11} \
    CONFIG.TID_WIDTH {0} \
  ] $axis_broadcaster_0

  set_property -dict [list \
    CONFIG.HAS_TKEEP.VALUE_MODE {auto} \
    CONFIG.HAS_TLAST.VALUE_MODE {auto} \
    CONFIG.HAS_TREADY.VALUE_MODE {auto} \
    CONFIG.HAS_TSTRB.VALUE_MODE {auto} \
    CONFIG.M_TDATA_NUM_BYTES.VALUE_MODE {auto} \
    CONFIG.M_TUSER_WIDTH.VALUE_MODE {auto} \
    CONFIG.S_TDATA_NUM_BYTES.VALUE_MODE {auto} \
    CONFIG.S_TUSER_WIDTH.VALUE_MODE {auto} \
    CONFIG.TDEST_WIDTH.VALUE_MODE {auto} \
    CONFIG.TID_WIDTH.VALUE_MODE {auto} \
  ] $axis_broadcaster_0


  # Create instance: axis_broadcaster_1, and set properties
  set axis_broadcaster_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster axis_broadcaster_1 ]
  set_property -dict [list \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_TLAST {1} \
    CONFIG.HAS_TREADY {1} \
    CONFIG.HAS_TSTRB {0} \
    CONFIG.M_TDATA_NUM_BYTES {6} \
    CONFIG.M_TUSER_WIDTH {112} \
    CONFIG.S_TDATA_NUM_BYTES {6} \
    CONFIG.S_TUSER_WIDTH {112} \
    CONFIG.TDEST_WIDTH {11} \
    CONFIG.TID_WIDTH {0} \
  ] $axis_broadcaster_1

  set_property -dict [list \
    CONFIG.HAS_TKEEP.VALUE_MODE {auto} \
    CONFIG.HAS_TLAST.VALUE_MODE {auto} \
    CONFIG.HAS_TREADY.VALUE_MODE {auto} \
    CONFIG.HAS_TSTRB.VALUE_MODE {auto} \
    CONFIG.M_TDATA_NUM_BYTES.VALUE_MODE {auto} \
    CONFIG.M_TUSER_WIDTH.VALUE_MODE {auto} \
    CONFIG.S_TDATA_NUM_BYTES.VALUE_MODE {auto} \
    CONFIG.S_TUSER_WIDTH.VALUE_MODE {auto} \
    CONFIG.TDEST_WIDTH.VALUE_MODE {auto} \
    CONFIG.TID_WIDTH.VALUE_MODE {auto} \
  ] $axis_broadcaster_1


  # Create instance: axis_broadcaster_2, and set properties
  set axis_broadcaster_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster axis_broadcaster_2 ]
  set_property -dict [list \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_TLAST {1} \
    CONFIG.HAS_TREADY {1} \
    CONFIG.HAS_TSTRB {0} \
    CONFIG.M_TDATA_NUM_BYTES {6} \
    CONFIG.M_TUSER_WIDTH {112} \
    CONFIG.S_TDATA_NUM_BYTES {6} \
    CONFIG.S_TUSER_WIDTH {112} \
    CONFIG.TDEST_WIDTH {11} \
    CONFIG.TID_WIDTH {0} \
  ] $axis_broadcaster_2

  set_property -dict [list \
    CONFIG.HAS_TKEEP.VALUE_MODE {auto} \
    CONFIG.HAS_TLAST.VALUE_MODE {auto} \
    CONFIG.HAS_TREADY.VALUE_MODE {auto} \
    CONFIG.HAS_TSTRB.VALUE_MODE {auto} \
    CONFIG.M_TDATA_NUM_BYTES.VALUE_MODE {auto} \
    CONFIG.M_TUSER_WIDTH.VALUE_MODE {auto} \
    CONFIG.S_TDATA_NUM_BYTES.VALUE_MODE {auto} \
    CONFIG.S_TUSER_WIDTH.VALUE_MODE {auto} \
    CONFIG.TDEST_WIDTH.VALUE_MODE {auto} \
    CONFIG.TID_WIDTH.VALUE_MODE {auto} \
  ] $axis_broadcaster_2


  # Create instance: axis_broadcaster_3, and set properties
  set axis_broadcaster_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster axis_broadcaster_3 ]
  set_property -dict [list \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_TLAST {1} \
    CONFIG.HAS_TREADY {1} \
    CONFIG.HAS_TSTRB {0} \
    CONFIG.M_TDATA_NUM_BYTES {6} \
    CONFIG.M_TUSER_WIDTH {112} \
    CONFIG.S_TDATA_NUM_BYTES {6} \
    CONFIG.S_TUSER_WIDTH {112} \
    CONFIG.TDEST_WIDTH {11} \
    CONFIG.TID_WIDTH {0} \
  ] $axis_broadcaster_3

  set_property -dict [list \
    CONFIG.HAS_TKEEP.VALUE_MODE {auto} \
    CONFIG.HAS_TLAST.VALUE_MODE {auto} \
    CONFIG.HAS_TREADY.VALUE_MODE {auto} \
    CONFIG.HAS_TSTRB.VALUE_MODE {auto} \
    CONFIG.M_TDATA_NUM_BYTES.VALUE_MODE {auto} \
    CONFIG.M_TUSER_WIDTH.VALUE_MODE {auto} \
    CONFIG.S_TDATA_NUM_BYTES.VALUE_MODE {auto} \
    CONFIG.S_TUSER_WIDTH.VALUE_MODE {auto} \
    CONFIG.TDEST_WIDTH.VALUE_MODE {auto} \
    CONFIG.TID_WIDTH.VALUE_MODE {auto} \
  ] $axis_broadcaster_3


  # Create instance: ilvector_logic_0, and set properties
  set ilvector_logic_0 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilvector_logic ilvector_logic_0 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {or} \
    CONFIG.C_SIZE {1} \
  ] $ilvector_logic_0


  # Create instance: ilconcat_0, and set properties
  set ilconcat_0 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconcat ilconcat_0 ]

  # Create instance: axis_broadcaster_4, and set properties
  set axis_broadcaster_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster axis_broadcaster_4 ]
  set_property -dict [list \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_TLAST {1} \
    CONFIG.HAS_TREADY {1} \
    CONFIG.HAS_TSTRB {0} \
    CONFIG.M_TDATA_NUM_BYTES {6} \
    CONFIG.M_TUSER_WIDTH {112} \
    CONFIG.S_TDATA_NUM_BYTES {6} \
    CONFIG.S_TUSER_WIDTH {112} \
    CONFIG.TDEST_WIDTH {11} \
    CONFIG.TID_WIDTH {0} \
  ] $axis_broadcaster_4

  set_property -dict [list \
    CONFIG.HAS_TKEEP.VALUE_MODE {auto} \
    CONFIG.HAS_TLAST.VALUE_MODE {auto} \
    CONFIG.HAS_TREADY.VALUE_MODE {auto} \
    CONFIG.HAS_TSTRB.VALUE_MODE {auto} \
    CONFIG.M_TDATA_NUM_BYTES.VALUE_MODE {auto} \
    CONFIG.M_TUSER_WIDTH.VALUE_MODE {auto} \
    CONFIG.S_TDATA_NUM_BYTES.VALUE_MODE {auto} \
    CONFIG.S_TUSER_WIDTH.VALUE_MODE {auto} \
    CONFIG.TDEST_WIDTH.VALUE_MODE {auto} \
    CONFIG.TID_WIDTH.VALUE_MODE {auto} \
  ] $axis_broadcaster_4


  # Create instance: ilvector_logic_1, and set properties
  set ilvector_logic_1 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilvector_logic ilvector_logic_1 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {or} \
    CONFIG.C_SIZE {1} \
  ] $ilvector_logic_1


  # Create instance: ilconcat_1, and set properties
  set ilconcat_1 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconcat ilconcat_1 ]

  # Create instance: ilvector_logic_2, and set properties
  set ilvector_logic_2 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilvector_logic ilvector_logic_2 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {or} \
    CONFIG.C_SIZE {1} \
  ] $ilvector_logic_2


  # Create instance: axis_broadcaster_5, and set properties
  set axis_broadcaster_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster axis_broadcaster_5 ]
  set_property -dict [list \
    CONFIG.HAS_TKEEP {1} \
    CONFIG.HAS_TLAST {1} \
    CONFIG.HAS_TREADY {1} \
    CONFIG.HAS_TSTRB {0} \
    CONFIG.M_TDATA_NUM_BYTES {5} \
    CONFIG.M_TUSER_WIDTH {112} \
    CONFIG.NUM_MI {4} \
    CONFIG.S_TDATA_NUM_BYTES {5} \
    CONFIG.S_TUSER_WIDTH {112} \
    CONFIG.TDEST_WIDTH {11} \
    CONFIG.TID_WIDTH {0} \
  ] $axis_broadcaster_5

  set_property -dict [list \
    CONFIG.HAS_TKEEP.VALUE_MODE {auto} \
    CONFIG.HAS_TLAST.VALUE_MODE {auto} \
    CONFIG.HAS_TREADY.VALUE_MODE {auto} \
    CONFIG.HAS_TSTRB.VALUE_MODE {auto} \
    CONFIG.M_TUSER_WIDTH.VALUE_MODE {auto} \
    CONFIG.S_TUSER_WIDTH.VALUE_MODE {auto} \
    CONFIG.TDEST_WIDTH.VALUE_MODE {auto} \
    CONFIG.TID_WIDTH.VALUE_MODE {auto} \
  ] $axis_broadcaster_5


  # Create instance: ilvector_logic_3, and set properties
  set ilvector_logic_3 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilvector_logic ilvector_logic_3 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {or} \
    CONFIG.C_SIZE {1} \
  ] $ilvector_logic_3


  # Create instance: ilconcat_2, and set properties
  set ilconcat_2 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconcat ilconcat_2 ]

  # Create instance: ilconcat_3, and set properties
  set ilconcat_3 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconcat ilconcat_3 ]

  # Create instance: ilvector_logic_4, and set properties
  set ilvector_logic_4 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilvector_logic ilvector_logic_4 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {or} \
    CONFIG.C_SIZE {1} \
  ] $ilvector_logic_4


  # Create instance: ilvector_logic_5, and set properties
  set ilvector_logic_5 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilvector_logic ilvector_logic_5 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {or} \
    CONFIG.C_SIZE {1} \
  ] $ilvector_logic_5


  # Create instance: ilconcat_4, and set properties
  set ilconcat_4 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconcat ilconcat_4 ]

  # Create instance: visp_ss_0, and set properties
  set visp_ss_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:visp_ss visp_ss_0 ]
  set_property -dict [list \
    CONFIG.C_ENABLE_OVERDRIVE {1} \
    CONFIG.C_LLPATH0_TILE {3} \
    CONFIG.C_LLPATH1_TILE {3} \
    CONFIG.C_TILE0_COMMON_IBA3_DATA_FORMAT {12} \
    CONFIG.C_TILE0_COMMON_IBA3_FPS {30} \
    CONFIG.C_TILE0_COMMON_IBA3_RES_HOR {3840} \
    CONFIG.C_TILE0_COMMON_IBA3_RES_VER {2160} \
    CONFIG.C_TILE0_COMMON_IBA3_VCID {1} \
    CONFIG.C_TILE0_CONFIG {1} \
    CONFIG.C_TILE0_DPLL_CLKFBOUT_FRACT {1} \
    CONFIG.C_TILE0_DPLL_CLKFBOUT_MULT {54} \
    CONFIG.C_TILE0_DPLL_DIVCLK_DIVIDE {2} \
    CONFIG.C_TILE0_ISP0_BASIC_DATA_FORMAT {12} \
    CONFIG.C_TILE0_ISP0_CORE_CLK {600.1} \
    CONFIG.C_TILE0_ISP0_ENABLE_MP {false} \
    CONFIG.C_TILE0_ISP0_ENABLE_SP {false} \
    CONFIG.C_TILE0_ISP0_GPIO_PS_CHECK {true} \
    CONFIG.C_TILE0_ISP0_GPIO_SELECT {0} \
    CONFIG.C_TILE0_ISP0_IBA0_DATA_FORMAT {12} \
    CONFIG.C_TILE0_ISP0_IBA0_FPS {30} \
    CONFIG.C_TILE0_ISP0_IBA0_RES_HOR {1920} \
    CONFIG.C_TILE0_ISP0_IBA0_RES_VER {1080} \
    CONFIG.C_TILE0_ISP0_IBA0_VCID {0} \
    CONFIG.C_TILE0_ISP0_IBA1_DATA_FORMAT {12} \
    CONFIG.C_TILE0_ISP0_IBA1_FPS {30} \
    CONFIG.C_TILE0_ISP0_IBA1_RES_HOR {1920} \
    CONFIG.C_TILE0_ISP0_IBA1_RES_VER {1080} \
    CONFIG.C_TILE0_ISP0_IBA1_VCID {1} \
    CONFIG.C_TILE0_ISP0_IBA2_DATA_FORMAT {12} \
    CONFIG.C_TILE0_ISP0_IBA2_FPS {30} \
    CONFIG.C_TILE0_ISP0_IBA2_RES_HOR {1920} \
    CONFIG.C_TILE0_ISP0_IBA2_RES_VER {1080} \
    CONFIG.C_TILE0_ISP0_IBA2_VCID {0} \
    CONFIG.C_TILE0_ISP0_IBA3_DATA_FORMAT {12} \
    CONFIG.C_TILE0_ISP0_IBA3_FPS {30} \
    CONFIG.C_TILE0_ISP0_IBA3_RES_HOR {3840} \
    CONFIG.C_TILE0_ISP0_IBA3_RES_VER {2160} \
    CONFIG.C_TILE0_ISP0_IBA3_VCID {1} \
    CONFIG.C_TILE0_ISP0_IIC_PS_CHECK {true} \
    CONFIG.C_TILE0_ISP0_IIC_SELECT {0} \
    CONFIG.C_TILE0_ISP0_IO_TYPE {2} \
    CONFIG.C_TILE0_ISP0_LIVE_INPUTS {4} \
    CONFIG.C_TILE0_ISP0_NETFPS {120} \
    CONFIG.C_TILE0_ISP0_OBA0_MP_BPP {10} \
    CONFIG.C_TILE0_ISP0_OBA0_MP_RGB888 {true} \
    CONFIG.C_TILE0_ISP0_OBA0_MP_Y {true} \
    CONFIG.C_TILE0_ISP0_OBA0_MP_YUV420 {false} \
    CONFIG.C_TILE0_ISP0_OBA0_MP_YUV422 {true} \
    CONFIG.C_TILE0_ISP0_OBA0_PPC {4} \
    CONFIG.C_TILE0_ISP0_RPU {6} \
    CONFIG.C_TILE0_ISP1_BASIC_DATA_FORMAT {12} \
    CONFIG.C_TILE0_ISP1_CORE_CLK {600.1} \
    CONFIG.C_TILE0_ISP1_ENABLE_MP {false} \
    CONFIG.C_TILE0_ISP1_ENABLE_SP {false} \
    CONFIG.C_TILE0_ISP1_GPIO_PS_CHECK {true} \
    CONFIG.C_TILE0_ISP1_GPIO_SELECT {1} \
    CONFIG.C_TILE0_ISP1_IBA4_DATA_FORMAT {12} \
    CONFIG.C_TILE0_ISP1_IBA4_FPS {30} \
    CONFIG.C_TILE0_ISP1_IBA4_RES_HOR {3840} \
    CONFIG.C_TILE0_ISP1_IBA4_RES_VER {2160} \
    CONFIG.C_TILE0_ISP1_IBA4_VCID {0} \
    CONFIG.C_TILE0_ISP1_IIC_PS_CHECK {true} \
    CONFIG.C_TILE0_ISP1_IIC_SELECT {1} \
    CONFIG.C_TILE0_ISP1_IO_TYPE {2} \
    CONFIG.C_TILE0_ISP1_LIVE_INPUTS {1} \
    CONFIG.C_TILE0_ISP1_NETFPS {30} \
    CONFIG.C_TILE0_ISP1_OBA1_MP_BPP {10} \
    CONFIG.C_TILE0_ISP1_OBA1_MP_RGB888 {true} \
    CONFIG.C_TILE0_ISP1_OBA1_MP_Y {true} \
    CONFIG.C_TILE0_ISP1_OBA1_MP_YUV420 {false} \
    CONFIG.C_TILE0_ISP1_OBA1_MP_YUV422 {true} \
    CONFIG.C_TILE0_ISP1_OBA1_PPC {4} \
    CONFIG.C_TILE0_ISP1_RPU {6} \
    CONFIG.C_TILE0_VIDIN0_TDATA_WIDTH {48} \
    CONFIG.C_TILE0_VIDIN1_TDATA_WIDTH {48} \
    CONFIG.C_TILE0_VIDIN2_TDATA_WIDTH {48} \
    CONFIG.C_TILE0_VIDIN3_TDATA_WIDTH {48} \
    CONFIG.C_TILE0_VIDIN4_TDATA_WIDTH {48} \
    CONFIG.C_TILE1_COMMON_IBA3_FPS {30} \
    CONFIG.C_TILE1_COMMON_IBA3_RES_HOR {1920} \
    CONFIG.C_TILE1_COMMON_IBA3_RES_VER {1080} \
    CONFIG.C_TILE1_COMMON_IBA3_VCID {1} \
    CONFIG.C_TILE1_CONFIG {1} \
    CONFIG.C_TILE1_DPLL_CLKFBOUT_FRACT {1} \
    CONFIG.C_TILE1_DPLL_CLKFBOUT_MULT {54} \
    CONFIG.C_TILE1_DPLL_CLKOUT2_DIVIDE {6} \
    CONFIG.C_TILE1_DPLL_CLKOUT3_DIVIDE {6} \
    CONFIG.C_TILE1_DPLL_DIVCLK_DIVIDE {2} \
    CONFIG.C_TILE1_ENABLE {true} \
    CONFIG.C_TILE1_ISP0_BASIC_DATA_FORMAT {12} \
    CONFIG.C_TILE1_ISP0_CORE_CLK {600.1} \
    CONFIG.C_TILE1_ISP0_ENABLE_MP {false} \
    CONFIG.C_TILE1_ISP0_ENABLE_SP {false} \
    CONFIG.C_TILE1_ISP0_GPIO_PS_CHECK {true} \
    CONFIG.C_TILE1_ISP0_GPIO_SELECT {0} \
    CONFIG.C_TILE1_ISP0_IBA0_DATA_FORMAT {12} \
    CONFIG.C_TILE1_ISP0_IBA0_FPS {30} \
    CONFIG.C_TILE1_ISP0_IBA0_RES_HOR {1920} \
    CONFIG.C_TILE1_ISP0_IBA0_RES_VER {1080} \
    CONFIG.C_TILE1_ISP0_IBA0_VCID {0} \
    CONFIG.C_TILE1_ISP0_IBA1_DATA_FORMAT {12} \
    CONFIG.C_TILE1_ISP0_IBA1_FPS {30} \
    CONFIG.C_TILE1_ISP0_IBA1_RES_HOR {1920} \
    CONFIG.C_TILE1_ISP0_IBA1_RES_VER {1080} \
    CONFIG.C_TILE1_ISP0_IBA1_VCID {1} \
    CONFIG.C_TILE1_ISP0_IBA2_DATA_FORMAT {12} \
    CONFIG.C_TILE1_ISP0_IBA2_FPS {30} \
    CONFIG.C_TILE1_ISP0_IBA2_RES_HOR {1920} \
    CONFIG.C_TILE1_ISP0_IBA2_RES_VER {1080} \
    CONFIG.C_TILE1_ISP0_IBA2_VCID {0} \
    CONFIG.C_TILE1_ISP0_IBA3_DATA_FORMAT {12} \
    CONFIG.C_TILE1_ISP0_IBA3_FPS {30} \
    CONFIG.C_TILE1_ISP0_IBA3_RES_HOR {1920} \
    CONFIG.C_TILE1_ISP0_IBA3_RES_VER {1080} \
    CONFIG.C_TILE1_ISP0_IBA3_VCID {1} \
    CONFIG.C_TILE1_ISP0_IIC_PS_CHECK {true} \
    CONFIG.C_TILE1_ISP0_IIC_SELECT {0} \
    CONFIG.C_TILE1_ISP0_IO_TYPE {2} \
    CONFIG.C_TILE1_ISP0_LIVE_INPUTS {4} \
    CONFIG.C_TILE1_ISP0_NETFPS {120} \
    CONFIG.C_TILE1_ISP0_OBA0_MP_BPP {10} \
    CONFIG.C_TILE1_ISP0_OBA0_MP_RGB888 {true} \
    CONFIG.C_TILE1_ISP0_OBA0_MP_Y {true} \
    CONFIG.C_TILE1_ISP0_OBA0_MP_YUV420 {false} \
    CONFIG.C_TILE1_ISP0_OBA0_MP_YUV422 {true} \
    CONFIG.C_TILE1_ISP0_OBA0_PPC {4} \
    CONFIG.C_TILE1_ISP0_RPU {7} \
    CONFIG.C_TILE1_ISP1_BASIC_DATA_FORMAT {12} \
    CONFIG.C_TILE1_ISP1_CORE_CLK {600.1} \
    CONFIG.C_TILE1_ISP1_ENABLE_MP {false} \
    CONFIG.C_TILE1_ISP1_ENABLE_SP {false} \
    CONFIG.C_TILE1_ISP1_GPIO_PS_CHECK {true} \
    CONFIG.C_TILE1_ISP1_GPIO_SELECT {1} \
    CONFIG.C_TILE1_ISP1_IBA4_DATA_FORMAT {12} \
    CONFIG.C_TILE1_ISP1_IBA4_FPS {30} \
    CONFIG.C_TILE1_ISP1_IBA4_RES_HOR {3840} \
    CONFIG.C_TILE1_ISP1_IBA4_RES_VER {2160} \
    CONFIG.C_TILE1_ISP1_IBA4_VCID {0} \
    CONFIG.C_TILE1_ISP1_IIC_PS_CHECK {true} \
    CONFIG.C_TILE1_ISP1_IIC_SELECT {1} \
    CONFIG.C_TILE1_ISP1_IO_TYPE {2} \
    CONFIG.C_TILE1_ISP1_LIVE_INPUTS {1} \
    CONFIG.C_TILE1_ISP1_NETFPS {30} \
    CONFIG.C_TILE1_ISP1_OBA1_MP_BPP {10} \
    CONFIG.C_TILE1_ISP1_OBA1_MP_RGB888 {true} \
    CONFIG.C_TILE1_ISP1_OBA1_MP_Y {true} \
    CONFIG.C_TILE1_ISP1_OBA1_MP_YUV420 {false} \
    CONFIG.C_TILE1_ISP1_OBA1_MP_YUV422 {true} \
    CONFIG.C_TILE1_ISP1_OBA1_PPC {4} \
    CONFIG.C_TILE1_ISP1_RPU {7} \
    CONFIG.C_TILE1_VIDIN0_TDATA_WIDTH {48} \
    CONFIG.C_TILE1_VIDIN1_TDATA_WIDTH {48} \
    CONFIG.C_TILE1_VIDIN2_TDATA_WIDTH {48} \
    CONFIG.C_TILE1_VIDIN3_TDATA_WIDTH {48} \
    CONFIG.C_TILE1_VIDIN4_TDATA_WIDTH {48} \
    CONFIG.C_TILE2_COMMON_IBA3_FPS {30} \
    CONFIG.C_TILE2_COMMON_IBA3_VCID {0} \
    CONFIG.C_TILE2_CONFIG {1} \
    CONFIG.C_TILE2_DPLL_CLKFBOUT_FRACT {1} \
    CONFIG.C_TILE2_DPLL_CLKFBOUT_MULT {54} \
    CONFIG.C_TILE2_DPLL_CLKOUT2_DIVIDE {6} \
    CONFIG.C_TILE2_DPLL_CLKOUT3_DIVIDE {6} \
    CONFIG.C_TILE2_DPLL_DIVCLK_DIVIDE {2} \
    CONFIG.C_TILE2_ENABLE {true} \
    CONFIG.C_TILE2_ISP0_BASIC_DATA_FORMAT {12} \
    CONFIG.C_TILE2_ISP0_CORE_CLK {600.1} \
    CONFIG.C_TILE2_ISP0_GPIO_PS_CHECK {true} \
    CONFIG.C_TILE2_ISP0_GPIO_SELECT {0} \
    CONFIG.C_TILE2_ISP0_IBA0_DATA_FORMAT {10} \
    CONFIG.C_TILE2_ISP0_IBA0_FPS {30} \
    CONFIG.C_TILE2_ISP0_IBA1_DATA_FORMAT {10} \
    CONFIG.C_TILE2_ISP0_IBA1_VCID {1} \
    CONFIG.C_TILE2_ISP0_IIC_PS_CHECK {true} \
    CONFIG.C_TILE2_ISP0_IIC_SELECT {0} \
    CONFIG.C_TILE2_ISP0_IO_TYPE {2} \
    CONFIG.C_TILE2_ISP0_LIVE_INPUTS {2} \
    CONFIG.C_TILE2_ISP0_NETFPS {60} \
    CONFIG.C_TILE2_ISP0_RPU {8} \
    CONFIG.C_TILE2_ISP1_BASIC_DATA_FORMAT {12} \
    CONFIG.C_TILE2_ISP1_CORE_CLK {600.1} \
    CONFIG.C_TILE2_ISP1_GPIO_PS_CHECK {true} \
    CONFIG.C_TILE2_ISP1_GPIO_SELECT {1} \
    CONFIG.C_TILE2_ISP1_IBA3_DATA_FORMAT {10} \
    CONFIG.C_TILE2_ISP1_IBA3_FPS {30} \
    CONFIG.C_TILE2_ISP1_IBA3_VCID {0} \
    CONFIG.C_TILE2_ISP1_IBA4_DATA_FORMAT {10} \
    CONFIG.C_TILE2_ISP1_IBA4_FPS {30} \
    CONFIG.C_TILE2_ISP1_IBA4_VCID {1} \
    CONFIG.C_TILE2_ISP1_IIC_PS_CHECK {true} \
    CONFIG.C_TILE2_ISP1_IIC_SELECT {1} \
    CONFIG.C_TILE2_ISP1_IO_TYPE {2} \
    CONFIG.C_TILE2_ISP1_LIVE_INPUTS {2} \
    CONFIG.C_TILE2_ISP1_NETFPS {60} \
    CONFIG.C_TILE2_ISP1_RPU {8} \
    CONFIG.C_TILE2_VIDIN0_TDATA_WIDTH {40} \
    CONFIG.C_TILE2_VIDIN1_TDATA_WIDTH {40} \
    CONFIG.C_TILE2_VIDIN3_TDATA_WIDTH {40} \
    CONFIG.C_TILE2_VIDIN4_TDATA_WIDTH {40} \
  ] $visp_ss_0


  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.ADDR_WIDTH {12} \
 ] [get_bd_intf_pins $visp_ss_0/S_AXI_LITE]

  set_property -dict [ list \
   CONFIG.CATEGORY {noc} \
   CONFIG.MY_CATEGORY {isp} \
   CONFIG.PHYSICAL_CHANNEL {ISP_TO_NOC_NMU} \
   CONFIG.TILE_INDEX {0} \
   CONFIG.INDEX {0} \
 ] [get_bd_intf_pins $visp_ss_0/TILE0_ISP0_NMU]

  set_property -dict [ list \
   CONFIG.CATEGORY {noc} \
   CONFIG.MY_CATEGORY {isp} \
   CONFIG.PHYSICAL_CHANNEL {ISP_TO_NOC_NMU} \
   CONFIG.TILE_INDEX {0} \
   CONFIG.INDEX {1} \
 ] [get_bd_intf_pins $visp_ss_0/TILE0_ISP1_NMU]

  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.CATEGORY {noc} \
   CONFIG.MY_CATEGORY {isp} \
   CONFIG.PHYSICAL_CHANNEL {NOC_NSU_TO_ISP} \
   CONFIG.TILE_INDEX {0} \
   CONFIG.INDEX {0} \
 ] [get_bd_intf_pins $visp_ss_0/TILE0_ISP_NSU]

  set_property -dict [ list \
   CONFIG.CATEGORY {noc} \
   CONFIG.MY_CATEGORY {isp} \
   CONFIG.PHYSICAL_CHANNEL {ISP_TO_NOC_NMU} \
   CONFIG.TILE_INDEX {1} \
   CONFIG.INDEX {0} \
 ] [get_bd_intf_pins $visp_ss_0/TILE1_ISP0_NMU]

  set_property -dict [ list \
   CONFIG.CATEGORY {noc} \
   CONFIG.MY_CATEGORY {isp} \
   CONFIG.PHYSICAL_CHANNEL {ISP_TO_NOC_NMU} \
   CONFIG.TILE_INDEX {1} \
   CONFIG.INDEX {1} \
 ] [get_bd_intf_pins $visp_ss_0/TILE1_ISP1_NMU]

  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.CATEGORY {noc} \
   CONFIG.MY_CATEGORY {isp} \
   CONFIG.PHYSICAL_CHANNEL {NOC_NSU_TO_ISP} \
   CONFIG.TILE_INDEX {1} \
   CONFIG.INDEX {0} \
 ] [get_bd_intf_pins $visp_ss_0/TILE1_ISP_NSU]

  set_property -dict [ list \
   CONFIG.CATEGORY {noc} \
   CONFIG.MY_CATEGORY {isp} \
   CONFIG.PHYSICAL_CHANNEL {ISP_TO_NOC_NMU} \
   CONFIG.TILE_INDEX {2} \
   CONFIG.INDEX {0} \
 ] [get_bd_intf_pins $visp_ss_0/TILE2_ISP0_NMU]

  set_property -dict [ list \
   CONFIG.CATEGORY {noc} \
   CONFIG.MY_CATEGORY {isp} \
   CONFIG.PHYSICAL_CHANNEL {ISP_TO_NOC_NMU} \
   CONFIG.TILE_INDEX {2} \
   CONFIG.INDEX {1} \
 ] [get_bd_intf_pins $visp_ss_0/TILE2_ISP1_NMU]

  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.CATEGORY {noc} \
   CONFIG.MY_CATEGORY {isp} \
   CONFIG.PHYSICAL_CHANNEL {NOC_NSU_TO_ISP} \
   CONFIG.TILE_INDEX {2} \
   CONFIG.INDEX {0} \
 ] [get_bd_intf_pins $visp_ss_0/TILE2_ISP_NSU]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S_AXI_LITE} \
   CONFIG.ASSOCIATED_RESET {s_axi_lite_rstn} \
 ] [get_bd_pins $visp_ss_0/s_axi_lite_aclk]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins $visp_ss_0/s_axi_lite_rstn]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {TILE0_ISP0_NMU} \
 ] [get_bd_pins $visp_ss_0/tile0_nmu0_axi_clk]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {TILE0_ISP1_NMU} \
 ] [get_bd_pins $visp_ss_0/tile0_nmu1_axi_clk]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {TILE0_ISP_NSU} \
 ] [get_bd_pins $visp_ss_0/tile0_nsu_axi_clk]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins $visp_ss_0/tile0_pl_isp_rstn]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {TILE0_ISP_MIPI_VIDIN0} \
 ] [get_bd_pins $visp_ss_0/tile0_pl_isp_vidin0_clk]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {TILE0_ISP_MIPI_VIDIN1} \
 ] [get_bd_pins $visp_ss_0/tile0_pl_isp_vidin1_clk]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {TILE0_ISP_MIPI_VIDIN2} \
 ] [get_bd_pins $visp_ss_0/tile0_pl_isp_vidin2_clk]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {TILE0_ISP_MIPI_VIDIN3} \
 ] [get_bd_pins $visp_ss_0/tile0_pl_isp_vidin3_clk]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {TILE0_ISP_MIPI_VIDIN4} \
 ] [get_bd_pins $visp_ss_0/tile0_pl_isp_vidin4_clk]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {TILE1_ISP0_NMU} \
 ] [get_bd_pins $visp_ss_0/tile1_nmu0_axi_clk]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {TILE1_ISP1_NMU} \
 ] [get_bd_pins $visp_ss_0/tile1_nmu1_axi_clk]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {TILE1_ISP_NSU} \
 ] [get_bd_pins $visp_ss_0/tile1_nsu_axi_clk]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins $visp_ss_0/tile1_pl_isp_rstn]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {TILE1_ISP_MIPI_VIDIN0} \
 ] [get_bd_pins $visp_ss_0/tile1_pl_isp_vidin0_clk]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {TILE1_ISP_MIPI_VIDIN1} \
 ] [get_bd_pins $visp_ss_0/tile1_pl_isp_vidin1_clk]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {TILE1_ISP_MIPI_VIDIN2} \
 ] [get_bd_pins $visp_ss_0/tile1_pl_isp_vidin2_clk]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {TILE1_ISP_MIPI_VIDIN3} \
 ] [get_bd_pins $visp_ss_0/tile1_pl_isp_vidin3_clk]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {TILE1_ISP_MIPI_VIDIN4} \
 ] [get_bd_pins $visp_ss_0/tile1_pl_isp_vidin4_clk]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {TILE2_ISP0_NMU} \
 ] [get_bd_pins $visp_ss_0/tile2_nmu0_axi_clk]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {TILE2_ISP1_NMU} \
 ] [get_bd_pins $visp_ss_0/tile2_nmu1_axi_clk]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {TILE2_ISP_NSU} \
 ] [get_bd_pins $visp_ss_0/tile2_nsu_axi_clk]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins $visp_ss_0/tile2_pl_isp_rstn]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {TILE2_ISP_MIPI_VIDIN0} \
 ] [get_bd_pins $visp_ss_0/tile2_pl_isp_vidin0_clk]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {TILE2_ISP_MIPI_VIDIN1} \
 ] [get_bd_pins $visp_ss_0/tile2_pl_isp_vidin1_clk]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {TILE2_ISP_MIPI_VIDIN3} \
 ] [get_bd_pins $visp_ss_0/tile2_pl_isp_vidin3_clk]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {TILE2_ISP_MIPI_VIDIN4} \
 ] [get_bd_pins $visp_ss_0/tile2_pl_isp_vidin4_clk]

  # Create instance: ilvector_logic_6, and set properties
  set ilvector_logic_6 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilvector_logic ilvector_logic_6 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {or} \
    CONFIG.C_SIZE {1} \
  ] $ilvector_logic_6


  # Create instance: ilconcat_5, and set properties
  set ilconcat_5 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconcat ilconcat_5 ]
  set_property CONFIG.NUM_PORTS {4} $ilconcat_5


  # Create instance: ilvector_logic_7, and set properties
  set ilvector_logic_7 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilvector_logic ilvector_logic_7 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {or} \
    CONFIG.C_SIZE {1} \
  ] $ilvector_logic_7


  # Create instance: axi_noc2_visp_ss, and set properties
  set axi_noc2_visp_ss [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc2 axi_noc2_visp_ss ]
  set_property -dict [list \
    CONFIG.MI_SIDEBAND_PINS {} \
    CONFIG.NUM_CLKS {9} \
    CONFIG.NUM_MI {3} \
    CONFIG.NUM_NMI {12} \
    CONFIG.NUM_NSI {3} \
    CONFIG.NUM_SI {6} \
    CONFIG.SI_SIDEBAND_PINS {} \
  ] $axi_noc2_visp_ss


  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CATEGORY {isp} \
 ] [get_bd_intf_pins $axi_noc2_visp_ss/M00_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CATEGORY {isp} \
 ] [get_bd_intf_pins $axi_noc2_visp_ss/M01_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CATEGORY {isp} \
 ] [get_bd_intf_pins $axi_noc2_visp_ss/M02_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.R_TRAFFIC_CLASS {ISOCHRONOUS} \
   CONFIG.W_TRAFFIC_CLASS {ISOCHRONOUS} \
   CONFIG.CONNECTIONS {M06_INI {read_bw {100} write_bw {100} initial_boot {false} } M00_INI {read_bw {1100} write_bw {2200} initial_boot {false} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {isp} \
 ] [get_bd_intf_pins $axi_noc2_visp_ss/S00_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M00_AXI {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4} initial_boot {false} }} \
 ] [get_bd_intf_pins $axi_noc2_visp_ss/S00_INI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.R_TRAFFIC_CLASS {ISOCHRONOUS} \
   CONFIG.W_TRAFFIC_CLASS {ISOCHRONOUS} \
   CONFIG.CONNECTIONS {M07_INI {read_bw {100} write_bw {100} initial_boot {false} } M01_INI {read_bw {100} write_bw {1100} initial_boot {false} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {isp} \
 ] [get_bd_intf_pins $axi_noc2_visp_ss/S01_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M01_AXI {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4} initial_boot {false} }} \
 ] [get_bd_intf_pins $axi_noc2_visp_ss/S01_INI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.R_TRAFFIC_CLASS {ISOCHRONOUS} \
   CONFIG.W_TRAFFIC_CLASS {ISOCHRONOUS} \
   CONFIG.CONNECTIONS {M02_INI {read_bw {1100} write_bw {2200} initial_boot {false} } M08_INI {read_bw {100} write_bw {100} initial_boot {false} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {isp} \
 ] [get_bd_intf_pins $axi_noc2_visp_ss/S02_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M02_AXI {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4} initial_boot {false} }} \
 ] [get_bd_intf_pins $axi_noc2_visp_ss/S02_INI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.R_TRAFFIC_CLASS {ISOCHRONOUS} \
   CONFIG.W_TRAFFIC_CLASS {ISOCHRONOUS} \
   CONFIG.CONNECTIONS {M03_INI {read_bw {100} write_bw {1100} initial_boot {false} } M09_INI {read_bw {100} write_bw {100} initial_boot {false} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {isp} \
 ] [get_bd_intf_pins $axi_noc2_visp_ss/S03_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.R_TRAFFIC_CLASS {ISOCHRONOUS} \
   CONFIG.W_TRAFFIC_CLASS {ISOCHRONOUS} \
   CONFIG.CONNECTIONS {M04_INI {read_bw {1800} write_bw {3600} initial_boot {false} } M10_INI {read_bw {100} write_bw {100} initial_boot {false} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {isp} \
 ] [get_bd_intf_pins $axi_noc2_visp_ss/S04_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.R_TRAFFIC_CLASS {ISOCHRONOUS} \
   CONFIG.W_TRAFFIC_CLASS {ISOCHRONOUS} \
   CONFIG.CONNECTIONS {M05_INI {read_bw {1800} write_bw {3600} initial_boot {false} } M11_INI {read_bw {100} write_bw {100} initial_boot {false} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {isp} \
 ] [get_bd_intf_pins $axi_noc2_visp_ss/S05_AXI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI} \
 ] [get_bd_pins $axi_noc2_visp_ss/aclk0]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S01_AXI} \
 ] [get_bd_pins $axi_noc2_visp_ss/aclk1]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M00_AXI} \
 ] [get_bd_pins $axi_noc2_visp_ss/aclk2]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S02_AXI} \
 ] [get_bd_pins $axi_noc2_visp_ss/aclk3]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S03_AXI} \
 ] [get_bd_pins $axi_noc2_visp_ss/aclk4]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M01_AXI} \
 ] [get_bd_pins $axi_noc2_visp_ss/aclk5]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S04_AXI} \
 ] [get_bd_pins $axi_noc2_visp_ss/aclk6]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S05_AXI} \
 ] [get_bd_pins $axi_noc2_visp_ss/aclk7]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M02_AXI} \
 ] [get_bd_pins $axi_noc2_visp_ss/aclk8]

  # Create instance: hier_mipi_4
  create_hier_cell_hier_mipi_4 $hier_obj hier_mipi_4

  # Create instance: hier_mipi_5
  create_hier_cell_hier_mipi_5 $hier_obj hier_mipi_5

  # Create instance: hier_mipi_0
  create_hier_cell_hier_mipi_0 $hier_obj hier_mipi_0

  # Create instance: hier_mipi_1
  create_hier_cell_hier_mipi_1 $hier_obj hier_mipi_1

  # Create instance: hier_mipi_2
  create_hier_cell_hier_mipi_2 $hier_obj hier_mipi_2

  # Create instance: hier_mipi_3
  create_hier_cell_hier_mipi_3 $hier_obj hier_mipi_3

  # Create instance: fmc_iic_2, and set properties
  set fmc_iic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic fmc_iic_2 ]
  set_property CONFIG.IIC_FREQ_KHZ {1000} $fmc_iic_2


  # Create instance: fmc_iic_5, and set properties
  set fmc_iic_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic fmc_iic_5 ]
  set_property CONFIG.IIC_FREQ_KHZ {1000} $fmc_iic_5


  # Create instance: smartconnect_rpu, and set properties
  set smartconnect_rpu [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect smartconnect_rpu ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {1} \
    CONFIG.NUM_MI {3} \
    CONFIG.NUM_SI {1} \
  ] $smartconnect_rpu


  # Create instance: fmc_iic_3, and set properties
  set fmc_iic_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic fmc_iic_3 ]
  set_property CONFIG.IIC_FREQ_KHZ {1000} $fmc_iic_3


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins fmc_iic_2/IIC] [get_bd_intf_pins FMC_IIC_4]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins fmc_iic_3/IIC] [get_bd_intf_pins FMC_IIC_6]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins fmc_iic_5/IIC] [get_bd_intf_pins FMC_IIC_7]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins smartconnect_rpu/S00_AXI] [get_bd_intf_pins S00_AXI1]
  connect_bd_intf_net -intf_net MIPI1_1 [get_bd_intf_pins MIPI1] [get_bd_intf_pins hier_mipi_0/mipi_phy_if]
  connect_bd_intf_net -intf_net MIPI2_1 [get_bd_intf_pins MIPI2] [get_bd_intf_pins hier_mipi_1/mipi_phy_if]
  connect_bd_intf_net -intf_net MIPI3_1 [get_bd_intf_pins MIPI3] [get_bd_intf_pins hier_mipi_2/mipi_phy_if]
  connect_bd_intf_net -intf_net MIPI4_1 [get_bd_intf_pins MIPI4] [get_bd_intf_pins hier_mipi_3/mipi_phy_if]
  connect_bd_intf_net -intf_net Master_NoC_M07_INI [get_bd_intf_pins S00_INI] [get_bd_intf_pins axi_noc2_visp_ss/S00_INI]
  connect_bd_intf_net -intf_net Master_NoC_M08_INI [get_bd_intf_pins S01_INI] [get_bd_intf_pins axi_noc2_visp_ss/S01_INI]
  connect_bd_intf_net -intf_net Master_NoC_M09_INI [get_bd_intf_pins S02_INI] [get_bd_intf_pins axi_noc2_visp_ss/S02_INI]
  connect_bd_intf_net -intf_net Smart_connect_mipi_M00_AXI [get_bd_intf_pins Smart_connect_mipi/M00_AXI] [get_bd_intf_pins hier_mipi_0/s_axi_ctrl]
  connect_bd_intf_net -intf_net Smart_connect_mipi_M01_AXI [get_bd_intf_pins Smart_connect_mipi/M01_AXI] [get_bd_intf_pins hier_mipi_1/s_axi_ctrl]
  connect_bd_intf_net -intf_net Smart_connect_mipi_M02_AXI [get_bd_intf_pins Smart_connect_mipi/M02_AXI] [get_bd_intf_pins hier_mipi_2/s_axi_ctrl]
  connect_bd_intf_net -intf_net Smart_connect_mipi_M03_AXI [get_bd_intf_pins Smart_connect_mipi/M03_AXI] [get_bd_intf_pins hier_mipi_3/s_axi_ctrl]
  connect_bd_intf_net -intf_net Smart_connect_mipi_M04_AXI [get_bd_intf_pins Smart_connect_mipi/M04_AXI] [get_bd_intf_pins hier_mipi_4/s_axi_ctrl]
  connect_bd_intf_net -intf_net Smart_connect_mipi_M05_AXI [get_bd_intf_pins Smart_connect_mipi/M05_AXI] [get_bd_intf_pins hier_mipi_5/s_axi_ctrl]
  connect_bd_intf_net -intf_net Smart_connect_mipi_M06_AXI [get_bd_intf_pins Smart_connect_mipi/M06_AXI] [get_bd_intf_pins visp_ss_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_noc2_visp_ss_M00_INI [get_bd_intf_pins M00_INI] [get_bd_intf_pins axi_noc2_visp_ss/M00_INI]
  connect_bd_intf_net -intf_net axi_noc2_visp_ss_M01_INI [get_bd_intf_pins M01_INI] [get_bd_intf_pins axi_noc2_visp_ss/M01_INI]
  connect_bd_intf_net -intf_net axi_noc2_visp_ss_M02_AXI [get_bd_intf_pins visp_ss_0/TILE2_ISP_NSU] [get_bd_intf_pins axi_noc2_visp_ss/M02_AXI]
  connect_bd_intf_net -intf_net axi_noc2_visp_ss_M02_INI [get_bd_intf_pins M02_INI] [get_bd_intf_pins axi_noc2_visp_ss/M02_INI]
  connect_bd_intf_net -intf_net axi_noc2_visp_ss_M03_INI [get_bd_intf_pins M03_INI] [get_bd_intf_pins axi_noc2_visp_ss/M03_INI]
  connect_bd_intf_net -intf_net axi_noc2_visp_ss_M04_INI [get_bd_intf_pins M04_INI] [get_bd_intf_pins axi_noc2_visp_ss/M04_INI]
  connect_bd_intf_net -intf_net axi_noc2_visp_ss_M05_INI [get_bd_intf_pins M05_INI] [get_bd_intf_pins axi_noc2_visp_ss/M05_INI]
  connect_bd_intf_net -intf_net axi_noc2_visp_ss_M06_INI [get_bd_intf_pins M06_INI] [get_bd_intf_pins axi_noc2_visp_ss/M06_INI]
  connect_bd_intf_net -intf_net axi_noc2_visp_ss_M07_INI [get_bd_intf_pins M07_INI] [get_bd_intf_pins axi_noc2_visp_ss/M07_INI]
  connect_bd_intf_net -intf_net axi_noc2_visp_ss_M08_INI [get_bd_intf_pins M08_INI] [get_bd_intf_pins axi_noc2_visp_ss/M08_INI]
  connect_bd_intf_net -intf_net axi_noc2_visp_ss_M09_INI [get_bd_intf_pins M09_INI] [get_bd_intf_pins axi_noc2_visp_ss/M09_INI]
  connect_bd_intf_net -intf_net axi_noc2_visp_ss_M10_INI [get_bd_intf_pins M10_INI] [get_bd_intf_pins axi_noc2_visp_ss/M10_INI]
  connect_bd_intf_net -intf_net axi_noc2_visp_ss_M11_INI [get_bd_intf_pins M11_INI] [get_bd_intf_pins axi_noc2_visp_ss/M11_INI]
  connect_bd_intf_net -intf_net axis_broadcaster_0_M00_AXIS [get_bd_intf_pins axis_broadcaster_0/M00_AXIS] [get_bd_intf_pins visp_ss_0/TILE0_ISP_MIPI_VIDIN0]
  connect_bd_intf_net -intf_net axis_broadcaster_0_M01_AXIS [get_bd_intf_pins axis_broadcaster_0/M01_AXIS] [get_bd_intf_pins visp_ss_0/TILE0_ISP_MIPI_VIDIN1]
  connect_bd_intf_net -intf_net axis_broadcaster_1_M00_AXIS [get_bd_intf_pins axis_broadcaster_1/M00_AXIS] [get_bd_intf_pins visp_ss_0/TILE0_ISP_MIPI_VIDIN2]
  connect_bd_intf_net -intf_net axis_broadcaster_1_M01_AXIS [get_bd_intf_pins axis_broadcaster_1/M01_AXIS] [get_bd_intf_pins visp_ss_0/TILE0_ISP_MIPI_VIDIN3]
  connect_bd_intf_net -intf_net axis_broadcaster_2_M00_AXIS [get_bd_intf_pins axis_broadcaster_2/M00_AXIS] [get_bd_intf_pins visp_ss_0/TILE1_ISP_MIPI_VIDIN0]
  connect_bd_intf_net -intf_net axis_broadcaster_2_M01_AXIS [get_bd_intf_pins axis_broadcaster_2/M01_AXIS] [get_bd_intf_pins visp_ss_0/TILE1_ISP_MIPI_VIDIN1]
  connect_bd_intf_net -intf_net axis_broadcaster_3_M00_AXIS [get_bd_intf_pins axis_broadcaster_3/M00_AXIS] [get_bd_intf_pins visp_ss_0/TILE1_ISP_MIPI_VIDIN2]
  connect_bd_intf_net -intf_net axis_broadcaster_3_M01_AXIS [get_bd_intf_pins axis_broadcaster_3/M01_AXIS] [get_bd_intf_pins visp_ss_0/TILE1_ISP_MIPI_VIDIN3]
  connect_bd_intf_net -intf_net axis_broadcaster_4_M00_AXIS [get_bd_intf_pins axis_broadcaster_4/M00_AXIS] [get_bd_intf_pins visp_ss_0/TILE0_ISP_MIPI_VIDIN4]
  connect_bd_intf_net -intf_net axis_broadcaster_4_M01_AXIS [get_bd_intf_pins axis_broadcaster_4/M01_AXIS] [get_bd_intf_pins visp_ss_0/TILE1_ISP_MIPI_VIDIN4]
  connect_bd_intf_net -intf_net axis_broadcaster_5_M00_AXIS [get_bd_intf_pins axis_broadcaster_5/M00_AXIS] [get_bd_intf_pins visp_ss_0/TILE2_ISP_MIPI_VIDIN0]
  connect_bd_intf_net -intf_net axis_broadcaster_5_M01_AXIS [get_bd_intf_pins axis_broadcaster_5/M01_AXIS] [get_bd_intf_pins visp_ss_0/TILE2_ISP_MIPI_VIDIN1]
  connect_bd_intf_net -intf_net axis_broadcaster_5_M02_AXIS [get_bd_intf_pins axis_broadcaster_5/M02_AXIS] [get_bd_intf_pins visp_ss_0/TILE2_ISP_MIPI_VIDIN3]
  connect_bd_intf_net -intf_net axis_broadcaster_5_M03_AXIS [get_bd_intf_pins axis_broadcaster_5/M03_AXIS] [get_bd_intf_pins visp_ss_0/TILE2_ISP_MIPI_VIDIN4]
  connect_bd_intf_net -intf_net ctrl_smc_M00_AXI [get_bd_intf_pins S00_AXI] [get_bd_intf_pins Smart_connect_mipi/S00_AXI]
  connect_bd_intf_net -intf_net hier_mipi_0_sensor_axis_video [get_bd_intf_pins hier_mipi_0/sensor_axis_video] [get_bd_intf_pins axis_broadcaster_0/S_AXIS]
  connect_bd_intf_net -intf_net hier_mipi_1_sensor_axis_video [get_bd_intf_pins hier_mipi_1/sensor_axis_video] [get_bd_intf_pins axis_broadcaster_1/S_AXIS]
  connect_bd_intf_net -intf_net hier_mipi_2_sensor_axis_video [get_bd_intf_pins hier_mipi_2/sensor_axis_video] [get_bd_intf_pins axis_broadcaster_2/S_AXIS]
  connect_bd_intf_net -intf_net hier_mipi_3_sensor_axis_video [get_bd_intf_pins hier_mipi_3/sensor_axis_video] [get_bd_intf_pins axis_broadcaster_3/S_AXIS]
  connect_bd_intf_net -intf_net hier_mipi_4_sensor_axis_video [get_bd_intf_pins hier_mipi_4/sensor_axis_video] [get_bd_intf_pins axis_broadcaster_4/S_AXIS]
  connect_bd_intf_net -intf_net hier_mipi_5_sensor_axis_video [get_bd_intf_pins axis_broadcaster_5/S_AXIS] [get_bd_intf_pins hier_mipi_5/sensor_axis_video]
  connect_bd_intf_net -intf_net mipi_phy_if_0_1 [get_bd_intf_pins MIPI5] [get_bd_intf_pins hier_mipi_4/mipi_phy_if]
  connect_bd_intf_net -intf_net mipi_phy_if_1_1 [get_bd_intf_pins MIPI6] [get_bd_intf_pins hier_mipi_5/mipi_phy_if]
  connect_bd_intf_net -intf_net smartconnect_rpu_M00_AXI [get_bd_intf_pins smartconnect_rpu/M00_AXI] [get_bd_intf_pins fmc_iic_2/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_rpu_M01_AXI [get_bd_intf_pins smartconnect_rpu/M01_AXI] [get_bd_intf_pins fmc_iic_3/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_rpu_M02_AXI [get_bd_intf_pins smartconnect_rpu/M02_AXI] [get_bd_intf_pins fmc_iic_5/S_AXI]
  connect_bd_intf_net -intf_net visp_ss_0_TILE0_ISP0_NMU [get_bd_intf_pins axi_noc2_visp_ss/S00_AXI] [get_bd_intf_pins visp_ss_0/TILE0_ISP0_NMU]
  connect_bd_intf_net -intf_net visp_ss_0_TILE0_ISP1_NMU [get_bd_intf_pins axi_noc2_visp_ss/S01_AXI] [get_bd_intf_pins visp_ss_0/TILE0_ISP1_NMU]
  connect_bd_intf_net -intf_net visp_ss_0_TILE0_ISP_NSU [get_bd_intf_pins axi_noc2_visp_ss/M00_AXI] [get_bd_intf_pins visp_ss_0/TILE0_ISP_NSU]
  connect_bd_intf_net -intf_net visp_ss_0_TILE1_ISP0_NMU [get_bd_intf_pins axi_noc2_visp_ss/S02_AXI] [get_bd_intf_pins visp_ss_0/TILE1_ISP0_NMU]
  connect_bd_intf_net -intf_net visp_ss_0_TILE1_ISP1_NMU [get_bd_intf_pins axi_noc2_visp_ss/S03_AXI] [get_bd_intf_pins visp_ss_0/TILE1_ISP1_NMU]
  connect_bd_intf_net -intf_net visp_ss_0_TILE1_ISP_NSU [get_bd_intf_pins axi_noc2_visp_ss/M01_AXI] [get_bd_intf_pins visp_ss_0/TILE1_ISP_NSU]
  connect_bd_intf_net -intf_net visp_ss_0_TILE2_ISP0_NMU [get_bd_intf_pins visp_ss_0/TILE2_ISP0_NMU] [get_bd_intf_pins axi_noc2_visp_ss/S04_AXI]
  connect_bd_intf_net -intf_net visp_ss_0_TILE2_ISP1_NMU [get_bd_intf_pins axi_noc2_visp_ss/S05_AXI] [get_bd_intf_pins visp_ss_0/TILE2_ISP1_NMU]

  # Create port connections
  connect_bd_net -net Net4  [get_bd_pins hier_mipi_1/header_valid] \
  [get_bd_pins visp_ss_0/tile0_isp_mipi_vidin3_header_valid] \
  [get_bd_pins visp_ss_0/tile0_isp_mipi_vidin2_header_valid]
  connect_bd_net -net aresetn_1  [get_bd_pins aresetn] \
  [get_bd_pins smartconnect_rpu/aresetn] \
  [get_bd_pins fmc_iic_3/s_axi_aresetn] \
  [get_bd_pins fmc_iic_5/s_axi_aresetn] \
  [get_bd_pins fmc_iic_2/s_axi_aresetn]
  connect_bd_net -net clkx5_wiz_0_dphy_clk_200M  [get_bd_pins dphy_clk_200M] \
  [get_bd_pins hier_mipi_0/dphy_clk_200M] \
  [get_bd_pins hier_mipi_3/dphy_clk_200M] \
  [get_bd_pins hier_mipi_2/dphy_clk_200M] \
  [get_bd_pins hier_mipi_5/dphy_clk_200M] \
  [get_bd_pins hier_mipi_1/dphy_clk_200M] \
  [get_bd_pins hier_mipi_4/dphy_clk_200M]
  connect_bd_net -net fmc_iic_2_iic2intc_irpt  [get_bd_pins fmc_iic_2/iic2intc_irpt] \
  [get_bd_pins iic2intc_irpt2]
  connect_bd_net -net fmc_iic_3_iic2intc_irpt  [get_bd_pins fmc_iic_3/iic2intc_irpt] \
  [get_bd_pins iic2intc_irpt]
  connect_bd_net -net fmc_iic_5_iic2intc_irpt  [get_bd_pins fmc_iic_5/iic2intc_irpt] \
  [get_bd_pins iic2intc_irpt1]
  connect_bd_net -net hier_mipi_0_clkoutphy_out  [get_bd_pins hier_mipi_0/clkoutphy_out] \
  [get_bd_pins hier_mipi_5/shared_pll_clkoutphy_in_0]
  connect_bd_net -net hier_mipi_0_cnts_rxwordclkhs_out  [get_bd_pins hier_mipi_0/cnts_rxwordclkhs_out] \
  [get_bd_pins hier_mipi_5/cnts_rxwordclkhs_in_0]
  connect_bd_net -net hier_mipi_0_csirxss_csi_irq  [get_bd_pins hier_mipi_0/csirxss_csi_irq] \
  [get_bd_pins csirxss_csi_irq2]
  connect_bd_net -net hier_mipi_0_header_data  [get_bd_pins hier_mipi_0/header_data] \
  [get_bd_pins visp_ss_0/tile0_isp_mipi_vidin0_header_data] \
  [get_bd_pins visp_ss_0/tile0_isp_mipi_vidin1_header_data]
  connect_bd_net -net hier_mipi_0_header_valid  [get_bd_pins hier_mipi_0/header_valid] \
  [get_bd_pins visp_ss_0/tile0_isp_mipi_vidin0_header_valid] \
  [get_bd_pins visp_ss_0/tile0_isp_mipi_vidin1_header_valid]
  connect_bd_net -net hier_mipi_0_pll_lock_out  [get_bd_pins hier_mipi_0/pll_lock_out] \
  [get_bd_pins hier_mipi_5/shared_pll_locked_in_0]
  connect_bd_net -net hier_mipi_1_clkoutphy_out  [get_bd_pins hier_mipi_1/clkoutphy_out] \
  [get_bd_pins hier_mipi_3/shared_pll_clkoutphy_in_0]
  connect_bd_net -net hier_mipi_1_cnts_rxwordclkhs_out  [get_bd_pins hier_mipi_1/cnts_rxwordclkhs_out] \
  [get_bd_pins hier_mipi_3/cnts_rxwordclkhs_in_0]
  connect_bd_net -net hier_mipi_1_csirxss_csi_irq  [get_bd_pins hier_mipi_1/csirxss_csi_irq] \
  [get_bd_pins csirxss_csi_irq3]
  connect_bd_net -net hier_mipi_1_header_data  [get_bd_pins hier_mipi_1/header_data] \
  [get_bd_pins visp_ss_0/tile0_isp_mipi_vidin3_header_data] \
  [get_bd_pins visp_ss_0/tile0_isp_mipi_vidin2_header_data]
  connect_bd_net -net hier_mipi_1_pll_clkoutphy_90_out  [get_bd_pins hier_mipi_1/pll_clkoutphy_90_out] \
  [get_bd_pins hier_mipi_3/shared_pll_clkoutphy_90_in_0]
  connect_bd_net -net hier_mipi_1_pll_lock_out  [get_bd_pins hier_mipi_1/pll_lock_out] \
  [get_bd_pins hier_mipi_3/shared_pll_locked_in_0]
  connect_bd_net -net hier_mipi_2_clkoutphy_out  [get_bd_pins hier_mipi_2/clkoutphy_out] \
  [get_bd_pins hier_mipi_4/shared_pll_clkoutphy_in_0]
  connect_bd_net -net hier_mipi_2_cnts_rxwordclkhs_out  [get_bd_pins hier_mipi_2/cnts_rxwordclkhs_out] \
  [get_bd_pins hier_mipi_4/cnts_rxwordclkhs_in_0]
  connect_bd_net -net hier_mipi_2_csirxss_csi_irq  [get_bd_pins hier_mipi_2/csirxss_csi_irq] \
  [get_bd_pins csirxss_csi_irq4]
  connect_bd_net -net hier_mipi_2_header_data  [get_bd_pins hier_mipi_2/header_data] \
  [get_bd_pins visp_ss_0/tile1_isp_mipi_vidin0_header_data] \
  [get_bd_pins visp_ss_0/tile1_isp_mipi_vidin1_header_data]
  connect_bd_net -net hier_mipi_2_header_valid  [get_bd_pins hier_mipi_2/header_valid] \
  [get_bd_pins visp_ss_0/tile1_isp_mipi_vidin0_header_valid] \
  [get_bd_pins visp_ss_0/tile1_isp_mipi_vidin1_header_valid]
  connect_bd_net -net hier_mipi_2_pll_clkoutphy_90_out  [get_bd_pins hier_mipi_2/pll_clkoutphy_90_out] \
  [get_bd_pins hier_mipi_4/shared_pll_clkoutphy_90_in_0]
  connect_bd_net -net hier_mipi_2_pll_lock_out  [get_bd_pins hier_mipi_2/pll_lock_out] \
  [get_bd_pins hier_mipi_4/shared_pll_locked_in_0]
  connect_bd_net -net hier_mipi_3_csirxss_csi_irq  [get_bd_pins hier_mipi_3/csirxss_csi_irq] \
  [get_bd_pins csirxss_csi_irq5]
  connect_bd_net -net hier_mipi_3_header_data  [get_bd_pins hier_mipi_4/header_data] \
  [get_bd_pins visp_ss_0/tile1_isp_mipi_vidin4_header_data] \
  [get_bd_pins visp_ss_0/tile0_isp_mipi_vidin4_header_data]
  connect_bd_net -net hier_mipi_3_header_data1  [get_bd_pins hier_mipi_3/header_data] \
  [get_bd_pins visp_ss_0/tile1_isp_mipi_vidin3_header_data] \
  [get_bd_pins visp_ss_0/tile1_isp_mipi_vidin2_header_data]
  connect_bd_net -net hier_mipi_3_header_valid  [get_bd_pins hier_mipi_4/header_valid] \
  [get_bd_pins visp_ss_0/tile1_isp_mipi_vidin4_header_valid] \
  [get_bd_pins visp_ss_0/tile0_isp_mipi_vidin4_header_valid]
  connect_bd_net -net hier_mipi_3_header_valid1  [get_bd_pins hier_mipi_3/header_valid] \
  [get_bd_pins visp_ss_0/tile1_isp_mipi_vidin3_header_valid] \
  [get_bd_pins visp_ss_0/tile1_isp_mipi_vidin2_header_valid]
  connect_bd_net -net hier_mipi_4_csirxss_csi_irq  [get_bd_pins hier_mipi_4/csirxss_csi_irq] \
  [get_bd_pins csirxss_csi_irq]
  connect_bd_net -net hier_mipi_5_csirxss_csi_irq  [get_bd_pins hier_mipi_5/csirxss_csi_irq] \
  [get_bd_pins csirxss_csi_irq1]
  connect_bd_net -net hier_mipi_5_header_data  [get_bd_pins hier_mipi_5/header_data] \
  [get_bd_pins visp_ss_0/tile2_isp_mipi_vidin4_header_data] \
  [get_bd_pins visp_ss_0/tile2_isp_mipi_vidin0_header_data] \
  [get_bd_pins visp_ss_0/tile2_isp_mipi_vidin1_header_data] \
  [get_bd_pins visp_ss_0/tile2_isp_mipi_vidin3_header_data]
  connect_bd_net -net hier_mipi_5_header_valid  [get_bd_pins hier_mipi_5/header_valid] \
  [get_bd_pins visp_ss_0/tile2_isp_mipi_vidin4_header_valid] \
  [get_bd_pins visp_ss_0/tile2_isp_mipi_vidin0_header_valid] \
  [get_bd_pins visp_ss_0/tile2_isp_mipi_vidin1_header_valid] \
  [get_bd_pins visp_ss_0/tile2_isp_mipi_vidin3_header_valid]
  connect_bd_net -net ilconcat_0_dout  [get_bd_pins ilconcat_0/dout] \
  [get_bd_pins axis_broadcaster_0/m_axis_tready]
  connect_bd_net -net ilconcat_1_dout  [get_bd_pins ilconcat_1/dout] \
  [get_bd_pins axis_broadcaster_1/m_axis_tready]
  connect_bd_net -net ilconcat_2_dout  [get_bd_pins ilconcat_2/dout] \
  [get_bd_pins axis_broadcaster_2/m_axis_tready]
  connect_bd_net -net ilconcat_3_dout  [get_bd_pins ilconcat_3/dout] \
  [get_bd_pins axis_broadcaster_3/m_axis_tready]
  connect_bd_net -net ilconcat_4_dout  [get_bd_pins ilconcat_4/dout] \
  [get_bd_pins axis_broadcaster_4/m_axis_tready]
  connect_bd_net -net ilconcat_5_dout  [get_bd_pins ilconcat_5/dout] \
  [get_bd_pins axis_broadcaster_5/m_axis_tready]
  connect_bd_net -net ilvector_logic_0_Res  [get_bd_pins ilvector_logic_0/Res] \
  [get_bd_pins ilconcat_0/In0] \
  [get_bd_pins ilconcat_0/In1]
  connect_bd_net -net ilvector_logic_0_Res1  [get_bd_pins ilvector_logic_1/Res] \
  [get_bd_pins ilconcat_1/In0] \
  [get_bd_pins ilconcat_1/In1]
  connect_bd_net -net ilvector_logic_0_Res2  [get_bd_pins ilvector_logic_2/Res] \
  [get_bd_pins ilconcat_2/In0] \
  [get_bd_pins ilconcat_2/In1]
  connect_bd_net -net ilvector_logic_0_Res3  [get_bd_pins ilvector_logic_3/Res] \
  [get_bd_pins ilconcat_3/In0] \
  [get_bd_pins ilconcat_3/In1]
  connect_bd_net -net ilvector_logic_0_Res4  [get_bd_pins ilvector_logic_4/Res] \
  [get_bd_pins ilconcat_4/In0] \
  [get_bd_pins ilconcat_4/In1]
  connect_bd_net -net ilvector_logic_6_Res  [get_bd_pins ilvector_logic_5/Res] \
  [get_bd_pins ilconcat_5/In0] \
  [get_bd_pins ilconcat_5/In1] \
  [get_bd_pins ilconcat_5/In2] \
  [get_bd_pins ilconcat_5/In3]
  connect_bd_net -net ilvector_logic_6_Res1  [get_bd_pins ilvector_logic_6/Res] \
  [get_bd_pins ilvector_logic_5/Op1]
  connect_bd_net -net ilvector_logic_7_Res  [get_bd_pins ilvector_logic_7/Res] \
  [get_bd_pins ilvector_logic_5/Op2]
  connect_bd_net -net ps_wizard_0_pl0_ref_clk1  [get_bd_pins s_axi_aclk] \
  [get_bd_pins hier_mipi_0/s_axi_aclk] \
  [get_bd_pins hier_mipi_0/sensor_aclk] \
  [get_bd_pins hier_mipi_2/s_axi_aclk] \
  [get_bd_pins hier_mipi_2/sensor_aclk] \
  [get_bd_pins hier_mipi_3/s_axi_aclk] \
  [get_bd_pins hier_mipi_3/sensor_aclk] \
  [get_bd_pins axis_broadcaster_0/aclk] \
  [get_bd_pins axis_broadcaster_1/aclk] \
  [get_bd_pins axis_broadcaster_2/aclk] \
  [get_bd_pins hier_mipi_4/sensor_aclk] \
  [get_bd_pins hier_mipi_5/sensor_aclk] \
  [get_bd_pins hier_mipi_5/s_axi_aclk] \
  [get_bd_pins hier_mipi_4/s_axi_aclk] \
  [get_bd_pins axis_broadcaster_3/aclk] \
  [get_bd_pins axis_broadcaster_4/aclk] \
  [get_bd_pins hier_mipi_1/sensor_aclk] \
  [get_bd_pins hier_mipi_1/s_axi_aclk] \
  [get_bd_pins axis_broadcaster_5/aclk] \
  [get_bd_pins visp_ss_0/s_axi_lite_aclk] \
  [get_bd_pins visp_ss_0/tile0_pl_isp_vidin0_clk] \
  [get_bd_pins visp_ss_0/tile0_pl_isp_vidin1_clk] \
  [get_bd_pins visp_ss_0/tile0_pl_isp_vidin3_clk] \
  [get_bd_pins visp_ss_0/tile0_pl_isp_vidin4_clk] \
  [get_bd_pins visp_ss_0/tile0_ref_dpll_clk] \
  [get_bd_pins visp_ss_0/tile1_pl_isp_vidin0_clk] \
  [get_bd_pins visp_ss_0/tile1_pl_isp_vidin1_clk] \
  [get_bd_pins visp_ss_0/tile1_pl_isp_vidin3_clk] \
  [get_bd_pins visp_ss_0/tile1_pl_isp_vidin4_clk] \
  [get_bd_pins visp_ss_0/tile1_ref_dpll_clk] \
  [get_bd_pins visp_ss_0/tile2_pl_isp_vidin0_clk] \
  [get_bd_pins visp_ss_0/tile2_pl_isp_vidin4_clk] \
  [get_bd_pins visp_ss_0/tile2_ref_dpll_clk] \
  [get_bd_pins visp_ss_0/tile0_pl_isp_vidin2_clk] \
  [get_bd_pins visp_ss_0/tile1_pl_isp_vidin2_clk] \
  [get_bd_pins visp_ss_0/tile2_pl_isp_vidin1_clk] \
  [get_bd_pins visp_ss_0/tile2_pl_isp_vidin3_clk] \
  [get_bd_pins Smart_connect_mipi/aclk] \
  [get_bd_pins smartconnect_rpu/aclk] \
  [get_bd_pins fmc_iic_3/s_axi_aclk] \
  [get_bd_pins fmc_iic_5/s_axi_aclk] \
  [get_bd_pins fmc_iic_2/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn  [get_bd_pins s_axi_aresetn] \
  [get_bd_pins hier_mipi_0/s_axi_aresetn] \
  [get_bd_pins hier_mipi_0/sensor_aresetn] \
  [get_bd_pins hier_mipi_2/s_axi_aresetn] \
  [get_bd_pins hier_mipi_2/sensor_aresetn] \
  [get_bd_pins hier_mipi_3/s_axi_aresetn] \
  [get_bd_pins hier_mipi_3/sensor_aresetn] \
  [get_bd_pins axis_broadcaster_0/aresetn] \
  [get_bd_pins axis_broadcaster_1/aresetn] \
  [get_bd_pins axis_broadcaster_2/aresetn] \
  [get_bd_pins hier_mipi_5/sensor_aresetn] \
  [get_bd_pins hier_mipi_5/s_axi_aresetn] \
  [get_bd_pins hier_mipi_4/sensor_aresetn] \
  [get_bd_pins hier_mipi_4/s_axi_aresetn] \
  [get_bd_pins axis_broadcaster_3/aresetn] \
  [get_bd_pins axis_broadcaster_4/aresetn] \
  [get_bd_pins hier_mipi_1/sensor_aresetn] \
  [get_bd_pins hier_mipi_1/s_axi_aresetn] \
  [get_bd_pins axis_broadcaster_5/aresetn] \
  [get_bd_pins visp_ss_0/s_axi_lite_rstn] \
  [get_bd_pins visp_ss_0/tile0_pl_isp_rstn] \
  [get_bd_pins visp_ss_0/tile1_pl_isp_rstn] \
  [get_bd_pins visp_ss_0/tile2_pl_isp_rstn] \
  [get_bd_pins Smart_connect_mipi/aresetn]
  connect_bd_net -net shared_pll_clkoutphy_90_in_0_1  [get_bd_pins hier_mipi_0/pll_clkoutphy_90_out] \
  [get_bd_pins hier_mipi_5/shared_pll_clkoutphy_90_in_0]
  connect_bd_net -net visp_ss_0_TILE0_ISP_MIPI_VIDIN0_tready  [get_bd_pins visp_ss_0/TILE0_ISP_MIPI_VIDIN0_tready] \
  [get_bd_pins ilvector_logic_0/Op1]
  connect_bd_net -net visp_ss_0_TILE0_ISP_MIPI_VIDIN1_tready  [get_bd_pins visp_ss_0/TILE0_ISP_MIPI_VIDIN1_tready] \
  [get_bd_pins ilvector_logic_0/Op2]
  connect_bd_net -net visp_ss_0_TILE0_ISP_MIPI_VIDIN2_tready  [get_bd_pins visp_ss_0/TILE0_ISP_MIPI_VIDIN2_tready] \
  [get_bd_pins ilvector_logic_1/Op2]
  connect_bd_net -net visp_ss_0_TILE0_ISP_MIPI_VIDIN3_tready  [get_bd_pins visp_ss_0/TILE0_ISP_MIPI_VIDIN3_tready] \
  [get_bd_pins ilvector_logic_1/Op1]
  connect_bd_net -net visp_ss_0_TILE0_ISP_MIPI_VIDIN4_tready  [get_bd_pins visp_ss_0/TILE0_ISP_MIPI_VIDIN4_tready] \
  [get_bd_pins ilvector_logic_4/Op1]
  connect_bd_net -net visp_ss_0_TILE1_ISP_MIPI_VIDIN0_tready  [get_bd_pins visp_ss_0/TILE1_ISP_MIPI_VIDIN0_tready] \
  [get_bd_pins ilvector_logic_2/Op1]
  connect_bd_net -net visp_ss_0_TILE1_ISP_MIPI_VIDIN1_tready  [get_bd_pins visp_ss_0/TILE1_ISP_MIPI_VIDIN1_tready] \
  [get_bd_pins ilvector_logic_2/Op2]
  connect_bd_net -net visp_ss_0_TILE1_ISP_MIPI_VIDIN2_tready  [get_bd_pins visp_ss_0/TILE1_ISP_MIPI_VIDIN2_tready] \
  [get_bd_pins ilvector_logic_3/Op2]
  connect_bd_net -net visp_ss_0_TILE1_ISP_MIPI_VIDIN3_tready  [get_bd_pins visp_ss_0/TILE1_ISP_MIPI_VIDIN3_tready] \
  [get_bd_pins ilvector_logic_3/Op1]
  connect_bd_net -net visp_ss_0_TILE1_ISP_MIPI_VIDIN4_tready  [get_bd_pins visp_ss_0/TILE1_ISP_MIPI_VIDIN4_tready] \
  [get_bd_pins ilvector_logic_4/Op2]
  connect_bd_net -net visp_ss_0_TILE2_ISP_MIPI_VIDIN0_tready  [get_bd_pins visp_ss_0/TILE2_ISP_MIPI_VIDIN0_tready] \
  [get_bd_pins ilvector_logic_6/Op1]
  connect_bd_net -net visp_ss_0_TILE2_ISP_MIPI_VIDIN1_tready  [get_bd_pins visp_ss_0/TILE2_ISP_MIPI_VIDIN1_tready] \
  [get_bd_pins ilvector_logic_6/Op2]
  connect_bd_net -net visp_ss_0_TILE2_ISP_MIPI_VIDIN3_tready  [get_bd_pins visp_ss_0/TILE2_ISP_MIPI_VIDIN3_tready] \
  [get_bd_pins ilvector_logic_7/Op1]
  connect_bd_net -net visp_ss_0_TILE2_ISP_MIPI_VIDIN4_tready  [get_bd_pins visp_ss_0/TILE2_ISP_MIPI_VIDIN4_tready] \
  [get_bd_pins ilvector_logic_7/Op2]
  connect_bd_net -net visp_ss_0_tile0_isp0_fusa_irq  [get_bd_pins visp_ss_0/tile0_isp0_fusa_irq] \
  [get_bd_pins tile0_isp0_fusa_irq]
  connect_bd_net -net visp_ss_0_tile0_isp0_isp_irq  [get_bd_pins visp_ss_0/tile0_isp0_isp_irq] \
  [get_bd_pins tile0_isp0_isp_irq]
  connect_bd_net -net visp_ss_0_tile0_isp1_fusa_irq  [get_bd_pins visp_ss_0/tile0_isp1_fusa_irq] \
  [get_bd_pins tile0_isp1_fusa_irq]
  connect_bd_net -net visp_ss_0_tile0_isp1_isp_irq  [get_bd_pins visp_ss_0/tile0_isp1_isp_irq] \
  [get_bd_pins tile0_isp1_isp_irq]
  connect_bd_net -net visp_ss_0_tile0_isp_isr_irq  [get_bd_pins visp_ss_0/tile0_isp_isr_irq] \
  [get_bd_pins tile0_isp_isr_irq]
  connect_bd_net -net visp_ss_0_tile0_isp_xmpu_interrupt  [get_bd_pins visp_ss_0/tile0_isp_xmpu_interrupt] \
  [get_bd_pins tile0_isp_xmpu_interrupt]
  connect_bd_net -net visp_ss_0_tile0_nmu0_axi_clk  [get_bd_pins visp_ss_0/tile0_nmu0_axi_clk] \
  [get_bd_pins axi_noc2_visp_ss/aclk0]
  connect_bd_net -net visp_ss_0_tile0_nmu1_axi_clk  [get_bd_pins visp_ss_0/tile0_nmu1_axi_clk] \
  [get_bd_pins axi_noc2_visp_ss/aclk1]
  connect_bd_net -net visp_ss_0_tile0_nsu_axi_clk  [get_bd_pins visp_ss_0/tile0_nsu_axi_clk] \
  [get_bd_pins axi_noc2_visp_ss/aclk2]
  connect_bd_net -net visp_ss_0_tile1_isp0_fusa_irq  [get_bd_pins visp_ss_0/tile1_isp0_fusa_irq] \
  [get_bd_pins tile1_isp0_fusa_irq]
  connect_bd_net -net visp_ss_0_tile1_isp0_isp_irq  [get_bd_pins visp_ss_0/tile1_isp0_isp_irq] \
  [get_bd_pins tile1_isp0_isp_irq]
  connect_bd_net -net visp_ss_0_tile1_isp1_fusa_irq  [get_bd_pins visp_ss_0/tile1_isp1_fusa_irq] \
  [get_bd_pins tile1_isp1_fusa_irq]
  connect_bd_net -net visp_ss_0_tile1_isp1_isp_irq  [get_bd_pins visp_ss_0/tile1_isp1_isp_irq] \
  [get_bd_pins tile1_isp1_isp_irq]
  connect_bd_net -net visp_ss_0_tile1_isp_isr_irq  [get_bd_pins visp_ss_0/tile1_isp_isr_irq] \
  [get_bd_pins tile1_isp_isr_irq]
  connect_bd_net -net visp_ss_0_tile1_isp_xmpu_interrupt  [get_bd_pins visp_ss_0/tile1_isp_xmpu_interrupt] \
  [get_bd_pins tile1_isp_xmpu_interrupt]
  connect_bd_net -net visp_ss_0_tile1_nmu0_axi_clk  [get_bd_pins visp_ss_0/tile1_nmu0_axi_clk] \
  [get_bd_pins axi_noc2_visp_ss/aclk3]
  connect_bd_net -net visp_ss_0_tile1_nmu1_axi_clk  [get_bd_pins visp_ss_0/tile1_nmu1_axi_clk] \
  [get_bd_pins axi_noc2_visp_ss/aclk4]
  connect_bd_net -net visp_ss_0_tile1_nsu_axi_clk  [get_bd_pins visp_ss_0/tile1_nsu_axi_clk] \
  [get_bd_pins axi_noc2_visp_ss/aclk5]
  connect_bd_net -net visp_ss_0_tile2_isp0_fusa_irq  [get_bd_pins visp_ss_0/tile2_isp0_fusa_irq] \
  [get_bd_pins tile2_isp0_fusa_irq]
  connect_bd_net -net visp_ss_0_tile2_isp0_isp_irq  [get_bd_pins visp_ss_0/tile2_isp0_isp_irq] \
  [get_bd_pins tile2_isp0_isp_irq]
  connect_bd_net -net visp_ss_0_tile2_isp1_fusa_irq  [get_bd_pins visp_ss_0/tile2_isp1_fusa_irq] \
  [get_bd_pins tile2_isp1_fusa_irq]
  connect_bd_net -net visp_ss_0_tile2_isp1_isp_irq  [get_bd_pins visp_ss_0/tile2_isp1_isp_irq] \
  [get_bd_pins tile2_isp1_isp_irq]
  connect_bd_net -net visp_ss_0_tile2_isp_isr_irq  [get_bd_pins visp_ss_0/tile2_isp_isr_irq] \
  [get_bd_pins tile2_isp_isr_irq]
  connect_bd_net -net visp_ss_0_tile2_isp_xmpu_interrupt  [get_bd_pins visp_ss_0/tile2_isp_xmpu_interrupt] \
  [get_bd_pins tile2_isp_xmpu_interrupt]
  connect_bd_net -net visp_ss_0_tile2_nmu0_axi_clk  [get_bd_pins visp_ss_0/tile2_nmu0_axi_clk] \
  [get_bd_pins axi_noc2_visp_ss/aclk6]
  connect_bd_net -net visp_ss_0_tile2_nmu1_axi_clk  [get_bd_pins visp_ss_0/tile2_nmu1_axi_clk] \
  [get_bd_pins axi_noc2_visp_ss/aclk7]
  connect_bd_net -net visp_ss_0_tile2_nsu_axi_clk  [get_bd_pins visp_ss_0/tile2_nsu_axi_clk] \
  [get_bd_pins axi_noc2_visp_ss/aclk8]

  # Restore current instance
  current_bd_instance $oldCurInst
}


proc available_tcl_procs { } {
   puts "##################################################################"
   puts "# Available Tcl procedures to recreate hierarchical blocks:"
   puts "#"
   puts "#    create_hier_cell_mipi_rx_ss_hier parentCell nameHier"
   puts "#    create_hier_cell_hier_mipi_4 parentCell nameHier"
   puts "#    create_hier_cell_hier_mipi_5 parentCell nameHier"
   puts "#    create_hier_cell_hier_mipi_0 parentCell nameHier"
   puts "#    create_hier_cell_hier_mipi_1 parentCell nameHier"
   puts "#    create_hier_cell_hier_mipi_2 parentCell nameHier"
   puts "#    create_hier_cell_hier_mipi_3 parentCell nameHier"
   puts "#"
   puts "##################################################################"
}

available_tcl_procs

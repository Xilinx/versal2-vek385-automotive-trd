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
set scripts_vivado_version 2025.2
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
xilinx.com:ip:proc_sys_reset:*\
xilinx.com:ip:axis_register_slice:*\
xilinx.com:inline_hdl:ilslice:*\
xilinx.com:ip:v_hdmi_txss1:*\
xilinx.com:inline_hdl:ilconstant:*\
xilinx.com:ip:clkx5_wiz:*\
xilinx.com:ip:axi_noc2:*\
xilinx.com:inline_hdl:ilvector_logic:*\
xilinx.com:ip:axi_gpio:*\
xilinx.com:ip:v_mix:*\
xilinx.com:ip:video_cke_sync:*\
xilinx.com:ip:smartconnect:*\
xilinx.com:ip:axi_iic:*\
xilinx.com:ip:axi_timer:*\
xilinx.com:ip:hdmi_gt_controller:*\
xilinx.com:inline_hdl:ilreduced_logic:*\
xilinx.com:inline_hdl:ilconcat:*\
xilinx.com:ip:bufg_gt:*\
xilinx.com:ip:gtwiz_versal:*\
xilinx.com:ip:util_ds_buf:*\
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


# Hierarchical cell: vfmc_ctlr_ss_0
proc create_hier_cell_vfmc_ctlr_ss_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_vfmc_ctlr_ss_0() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir O -from 0 -to 0 VFMC_TX_CH4_FRLSELn
  create_bd_pin -dir O -from 0 -to 0 VFMC_TX_LED0
  create_bd_pin -dir O -from 0 -to 0 VFMC_TX_LED1
  create_bd_pin -dir O -from 0 -to 0 VFMC_RX_CH4_FRLSELn
  create_bd_pin -dir O -from 0 -to 0 VFMC_RX_LED0
  create_bd_pin -dir O -from 0 -to 0 VFMC_RX_LED1
  create_bd_pin -dir O -from 0 -to 0 VFMC_RX_ONSEMI_ENABLE
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: vfmc_gpio, and set properties
  set vfmc_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio vfmc_gpio ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {32} \
  ] $vfmc_gpio


  # Create instance: vfmc_slice_bit0, and set properties
  set vfmc_slice_bit0 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice vfmc_slice_bit0 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {0} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {32} \
    CONFIG.DOUT_WIDTH {1} \
  ] $vfmc_slice_bit0


  # Create instance: vfmc_slice_bit1, and set properties
  set vfmc_slice_bit1 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice vfmc_slice_bit1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {32} \
    CONFIG.DOUT_WIDTH {1} \
  ] $vfmc_slice_bit1


  # Create instance: vfmc_slice_bit2, and set properties
  set vfmc_slice_bit2 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice vfmc_slice_bit2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {32} \
    CONFIG.DOUT_WIDTH {1} \
  ] $vfmc_slice_bit2


  # Create instance: vfmc_slice_bit16, and set properties
  set vfmc_slice_bit16 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice vfmc_slice_bit16 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {16} \
    CONFIG.DIN_TO {16} \
    CONFIG.DIN_WIDTH {32} \
    CONFIG.DOUT_WIDTH {1} \
  ] $vfmc_slice_bit16


  # Create instance: vfmc_slice_bit17, and set properties
  set vfmc_slice_bit17 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice vfmc_slice_bit17 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {17} \
    CONFIG.DIN_TO {17} \
    CONFIG.DIN_WIDTH {32} \
    CONFIG.DOUT_WIDTH {1} \
  ] $vfmc_slice_bit17


  # Create instance: vfmc_slice_bit18, and set properties
  set vfmc_slice_bit18 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice vfmc_slice_bit18 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {18} \
    CONFIG.DIN_TO {18} \
    CONFIG.DIN_WIDTH {32} \
    CONFIG.DOUT_WIDTH {1} \
  ] $vfmc_slice_bit18


  # Create instance: vfmc_slice_bit19, and set properties
  set vfmc_slice_bit19 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice vfmc_slice_bit19 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {19} \
    CONFIG.DIN_TO {19} \
    CONFIG.DIN_WIDTH {32} \
    CONFIG.DOUT_WIDTH {1} \
  ] $vfmc_slice_bit19


  # Create interface connections
  connect_bd_intf_net -intf_net intf_net_bdry_in_S_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins vfmc_gpio/S_AXI]

  # Create port connections
  connect_bd_net -net net_bdry_in_s_axi_aclk  [get_bd_pins s_axi_aclk] \
  [get_bd_pins vfmc_gpio/s_axi_aclk]
  connect_bd_net -net net_bdry_in_s_axi_aresetn  [get_bd_pins s_axi_aresetn] \
  [get_bd_pins vfmc_gpio/s_axi_aresetn]
  connect_bd_net -net net_vfmc_gpio_gpio_io_o  [get_bd_pins vfmc_gpio/gpio_io_o] \
  [get_bd_pins vfmc_slice_bit0/Din] \
  [get_bd_pins vfmc_slice_bit1/Din] \
  [get_bd_pins vfmc_slice_bit2/Din] \
  [get_bd_pins vfmc_slice_bit16/Din] \
  [get_bd_pins vfmc_slice_bit17/Din] \
  [get_bd_pins vfmc_slice_bit18/Din] \
  [get_bd_pins vfmc_slice_bit19/Din]
  connect_bd_net -net net_vfmc_slice_bit0_Dout  [get_bd_pins vfmc_slice_bit0/Dout] \
  [get_bd_pins VFMC_TX_LED0]
  connect_bd_net -net net_vfmc_slice_bit16_Dout  [get_bd_pins vfmc_slice_bit16/Dout] \
  [get_bd_pins VFMC_RX_LED0]
  connect_bd_net -net net_vfmc_slice_bit17_Dout  [get_bd_pins vfmc_slice_bit17/Dout] \
  [get_bd_pins VFMC_RX_LED1]
  connect_bd_net -net net_vfmc_slice_bit18_Dout  [get_bd_pins vfmc_slice_bit18/Dout] \
  [get_bd_pins VFMC_RX_CH4_FRLSELn]
  connect_bd_net -net net_vfmc_slice_bit19_Dout  [get_bd_pins vfmc_slice_bit19/Dout] \
  [get_bd_pins VFMC_RX_ONSEMI_ENABLE]
  connect_bd_net -net net_vfmc_slice_bit1_Dout  [get_bd_pins vfmc_slice_bit1/Dout] \
  [get_bd_pins VFMC_TX_LED1]
  connect_bd_net -net net_vfmc_slice_bit2_Dout  [get_bd_pins vfmc_slice_bit2/Dout] \
  [get_bd_pins VFMC_TX_CH4_FRLSELn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: gt_refclk_buf_ss_2
proc create_hier_cell_gt_refclk_buf_ss_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_gt_refclk_buf_ss_2() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 IBUFDSGT_IN


  # Create pins
  create_bd_pin -dir O -from 0 -to 0 IBUFDSGT_OUT
  create_bd_pin -dir O -from 0 -to 0 IBUFDSGT_ODIV2_OUT

  # Create instance: bufg_gt, and set properties
  set bufg_gt [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf bufg_gt ]
  set_property CONFIG.C_BUF_TYPE {BUFG_GT} $bufg_gt


  # Create instance: ibufdsgte, and set properties
  set ibufdsgte [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf ibufdsgte ]
  set_property CONFIG.C_BUF_TYPE {IBUFDSGTE} $ibufdsgte


  # Create instance: vcc_const, and set properties
  set vcc_const [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconstant vcc_const ]
  set_property CONFIG.CONST_VAL {1} $vcc_const


  # Create interface connections
  connect_bd_intf_net -intf_net intf_net_bdry_in_IBUFDSGT_IN [get_bd_intf_pins IBUFDSGT_IN] [get_bd_intf_pins ibufdsgte/CLK_IN_D]

  # Create port connections
  connect_bd_net -net net_bufg_gt_BUFG_GT_O  [get_bd_pins bufg_gt/BUFG_GT_O] \
  [get_bd_pins IBUFDSGT_ODIV2_OUT]
  connect_bd_net -net net_ibufdsgte_IBUF_DS_ODIV2  [get_bd_pins ibufdsgte/IBUF_DS_ODIV2] \
  [get_bd_pins bufg_gt/BUFG_GT_I]
  connect_bd_net -net net_ibufdsgte_IBUF_OUT  [get_bd_pins ibufdsgte/IBUF_OUT] \
  [get_bd_pins IBUFDSGT_OUT]
  connect_bd_net -net net_vcc_const_dout  [get_bd_pins vcc_const/dout] \
  [get_bd_pins bufg_gt/BUFG_GT_CE]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: gt_refclk_buf_ss_1
proc create_hier_cell_gt_refclk_buf_ss_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_gt_refclk_buf_ss_1() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 IBUFDSGT_IN


  # Create pins
  create_bd_pin -dir O -from 0 -to 0 IBUFDSGT_OUT
  create_bd_pin -dir O -from 0 -to 0 IBUFDSGT_ODIV2_OUT

  # Create instance: bufg_gt, and set properties
  set bufg_gt [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf bufg_gt ]
  set_property CONFIG.C_BUF_TYPE {BUFG_GT} $bufg_gt


  # Create instance: ibufdsgte, and set properties
  set ibufdsgte [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf ibufdsgte ]
  set_property CONFIG.C_BUF_TYPE {IBUFDSGTE} $ibufdsgte


  # Create instance: vcc_const, and set properties
  set vcc_const [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconstant vcc_const ]
  set_property CONFIG.CONST_VAL {1} $vcc_const


  # Create interface connections
  connect_bd_intf_net -intf_net intf_net_bdry_in_IBUFDSGT_IN [get_bd_intf_pins IBUFDSGT_IN] [get_bd_intf_pins ibufdsgte/CLK_IN_D]

  # Create port connections
  connect_bd_net -net net_bufg_gt_BUFG_GT_O  [get_bd_pins bufg_gt/BUFG_GT_O] \
  [get_bd_pins IBUFDSGT_ODIV2_OUT]
  connect_bd_net -net net_ibufdsgte_IBUF_DS_ODIV2  [get_bd_pins ibufdsgte/IBUF_DS_ODIV2] \
  [get_bd_pins bufg_gt/BUFG_GT_I]
  connect_bd_net -net net_ibufdsgte_IBUF_OUT  [get_bd_pins ibufdsgte/IBUF_OUT] \
  [get_bd_pins IBUFDSGT_OUT]
  connect_bd_net -net net_vcc_const_dout  [get_bd_pins vcc_const/dout] \
  [get_bd_pins bufg_gt/BUFG_GT_CE]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: gt_refclk_buf_ss_0
proc create_hier_cell_gt_refclk_buf_ss_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_gt_refclk_buf_ss_0() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 IBUFDSGT_IN


  # Create pins
  create_bd_pin -dir O -from 0 -to 0 IBUFDSGT_OUT
  create_bd_pin -dir O -from 0 -to 0 IBUFDSGT_ODIV2_OUT

  # Create instance: bufg_gt, and set properties
  set bufg_gt [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf bufg_gt ]
  set_property CONFIG.C_BUF_TYPE {BUFG_GT} $bufg_gt


  # Create instance: ibufdsgte, and set properties
  set ibufdsgte [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf ibufdsgte ]
  set_property CONFIG.C_BUF_TYPE {IBUFDSGTE} $ibufdsgte


  # Create instance: vcc_const, and set properties
  set vcc_const [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconstant vcc_const ]
  set_property CONFIG.CONST_VAL {1} $vcc_const


  # Create interface connections
  connect_bd_intf_net -intf_net intf_net_bdry_in_IBUFDSGT_IN [get_bd_intf_pins IBUFDSGT_IN] [get_bd_intf_pins ibufdsgte/CLK_IN_D]

  # Create port connections
  connect_bd_net -net net_bufg_gt_BUFG_GT_O  [get_bd_pins bufg_gt/BUFG_GT_O] \
  [get_bd_pins IBUFDSGT_ODIV2_OUT]
  connect_bd_net -net net_ibufdsgte_IBUF_DS_ODIV2  [get_bd_pins ibufdsgte/IBUF_DS_ODIV2] \
  [get_bd_pins bufg_gt/BUFG_GT_I]
  connect_bd_net -net net_ibufdsgte_IBUF_OUT  [get_bd_pins ibufdsgte/IBUF_OUT] \
  [get_bd_pins IBUFDSGT_OUT]
  connect_bd_net -net net_vcc_const_dout  [get_bd_pins vcc_const/dout] \
  [get_bd_pins bufg_gt/BUFG_GT_CE]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hdmiphy_ss_0
proc create_hier_cell_hdmiphy_ss_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hdmiphy_ss_0() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 phy_data

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_rx_axi4s_ch0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_rx_axi4s_ch1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_rx_axi4s_ch2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_tx_axi4s_ch0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_tx_axi4s_ch1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_tx_axi4s_ch2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_tx_axi4s_ch3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_rx_axi4s_ch3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 vid_phy_axi4lite

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_status_sb_rx

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_status_sb_tx


  # Create pins
  create_bd_pin -dir I -type clk tx_ref_clk_in
  create_bd_pin -dir I -type clk tx_ref_clk_odiv2_in
  create_bd_pin -dir I -type clk rx_ref_clk_in
  create_bd_pin -dir I -type clk rx_ref_clk_odiv2_in
  create_bd_pin -dir I tx_refclk_rdy
  create_bd_pin -dir I -type clk vid_phy_axi4lite_aclk
  create_bd_pin -dir I -type rst vid_phy_axi4lite_aresetn
  create_bd_pin -dir I -type clk drpclk
  create_bd_pin -dir I -type clk vid_phy_sb_aclk
  create_bd_pin -dir I -type rst vid_phy_sb_aresetn
  create_bd_pin -dir I -type rst vid_phy_rx_axi4s_aresetn
  create_bd_pin -dir I -type rst vid_phy_tx_axi4s_aresetn
  create_bd_pin -dir O -type clk tx_tmds_clk
  create_bd_pin -dir O -type clk tx_video_clk
  create_bd_pin -dir O -type clk rx_tmds_clk
  create_bd_pin -dir O -type clk rx_tmds_clk_p
  create_bd_pin -dir O -type clk rx_tmds_clk_n
  create_bd_pin -dir O -type clk rx_video_clk
  create_bd_pin -dir O -type gt_usrclk txoutclk
  create_bd_pin -dir O -type gt_usrclk rxoutclk
  create_bd_pin -dir O irq
  create_bd_pin -dir I -type clk dru_ref_clk_in
  create_bd_pin -dir I -type clk dru_ref_clk_odiv2_in

  # Create instance: hdmi_gt_controller, and set properties
  set hdmi_gt_controller [ create_bd_cell -type ip -vlnv xilinx.com:ip:hdmi_gt_controller hdmi_gt_controller ]
  set_property -dict [list \
    CONFIG.C_NEW_WIZ {1} \
    CONFIG.C_NIDRU {true} \
    CONFIG.C_NIDRU_REFCLK_SEL {5} \
    CONFIG.C_RX_FRL_REFCLK_SEL {5} \
    CONFIG.C_RX_PLL_SELECTION {8} \
    CONFIG.C_RX_REFCLK_SEL {0} \
    CONFIG.C_Rx_Protocol {HDMI 2.1} \
    CONFIG.C_TX_FRL_REFCLK_SEL {5} \
    CONFIG.C_TX_PLL_SELECTION {7} \
    CONFIG.C_TX_REFCLK_SEL {1} \
    CONFIG.C_Tx_Protocol {HDMI 2.1} \
    CONFIG.C_Txrefclk_Rdy_Invert {true} \
    CONFIG.Rx_GT_Line_Rate {12.0} \
    CONFIG.Rx_GT_Ref_Clock_Freq {400} \
    CONFIG.Rx_Max_GT_Line_Rate {12.0} \
    CONFIG.Tx_GT_Line_Rate {12.0} \
    CONFIG.Tx_GT_Ref_Clock_Freq {400} \
    CONFIG.Tx_Max_GT_Line_Rate {12.0} \
    CONFIG.check_refclk_selection {0} \
  ] $hdmi_gt_controller


  # Create instance: urlp, and set properties
  set urlp [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilreduced_logic urlp ]
  set_property CONFIG.C_SIZE {1} $urlp


  # Create instance: xlcp, and set properties
  set xlcp [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconcat xlcp ]
  set_property CONFIG.NUM_PORTS {1} $xlcp


  # Create instance: bufg_gt_rx, and set properties
  set bufg_gt_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt bufg_gt_rx ]
  set_property CONFIG.FREQ_HZ {297000000.0} $bufg_gt_rx


  # Create instance: bufg_gt_tx, and set properties
  set bufg_gt_tx [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt bufg_gt_tx ]
  set_property CONFIG.FREQ_HZ {297000000.0} $bufg_gt_tx


  # Create instance: gtwiz_versal, and set properties
  set gtwiz_versal [ create_bd_cell -type ip -vlnv xilinx.com:ip:gtwiz_versal gtwiz_versal ]
  set_property -dict [list \
    CONFIG.INTF0_GT_DIRECTION {SIMPLEX_TX} \
    CONFIG.INTF0_GT_SETTINGS(GT_DIRECTION) {SIMPLEX_TX} \
    CONFIG.INTF0_GT_SETTINGS(GT_TYPE) {GTYP} \
    CONFIG.INTF0_GT_SETTINGS(LR0_SETTINGS) {PRESET None GT_DIRECTION SIMPLEX_TX TX_PLL_TYPE LCPLL TX_DATA_ENCODING RAW TX_BUFFER_MODE 1 TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE\
LCPLL TX_LANE_DESKEW_HDMI_ENABLE true TX_REFCLK_SOURCE R5 TX_USER_DATA_WIDTH 20 TX_INT_DATA_WIDTH 20 TX_LINE_RATE 2.5 TX_REFCLK_FREQUENCY 400.00} \
    CONFIG.INTF0_GT_SETTINGS(LR1_SETTINGS) {PRESET None GT_DIRECTION SIMPLEX_TX TX_PLL_TYPE LCPLL TX_DATA_ENCODING RAW TX_BUFFER_MODE 1 TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE\
LCPLL TX_LANE_DESKEW_HDMI_ENABLE true TX_REFCLK_SOURCE R1 TX_USER_DATA_WIDTH 40 TX_INT_DATA_WIDTH 40 TX_LINE_RATE 1.625 TX_REFCLK_FREQUENCY 162.5} \
    CONFIG.INTF0_GT_SETTINGS(LR2_SETTINGS) {PRESET None GT_DIRECTION SIMPLEX_TX TX_PLL_TYPE LCPLL TX_DATA_ENCODING RAW TX_BUFFER_MODE 1 TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE\
LCPLL TX_LANE_DESKEW_HDMI_ENABLE true TX_REFCLK_SOURCE R1 TX_USER_DATA_WIDTH 40 TX_INT_DATA_WIDTH 40 TX_LINE_RATE 2.485 TX_REFCLK_FREQUENCY 248.5} \
    CONFIG.INTF0_GT_SETTINGS(LR3_SETTINGS) {PRESET None GT_DIRECTION SIMPLEX_TX TX_PLL_TYPE LCPLL TX_DATA_ENCODING RAW TX_BUFFER_MODE 1 TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE\
LCPLL TX_LANE_DESKEW_HDMI_ENABLE true TX_REFCLK_SOURCE R1 TX_USER_DATA_WIDTH 40 TX_INT_DATA_WIDTH 40 TX_LINE_RATE 3.700 TX_REFCLK_FREQUENCY 92.5} \
    CONFIG.INTF0_GT_SETTINGS(LR4_SETTINGS) {PRESET None GT_DIRECTION SIMPLEX_TX TX_PLL_TYPE LCPLL TX_DATA_ENCODING RAW TX_BUFFER_MODE 1 TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE\
LCPLL TX_LANE_DESKEW_HDMI_ENABLE true TX_REFCLK_SOURCE R1 TX_USER_DATA_WIDTH 40 TX_INT_DATA_WIDTH 40 TX_LINE_RATE 5.94 TX_REFCLK_FREQUENCY 148.5} \
    CONFIG.INTF0_GT_SETTINGS(LR5_SETTINGS) {PRESET None GT_DIRECTION SIMPLEX_TX TX_PLL_TYPE LCPLL TX_DATA_ENCODING RAW TX_BUFFER_MODE 1 TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE\
LCPLL TX_LANE_DESKEW_HDMI_ENABLE true TX_REFCLK_SOURCE R5 TX_USER_DATA_WIDTH 40 TX_INT_DATA_WIDTH 40 TX_LINE_RATE 3.0 TX_REFCLK_FREQUENCY 400.0} \
    CONFIG.INTF0_GT_SETTINGS(LR6_SETTINGS) {PRESET None GT_DIRECTION SIMPLEX_TX TX_PLL_TYPE LCPLL TX_DATA_ENCODING RAW TX_BUFFER_MODE 1 TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE\
LCPLL TX_LANE_DESKEW_HDMI_ENABLE true TX_REFCLK_SOURCE R5 TX_USER_DATA_WIDTH 40 TX_INT_DATA_WIDTH 40 TX_LINE_RATE 6.0 TX_REFCLK_FREQUENCY 400.0} \
    CONFIG.INTF0_GT_SETTINGS(LR7_SETTINGS) {PRESET None GT_DIRECTION SIMPLEX_TX TX_PLL_TYPE LCPLL TX_DATA_ENCODING RAW TX_BUFFER_MODE 1 TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE\
LCPLL TX_LANE_DESKEW_HDMI_ENABLE true TX_REFCLK_SOURCE R5 TX_USER_DATA_WIDTH 40 TX_INT_DATA_WIDTH 40 TX_LINE_RATE 8.0 TX_REFCLK_FREQUENCY 400.0} \
    CONFIG.INTF0_GT_SETTINGS(LR8_SETTINGS) {PRESET None GT_DIRECTION SIMPLEX_TX TX_PLL_TYPE LCPLL TX_DATA_ENCODING RAW TX_BUFFER_MODE 1 TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE\
LCPLL TX_LANE_DESKEW_HDMI_ENABLE true TX_REFCLK_SOURCE R5 TX_USER_DATA_WIDTH 40 TX_INT_DATA_WIDTH 40 TX_LINE_RATE 10.0 TX_REFCLK_FREQUENCY 400.0} \
    CONFIG.INTF0_GT_SETTINGS(LR9_SETTINGS) {PRESET None GT_DIRECTION SIMPLEX_TX TX_PLL_TYPE LCPLL TX_DATA_ENCODING RAW TX_BUFFER_MODE 1 TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE\
LCPLL TX_LANE_DESKEW_HDMI_ENABLE true TX_REFCLK_SOURCE R5 TX_USER_DATA_WIDTH 40 TX_INT_DATA_WIDTH 40 TX_LINE_RATE 12.0 TX_REFCLK_FREQUENCY 400.0} \
    CONFIG.INTF0_PARENTID {design_1_hdmi_gt_controller_0} \
    CONFIG.INTF1_GT_DIRECTION {SIMPLEX_RX} \
    CONFIG.INTF1_GT_SETTINGS(GT_DIRECTION) {SIMPLEX_RX} \
    CONFIG.INTF1_GT_SETTINGS(GT_TYPE) {GTYP} \
    CONFIG.INTF1_GT_SETTINGS(LR0_SETTINGS) {PRESET None GT_DIRECTION SIMPLEX_RX RX_PLL_TYPE RPLL RX_DATA_DECODING RAW RX_BUFFER_MODE 1 RX_REFCLK_SOURCE R5 RX_USER_DATA_WIDTH 20 RX_INT_DATA_WIDTH 20 RX_LINE_RATE\
2.5 RX_REFCLK_FREQUENCY 400.00 RX_EQ_MODE LPM} \
    CONFIG.INTF1_GT_SETTINGS(LR1_SETTINGS) {PRESET None GT_DIRECTION SIMPLEX_RX RX_PLL_TYPE RPLL RX_DATA_DECODING RAW RX_BUFFER_MODE 1 RX_REFCLK_SOURCE R0 RX_USER_DATA_WIDTH 40 RX_INT_DATA_WIDTH 40 RX_LINE_RATE\
1.625 RX_REFCLK_FREQUENCY 162.5 RX_EQ_MODE LPM} \
    CONFIG.INTF1_GT_SETTINGS(LR2_SETTINGS) {PRESET None GT_DIRECTION SIMPLEX_RX RX_PLL_TYPE RPLL RX_DATA_DECODING RAW RX_BUFFER_MODE 1 RX_REFCLK_SOURCE R0 RX_USER_DATA_WIDTH 40 RX_INT_DATA_WIDTH 40 RX_LINE_RATE\
2.485 RX_REFCLK_FREQUENCY 248.5 RX_EQ_MODE LPM} \
    CONFIG.INTF1_GT_SETTINGS(LR3_SETTINGS) {PRESET None GT_DIRECTION SIMPLEX_RX RX_PLL_TYPE RPLL RX_DATA_DECODING RAW RX_BUFFER_MODE 1 RX_REFCLK_SOURCE R0 RX_USER_DATA_WIDTH 40 RX_INT_DATA_WIDTH 40 RX_LINE_RATE\
3.700 RX_REFCLK_FREQUENCY 92.5 RX_EQ_MODE LPM} \
    CONFIG.INTF1_GT_SETTINGS(LR4_SETTINGS) {PRESET None GT_DIRECTION SIMPLEX_RX RX_PLL_TYPE RPLL RX_DATA_DECODING RAW RX_BUFFER_MODE 1 RX_REFCLK_SOURCE R0 RX_USER_DATA_WIDTH 40 RX_INT_DATA_WIDTH 40 RX_LINE_RATE\
5.94 RX_REFCLK_FREQUENCY 148.5 RX_EQ_MODE LPM} \
    CONFIG.INTF1_GT_SETTINGS(LR5_SETTINGS) {PRESET None GT_DIRECTION SIMPLEX_RX RX_PLL_TYPE RPLL RX_DATA_DECODING RAW RX_BUFFER_MODE 1 RX_REFCLK_SOURCE R5 RX_USER_DATA_WIDTH 40 RX_INT_DATA_WIDTH 40 RX_LINE_RATE\
3.0 RX_REFCLK_FREQUENCY 400.0 RX_EQ_MODE LPM} \
    CONFIG.INTF1_GT_SETTINGS(LR6_SETTINGS) {PRESET None GT_DIRECTION SIMPLEX_RX RX_PLL_TYPE RPLL RX_DATA_DECODING RAW RX_BUFFER_MODE 1 RX_REFCLK_SOURCE R5 RX_USER_DATA_WIDTH 40 RX_INT_DATA_WIDTH 40 RX_LINE_RATE\
6.0 RX_REFCLK_FREQUENCY 400.0 RX_EQ_MODE LPM} \
    CONFIG.INTF1_GT_SETTINGS(LR7_SETTINGS) {PRESET None GT_DIRECTION SIMPLEX_RX RX_PLL_TYPE RPLL RX_DATA_DECODING RAW RX_BUFFER_MODE 1 RX_REFCLK_SOURCE R5 RX_USER_DATA_WIDTH 40 RX_INT_DATA_WIDTH 40 RX_LINE_RATE\
8.0 RX_REFCLK_FREQUENCY 400.0 RX_EQ_MODE LPM} \
    CONFIG.INTF1_GT_SETTINGS(LR8_SETTINGS) {PRESET None GT_DIRECTION SIMPLEX_RX RX_PLL_TYPE RPLL RX_DATA_DECODING RAW RX_BUFFER_MODE 1 RX_REFCLK_SOURCE R5 RX_USER_DATA_WIDTH 40 RX_INT_DATA_WIDTH 40 RX_LINE_RATE\
10.0 RX_REFCLK_FREQUENCY 400.0 RX_EQ_MODE LPM} \
    CONFIG.INTF1_GT_SETTINGS(LR9_SETTINGS) {PRESET None GT_DIRECTION SIMPLEX_RX RX_PLL_TYPE RPLL RX_DATA_DECODING RAW RX_BUFFER_MODE 1 RX_REFCLK_SOURCE R5 RX_USER_DATA_WIDTH 40 RX_INT_DATA_WIDTH 40 RX_LINE_RATE\
12.0 RX_REFCLK_FREQUENCY 400.0 RX_EQ_MODE DFE} \
    CONFIG.INTF1_NO_OF_LANES {4} \
    CONFIG.INTF1_PARENTID {design_1_hdmi_gt_controller_0} \
    CONFIG.INTF_PARENT_PIN_LIST {QUAD0_TX0 /Mixer_HDMI_Hier/hdmiphy_ss_0/hdmi_gt_controller/gt_tx0 QUAD0_TX1 /Mixer_HDMI_Hier/hdmiphy_ss_0/hdmi_gt_controller/gt_tx1 QUAD0_TX2 /Mixer_HDMI_Hier/hdmiphy_ss_0/hdmi_gt_controller/gt_tx2\
QUAD0_TX3 /Mixer_HDMI_Hier/hdmiphy_ss_0/hdmi_gt_controller/gt_tx3 QUAD0_RX0 /Mixer_HDMI_Hier/hdmiphy_ss_0/hdmi_gt_controller/gt_rx0 QUAD0_RX1 /Mixer_HDMI_Hier/hdmiphy_ss_0/hdmi_gt_controller/gt_rx1 QUAD0_RX2\
/Mixer_HDMI_Hier/hdmiphy_ss_0/hdmi_gt_controller/gt_rx2 QUAD0_RX3 /Mixer_HDMI_Hier/hdmiphy_ss_0/hdmi_gt_controller/gt_rx3} \
    CONFIG.NO_OF_INTERFACE {2} \
    CONFIG.QUAD0_CH0_DEBUG_EN {true} \
    CONFIG.QUAD0_CH0_ILORESETDONE_EN {true} \
    CONFIG.QUAD0_CH0_PHYREADY_EN {true} \
    CONFIG.QUAD0_CH1_DEBUG_EN {true} \
    CONFIG.QUAD0_CH1_ILORESETDONE_EN {true} \
    CONFIG.QUAD0_CH1_PHYREADY_EN {true} \
    CONFIG.QUAD0_CH2_DEBUG_EN {true} \
    CONFIG.QUAD0_CH2_ILORESETDONE_EN {true} \
    CONFIG.QUAD0_CH2_PHYREADY_EN {true} \
    CONFIG.QUAD0_CH3_DEBUG_EN {true} \
    CONFIG.QUAD0_CH3_ILORESETDONE_EN {true} \
    CONFIG.QUAD0_CH3_PHYREADY_EN {true} \
    CONFIG.QUAD0_GT_DEBUG_EN {true} \
    CONFIG.QUAD0_HSCLK0_LCPLLRESET_EN {true} \
    CONFIG.QUAD0_HSCLK0_LCPLL_LOCK_EN {true} \
    CONFIG.QUAD0_HSCLK0_RPLLRESET_EN {true} \
    CONFIG.QUAD0_HSCLK0_RPLL_LOCK_EN {true} \
    CONFIG.QUAD0_HSCLK1_LCPLLRESET_EN {true} \
    CONFIG.QUAD0_HSCLK1_LCPLL_LOCK_EN {true} \
    CONFIG.QUAD0_HSCLK1_RPLLRESET_EN {true} \
    CONFIG.QUAD0_HSCLK1_RPLL_LOCK_EN {true} \
    CONFIG.QUAD0_NO_PROT {2} \
    CONFIG.QUAD0_OUTCLK_VALUES {CH0_TXOUTCLK 300.000 CH0_RXOUTCLK 300.000000 CH1_TXOUTCLK 300.000 CH1_RXOUTCLK 300.000000 CH2_TXOUTCLK 300.000 CH2_RXOUTCLK 300.000000 CH3_TXOUTCLK 300.000 CH3_RXOUTCLK\
300.000000} \
    CONFIG.QUAD0_PROT0_TX1_EN {true} \
    CONFIG.QUAD0_PROT0_TX2_EN {true} \
    CONFIG.QUAD0_PROT0_TX3_EN {true} \
    CONFIG.QUAD0_PROT1 {INTF1} \
    CONFIG.QUAD0_PROT1_LANES {4} \
    CONFIG.QUAD0_PROT1_RX0_EN {true} \
    CONFIG.QUAD0_PROT1_RX1_EN {true} \
    CONFIG.QUAD0_PROT1_RX2_EN {true} \
    CONFIG.QUAD0_PROT1_RX3_EN {true} \
    CONFIG.QUAD0_PROT1_RXMSTCLK {RX0} \
    CONFIG.QUAD0_REFCLK_STRING {HSCLK0_LCPLLGTREFCLK1 refclk_PROT0_R1_multiple_ext_freq HSCLK0_LCPLLSOUTHREFCLK1 refclk_PROT0_R5_400_MHz_unique1 HSCLK0_RPLLGTREFCLK0 refclk_PROT1_R0_multiple_ext_freq HSCLK0_RPLLSOUTHREFCLK1\
refclk_PROT1_R5_400_MHz_unique1 HSCLK1_LCPLLGTREFCLK1 refclk_PROT0_R1_multiple_ext_freq HSCLK1_LCPLLSOUTHREFCLK1 refclk_PROT0_R5_400_MHz_unique1 HSCLK1_RPLLGTREFCLK0 refclk_PROT1_R0_multiple_ext_freq HSCLK1_RPLLSOUTHREFCLK1\
refclk_PROT1_R5_400_MHz_unique1} \
    CONFIG.QUAD0_USAGE {TX_QUAD_CH {TXQuad_0_/design_1_gtwiz_versal_0/design_1_gtwiz_versal_0_gt_quad_base_0 {/design_1_gtwiz_versal_0/design_1_gtwiz_versal_0_gt_quad_base_0 design_1_hdmi_gt_controller_0.IP_CH0,design_1_hdmi_gt_controller_0.IP_CH1,design_1_hdmi_gt_controller_0.IP_CH2,design_1_hdmi_gt_controller_0.IP_CH3\
MSTRCLK 1,0,0,0 IS_CURRENT_QUAD 1}} RX_QUAD_CH {RXQuad_0_/design_1_gtwiz_versal_0/design_1_gtwiz_versal_0_gt_quad_base_0 {/design_1_gtwiz_versal_0/design_1_gtwiz_versal_0_gt_quad_base_0 design_1_hdmi_gt_controller_0.IP_CH0,design_1_hdmi_gt_controller_0.IP_CH1,design_1_hdmi_gt_controller_0.IP_CH2,design_1_hdmi_gt_controller_0.IP_CH3\
MSTRCLK 1,0,0,0 IS_CURRENT_QUAD 1}}} \
  ] $gtwiz_versal

  set_property -dict [list \
    CONFIG.INTF0_GT_SETTINGS.VALUE_MODE {auto} \
    CONFIG.INTF0_PARENTID.VALUE_MODE {auto} \
    CONFIG.INTF1_GT_SETTINGS.VALUE_MODE {auto} \
    CONFIG.INTF1_PARENTID.VALUE_MODE {auto} \
    CONFIG.INTF_PARENT_PIN_LIST.VALUE_MODE {auto} \
    CONFIG.QUAD0_USAGE.VALUE_MODE {auto} \
  ] $gtwiz_versal


  # Create interface connections
  connect_bd_intf_net -intf_net intf_net_bdry_in_vid_phy_axi4lite [get_bd_intf_pins vid_phy_axi4lite] [get_bd_intf_pins hdmi_gt_controller/axi4lite]
  connect_bd_intf_net -intf_net intf_net_bdry_in_vid_phy_tx_axi4s_ch0 [get_bd_intf_pins vid_phy_tx_axi4s_ch0] [get_bd_intf_pins hdmi_gt_controller/tx_axi4s_ch0]
  connect_bd_intf_net -intf_net intf_net_bdry_in_vid_phy_tx_axi4s_ch1 [get_bd_intf_pins vid_phy_tx_axi4s_ch1] [get_bd_intf_pins hdmi_gt_controller/tx_axi4s_ch1]
  connect_bd_intf_net -intf_net intf_net_bdry_in_vid_phy_tx_axi4s_ch2 [get_bd_intf_pins vid_phy_tx_axi4s_ch2] [get_bd_intf_pins hdmi_gt_controller/tx_axi4s_ch2]
  connect_bd_intf_net -intf_net intf_net_bdry_in_vid_phy_tx_axi4s_ch3 [get_bd_intf_pins vid_phy_tx_axi4s_ch3] [get_bd_intf_pins hdmi_gt_controller/tx_axi4s_ch3]
  connect_bd_intf_net -intf_net intf_net_gtwiz_versal_Quad0_GT_Serial [get_bd_intf_pins gtwiz_versal/Quad0_GT_Serial] [get_bd_intf_pins phy_data]
  connect_bd_intf_net -intf_net intf_net_hdmi_gt_controller_ch0_debug [get_bd_intf_pins hdmi_gt_controller/ch0_debug] [get_bd_intf_pins gtwiz_versal/Quad0_CH0_DEBUG]
  connect_bd_intf_net -intf_net intf_net_hdmi_gt_controller_ch1_debug [get_bd_intf_pins hdmi_gt_controller/ch1_debug] [get_bd_intf_pins gtwiz_versal/Quad0_CH1_DEBUG]
  connect_bd_intf_net -intf_net intf_net_hdmi_gt_controller_ch2_debug [get_bd_intf_pins hdmi_gt_controller/ch2_debug] [get_bd_intf_pins gtwiz_versal/Quad0_CH2_DEBUG]
  connect_bd_intf_net -intf_net intf_net_hdmi_gt_controller_ch3_debug [get_bd_intf_pins hdmi_gt_controller/ch3_debug] [get_bd_intf_pins gtwiz_versal/Quad0_CH3_DEBUG]
  connect_bd_intf_net -intf_net intf_net_hdmi_gt_controller_gt_debug [get_bd_intf_pins hdmi_gt_controller/gt_debug] [get_bd_intf_pins gtwiz_versal/QUAD0_GT_DEBUG]
  connect_bd_intf_net -intf_net intf_net_hdmi_gt_controller_gt_rx0 [get_bd_intf_pins hdmi_gt_controller/gt_rx0] [get_bd_intf_pins gtwiz_versal/INTF1_RX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net intf_net_hdmi_gt_controller_gt_rx1 [get_bd_intf_pins hdmi_gt_controller/gt_rx1] [get_bd_intf_pins gtwiz_versal/INTF1_RX1_GT_IP_Interface]
  connect_bd_intf_net -intf_net intf_net_hdmi_gt_controller_gt_rx2 [get_bd_intf_pins hdmi_gt_controller/gt_rx2] [get_bd_intf_pins gtwiz_versal/INTF1_RX2_GT_IP_Interface]
  connect_bd_intf_net -intf_net intf_net_hdmi_gt_controller_gt_rx3 [get_bd_intf_pins hdmi_gt_controller/gt_rx3] [get_bd_intf_pins gtwiz_versal/INTF1_RX3_GT_IP_Interface]
  connect_bd_intf_net -intf_net intf_net_hdmi_gt_controller_gt_tx0 [get_bd_intf_pins hdmi_gt_controller/gt_tx0] [get_bd_intf_pins gtwiz_versal/INTF0_TX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net intf_net_hdmi_gt_controller_gt_tx1 [get_bd_intf_pins hdmi_gt_controller/gt_tx1] [get_bd_intf_pins gtwiz_versal/INTF0_TX1_GT_IP_Interface]
  connect_bd_intf_net -intf_net intf_net_hdmi_gt_controller_gt_tx2 [get_bd_intf_pins hdmi_gt_controller/gt_tx2] [get_bd_intf_pins gtwiz_versal/INTF0_TX2_GT_IP_Interface]
  connect_bd_intf_net -intf_net intf_net_hdmi_gt_controller_gt_tx3 [get_bd_intf_pins hdmi_gt_controller/gt_tx3] [get_bd_intf_pins gtwiz_versal/INTF0_TX3_GT_IP_Interface]
  connect_bd_intf_net -intf_net intf_net_hdmi_gt_controller_rx_axi4s_ch0 [get_bd_intf_pins hdmi_gt_controller/rx_axi4s_ch0] [get_bd_intf_pins vid_phy_rx_axi4s_ch0]
  connect_bd_intf_net -intf_net intf_net_hdmi_gt_controller_rx_axi4s_ch1 [get_bd_intf_pins hdmi_gt_controller/rx_axi4s_ch1] [get_bd_intf_pins vid_phy_rx_axi4s_ch1]
  connect_bd_intf_net -intf_net intf_net_hdmi_gt_controller_rx_axi4s_ch2 [get_bd_intf_pins hdmi_gt_controller/rx_axi4s_ch2] [get_bd_intf_pins vid_phy_rx_axi4s_ch2]
  connect_bd_intf_net -intf_net intf_net_hdmi_gt_controller_rx_axi4s_ch3 [get_bd_intf_pins hdmi_gt_controller/rx_axi4s_ch3] [get_bd_intf_pins vid_phy_rx_axi4s_ch3]
  connect_bd_intf_net -intf_net intf_net_hdmi_gt_controller_status_sb_rx [get_bd_intf_pins hdmi_gt_controller/status_sb_rx] [get_bd_intf_pins vid_phy_status_sb_rx]
  connect_bd_intf_net -intf_net intf_net_hdmi_gt_controller_status_sb_tx [get_bd_intf_pins hdmi_gt_controller/status_sb_tx] [get_bd_intf_pins vid_phy_status_sb_tx]

  # Create port connections
  connect_bd_net -net net_bdry_in_drpclk  [get_bd_pins drpclk] \
  [get_bd_pins gtwiz_versal/gtwiz_freerun_clk] \
  [get_bd_pins hdmi_gt_controller/apb_clk]
  connect_bd_net -net net_bdry_in_dru_ref_clk_in  [get_bd_pins dru_ref_clk_in] \
  [get_bd_pins gtwiz_versal/QUAD0_GTREFCLK1] \
  [get_bd_pins gtwiz_versal/QUAD0_GTREFCLK3]
  connect_bd_net -net net_bdry_in_dru_ref_clk_odiv2_in  [get_bd_pins dru_ref_clk_odiv2_in] \
  [get_bd_pins hdmi_gt_controller/gt_refclk5_odiv2]
  connect_bd_net -net net_bdry_in_rx_ref_clk_in  [get_bd_pins rx_ref_clk_in] \
  [get_bd_pins gtwiz_versal/QUAD0_GTREFCLK2]
  connect_bd_net -net net_bdry_in_rx_ref_clk_odiv2_in  [get_bd_pins rx_ref_clk_odiv2_in] \
  [get_bd_pins hdmi_gt_controller/gt_refclk0_odiv2]
  connect_bd_net -net net_bdry_in_tx_ref_clk_in  [get_bd_pins tx_ref_clk_in] \
  [get_bd_pins gtwiz_versal/QUAD0_GTREFCLK0]
  connect_bd_net -net net_bdry_in_tx_ref_clk_odiv2_in  [get_bd_pins tx_ref_clk_odiv2_in] \
  [get_bd_pins hdmi_gt_controller/gt_refclk1_odiv2]
  connect_bd_net -net net_bdry_in_tx_refclk_rdy  [get_bd_pins tx_refclk_rdy] \
  [get_bd_pins hdmi_gt_controller/tx_refclk_rdy]
  connect_bd_net -net net_bdry_in_vid_phy_axi4lite_aclk  [get_bd_pins vid_phy_axi4lite_aclk] \
  [get_bd_pins hdmi_gt_controller/axi4lite_aclk]
  connect_bd_net -net net_bdry_in_vid_phy_axi4lite_aresetn  [get_bd_pins vid_phy_axi4lite_aresetn] \
  [get_bd_pins hdmi_gt_controller/axi4lite_aresetn]
  connect_bd_net -net net_bdry_in_vid_phy_rx_axi4s_aresetn  [get_bd_pins vid_phy_rx_axi4s_aresetn] \
  [get_bd_pins hdmi_gt_controller/rx_axi4s_aresetn]
  connect_bd_net -net net_bdry_in_vid_phy_sb_aclk  [get_bd_pins vid_phy_sb_aclk] \
  [get_bd_pins hdmi_gt_controller/sb_aclk]
  connect_bd_net -net net_bdry_in_vid_phy_sb_aresetn  [get_bd_pins vid_phy_sb_aresetn] \
  [get_bd_pins hdmi_gt_controller/sb_aresetn]
  connect_bd_net -net net_bdry_in_vid_phy_tx_axi4s_aresetn  [get_bd_pins vid_phy_tx_axi4s_aresetn] \
  [get_bd_pins hdmi_gt_controller/tx_axi4s_aresetn]
  connect_bd_net -net net_bufg_gt_rx_usrclk  [get_bd_pins bufg_gt_rx/usrclk] \
  [get_bd_pins rxoutclk] \
  [get_bd_pins gtwiz_versal/QUAD0_RX0_usrclk] \
  [get_bd_pins gtwiz_versal/QUAD0_RX1_usrclk] \
  [get_bd_pins gtwiz_versal/QUAD0_RX2_usrclk] \
  [get_bd_pins gtwiz_versal/QUAD0_RX3_usrclk] \
  [get_bd_pins hdmi_gt_controller/gt_rxusrclk] \
  [get_bd_pins hdmi_gt_controller/rx_axi4s_aclk]
  connect_bd_net -net net_bufg_gt_tx_usrclk  [get_bd_pins bufg_gt_tx/usrclk] \
  [get_bd_pins txoutclk] \
  [get_bd_pins gtwiz_versal/QUAD0_TX0_usrclk] \
  [get_bd_pins gtwiz_versal/QUAD0_TX1_usrclk] \
  [get_bd_pins gtwiz_versal/QUAD0_TX2_usrclk] \
  [get_bd_pins gtwiz_versal/QUAD0_TX3_usrclk] \
  [get_bd_pins hdmi_gt_controller/gt_txusrclk] \
  [get_bd_pins hdmi_gt_controller/tx_axi4s_aclk]
  connect_bd_net -net net_gtwiz_versal_INTF0_rst_tx_done_out  [get_bd_pins gtwiz_versal/INTF0_rst_tx_done_out] \
  [get_bd_pins hdmi_gt_controller/tx_full_rst_done]
  connect_bd_net -net net_gtwiz_versal_INTF1_rst_rx_done_out  [get_bd_pins gtwiz_versal/INTF1_rst_rx_done_out] \
  [get_bd_pins hdmi_gt_controller/rx_full_rst_done]
  connect_bd_net -net net_gtwiz_versal_QUAD0_RX0_outclk  [get_bd_pins gtwiz_versal/QUAD0_RX0_outclk] \
  [get_bd_pins bufg_gt_rx/outclk]
  connect_bd_net -net net_gtwiz_versal_QUAD0_TX0_outclk  [get_bd_pins gtwiz_versal/QUAD0_TX0_outclk] \
  [get_bd_pins bufg_gt_tx/outclk]
  connect_bd_net -net net_gtwiz_versal_QUAD0_ch0_iloresetdone  [get_bd_pins gtwiz_versal/QUAD0_ch0_iloresetdone] \
  [get_bd_pins hdmi_gt_controller/gt_ch0_ilo_resetdone]
  connect_bd_net -net net_gtwiz_versal_QUAD0_ch1_iloresetdone  [get_bd_pins gtwiz_versal/QUAD0_ch1_iloresetdone] \
  [get_bd_pins hdmi_gt_controller/gt_ch1_ilo_resetdone]
  connect_bd_net -net net_gtwiz_versal_QUAD0_ch2_iloresetdone  [get_bd_pins gtwiz_versal/QUAD0_ch2_iloresetdone] \
  [get_bd_pins hdmi_gt_controller/gt_ch2_ilo_resetdone]
  connect_bd_net -net net_gtwiz_versal_QUAD0_ch3_iloresetdone  [get_bd_pins gtwiz_versal/QUAD0_ch3_iloresetdone] \
  [get_bd_pins hdmi_gt_controller/gt_ch3_ilo_resetdone]
  connect_bd_net -net net_gtwiz_versal_QUAD0_hsclk0_lcplllock  [get_bd_pins gtwiz_versal/QUAD0_hsclk0_lcplllock] \
  [get_bd_pins hdmi_gt_controller/gt_lcpll0_lock]
  connect_bd_net -net net_gtwiz_versal_QUAD0_hsclk0_rplllock  [get_bd_pins gtwiz_versal/QUAD0_hsclk0_rplllock] \
  [get_bd_pins hdmi_gt_controller/gt_rpll0_lock]
  connect_bd_net -net net_gtwiz_versal_QUAD0_hsclk1_lcplllock  [get_bd_pins gtwiz_versal/QUAD0_hsclk1_lcplllock] \
  [get_bd_pins hdmi_gt_controller/gt_lcpll1_lock]
  connect_bd_net -net net_gtwiz_versal_QUAD0_hsclk1_rplllock  [get_bd_pins gtwiz_versal/QUAD0_hsclk1_rplllock] \
  [get_bd_pins hdmi_gt_controller/gt_rpll1_lock]
  connect_bd_net -net net_gtwiz_versal_gtpowergood  [get_bd_pins gtwiz_versal/gtpowergood] \
  [get_bd_pins xlcp/In0]
  connect_bd_net -net net_hdmi_gt_controller_gt_lcpll0_reset  [get_bd_pins hdmi_gt_controller/gt_lcpll0_reset] \
  [get_bd_pins gtwiz_versal/QUAD0_hsclk0_lcpllreset]
  connect_bd_net -net net_hdmi_gt_controller_gt_lcpll1_reset  [get_bd_pins hdmi_gt_controller/gt_lcpll1_reset] \
  [get_bd_pins gtwiz_versal/QUAD0_hsclk1_lcpllreset]
  connect_bd_net -net net_hdmi_gt_controller_gt_rpll0_reset  [get_bd_pins hdmi_gt_controller/gt_rpll0_reset] \
  [get_bd_pins gtwiz_versal/QUAD0_hsclk0_rpllreset]
  connect_bd_net -net net_hdmi_gt_controller_gt_rpll1_reset  [get_bd_pins hdmi_gt_controller/gt_rpll1_reset] \
  [get_bd_pins gtwiz_versal/QUAD0_hsclk1_rpllreset]
  connect_bd_net -net net_hdmi_gt_controller_irq  [get_bd_pins hdmi_gt_controller/irq] \
  [get_bd_pins irq]
  connect_bd_net -net net_hdmi_gt_controller_reset_rx_datapath  [get_bd_pins hdmi_gt_controller/reset_rx_datapath] \
  [get_bd_pins gtwiz_versal/INTF1_rst_rx_datapath_in]
  connect_bd_net -net net_hdmi_gt_controller_reset_rx_pll_and_datapath  [get_bd_pins hdmi_gt_controller/reset_rx_pll_and_datapath] \
  [get_bd_pins gtwiz_versal/INTF1_rst_rx_pll_and_datapath_in]
  connect_bd_net -net net_hdmi_gt_controller_reset_tx_datapath  [get_bd_pins hdmi_gt_controller/reset_tx_datapath] \
  [get_bd_pins gtwiz_versal/INTF0_rst_tx_datapath_in]
  connect_bd_net -net net_hdmi_gt_controller_reset_tx_pll_and_datapath  [get_bd_pins hdmi_gt_controller/reset_tx_pll_and_datapath] \
  [get_bd_pins gtwiz_versal/INTF0_rst_tx_pll_and_datapath_in]
  connect_bd_net -net net_hdmi_gt_controller_rx_full_rst  [get_bd_pins hdmi_gt_controller/rx_full_rst] \
  [get_bd_pins gtwiz_versal/INTF1_rst_all_in]
  connect_bd_net -net net_hdmi_gt_controller_rx_tmds_clk  [get_bd_pins hdmi_gt_controller/rx_tmds_clk] \
  [get_bd_pins rx_tmds_clk]
  connect_bd_net -net net_hdmi_gt_controller_rx_tmds_clk_n  [get_bd_pins hdmi_gt_controller/rx_tmds_clk_n] \
  [get_bd_pins rx_tmds_clk_n]
  connect_bd_net -net net_hdmi_gt_controller_rx_tmds_clk_p  [get_bd_pins hdmi_gt_controller/rx_tmds_clk_p] \
  [get_bd_pins rx_tmds_clk_p]
  connect_bd_net -net net_hdmi_gt_controller_rx_video_clk  [get_bd_pins hdmi_gt_controller/rx_video_clk] \
  [get_bd_pins rx_video_clk]
  connect_bd_net -net net_hdmi_gt_controller_tx_full_rst  [get_bd_pins hdmi_gt_controller/tx_full_rst] \
  [get_bd_pins gtwiz_versal/INTF0_rst_all_in]
  connect_bd_net -net net_hdmi_gt_controller_tx_tmds_clk  [get_bd_pins hdmi_gt_controller/tx_tmds_clk] \
  [get_bd_pins tx_tmds_clk]
  connect_bd_net -net net_hdmi_gt_controller_tx_video_clk  [get_bd_pins hdmi_gt_controller/tx_video_clk] \
  [get_bd_pins tx_video_clk]
  connect_bd_net -net net_urlp_Res  [get_bd_pins urlp/Res] \
  [get_bd_pins hdmi_gt_controller/gtpowergood]
  connect_bd_net -net net_xlcp_dout  [get_bd_pins xlcp/dout] \
  [get_bd_pins urlp/Op1]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hdmi_tx_ss_hier
proc create_hier_cell_hdmi_tx_ss_hier { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hdmi_tx_ss_hier() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 TX_DDC_OUT

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 HDMI_CTRL

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 GT_Serial

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 GT_DRU_FRL_CLK_IN

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 TX_REFCLK_P_IN_V

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 HDMI_RX_CLK_P_IN_V

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

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

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 M12_INI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 M13_INI


  # Create pins
  create_bd_pin -dir I TX_HPD_IN
  create_bd_pin -dir O LED0
  create_bd_pin -dir I IDT8T49N241_LOL_IN
  create_bd_pin -dir O -type clk RX_REFCLK_P_OUT
  create_bd_pin -dir O -type clk RX_REFCLK_N_OUT
  create_bd_pin -dir O -from 0 -to 0 TX_TI_ENABLE
  create_bd_pin -dir O -type intr Timer_interrupt
  create_bd_pin -dir I -type clk clk_in1
  create_bd_pin -dir I -from 0 -to 0 Op1
  create_bd_pin -dir O -type intr hdmi_txss_irq
  create_bd_pin -dir O hdmi_gt_irq
  create_bd_pin -dir O -type intr iic2intc_irpt
  create_bd_pin -dir O -type intr Mixer_irq

  # Create instance: rst_processor_1_300M, and set properties
  set rst_processor_1_300M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset rst_processor_1_300M ]
  set_property CONFIG.C_NUM_INTERCONNECT_ARESETN {1} $rst_processor_1_300M


  # Create instance: tx_video_axis_reg_slice, and set properties
  set tx_video_axis_reg_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice tx_video_axis_reg_slice ]

  # Create instance: ilslice_5, and set properties
  set ilslice_5 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice ilslice_5 ]
  set_property -dict [list \
    CONFIG.DIN_TO {5} \
    CONFIG.DIN_WIDTH {8} \
  ] $ilslice_5


  # Create instance: v_hdmi_txss1, and set properties
  set v_hdmi_txss1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_hdmi_txss1 v_hdmi_txss1 ]
  set_property -dict [list \
    CONFIG.C_ADDR_WIDTH {10} \
    CONFIG.C_ADD_CORE_DBG {0} \
    CONFIG.C_ADD_MARK_DBG {false} \
    CONFIG.C_DYNAMIC_HDR {0} \
    CONFIG.C_EXDES_RX_PLL_SELECTION {8} \
    CONFIG.C_EXDES_TX_PLL_SELECTION {7} \
    CONFIG.C_HPD_INVERT {true} \
    CONFIG.C_HYSTERESIS_LEVEL {511} \
    CONFIG.C_INCLUDE_HDCP {false} \
    CONFIG.C_INCLUDE_HDCP_1_4 {false} \
    CONFIG.C_INCLUDE_HDCP_2_2 {false} \
    CONFIG.C_INPUT_PIXELS_PER_CLOCK {8} \
    CONFIG.C_MAX_BITS_PER_COMPONENT {12} \
    CONFIG.C_MAX_FRL_RATE {6} \
    CONFIG.C_VALIDATION_ENABLE {false} \
    CONFIG.C_VID_INTERFACE {0} \
    CONFIG.C_VRR_SUPPORT {1} \
  ] $v_hdmi_txss1


  # Create instance: ilconstant_1, and set properties
  set ilconstant_1 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconstant ilconstant_1 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {288} \
  ] $ilconstant_1


  # Create instance: rst_processor_1_100M, and set properties
  set rst_processor_1_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset rst_processor_1_100M ]
  set_property CONFIG.C_NUM_INTERCONNECT_ARESETN {1} $rst_processor_1_100M


  # Create instance: vcc_const, and set properties
  set vcc_const [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconstant vcc_const ]
  set_property CONFIG.CONST_VAL {1} $vcc_const


  # Create instance: clkx_wiz_0, and set properties
  set clkx_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clkx5_wiz clkx_wiz_0 ]
  set_property -dict [list \
    CONFIG.CLKOUT_DRIVES {BUFG,BUFG,BUFG,BUFG,BUFG,BUFG,BUFG} \
    CONFIG.CLKOUT_DYN_PS {None,None,None,None,None,None,None} \
    CONFIG.CLKOUT_GROUPING {Auto,Auto,Auto,Auto,Auto,Auto,Auto} \
    CONFIG.CLKOUT_MATCHED_ROUTING {false,false,false,false,false,false,false} \
    CONFIG.CLKOUT_PORT {clk_out1,clk_out2,clk_out3,clk_out4,clk_out5,clk_out6,clk_out7} \
    CONFIG.CLKOUT_REQUESTED_DUTY_CYCLE {50.000,50.000,50.000,50.000,50.000,50.000,50.000} \
    CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY {450,300,100.000,100.000,100.000,100.000,100.000} \
    CONFIG.CLKOUT_REQUESTED_PHASE {0.000,0.000,0.000,0.000,0.000,0.000,0.000} \
    CONFIG.CLKOUT_USED {true,true,false,false,false,false,false} \
    CONFIG.PRIM_SOURCE {No_buffer} \
    CONFIG.USE_LOCKED {true} \
    CONFIG.USE_RESET {true} \
  ] $clkx_wiz_0


  # Create instance: axi_noc2_0, and set properties
  set axi_noc2_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc2 axi_noc2_0 ]
  set_property -dict [list \
    CONFIG.NUM_MI {0} \
    CONFIG.NUM_NMI {14} \
    CONFIG.NUM_SI {14} \
  ] $axi_noc2_0


  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.CONNECTIONS {M07_INI {read_bw {500} write_bw {50} } M00_INI {read_bw {500} write_bw {50} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins $axi_noc2_0/S00_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.CONNECTIONS {M07_INI {read_bw {500} write_bw {50} } M00_INI {read_bw {500} write_bw {50} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins $axi_noc2_0/S01_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.CONNECTIONS {M08_INI {read_bw {500} write_bw {50} } M01_INI {read_bw {500} write_bw {50} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins $axi_noc2_0/S02_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.CONNECTIONS {M08_INI {read_bw {500} write_bw {50} } M01_INI {read_bw {500} write_bw {50} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins $axi_noc2_0/S03_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.CONNECTIONS {M02_INI {read_bw {500} write_bw {50} } M09_INI {read_bw {500} write_bw {50} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins $axi_noc2_0/S04_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.CONNECTIONS {M02_INI {read_bw {500} write_bw {50} } M09_INI {read_bw {500} write_bw {500} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins $axi_noc2_0/S05_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.CONNECTIONS {M03_INI {read_bw {500} write_bw {50} } M10_INI {read_bw {500} write_bw {500} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins $axi_noc2_0/S06_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.CONNECTIONS {M03_INI {read_bw {500} write_bw {50} } M10_INI {read_bw {500} write_bw {500} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins $axi_noc2_0/S07_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.CONNECTIONS {M04_INI {read_bw {1100} write_bw {50} } M11_INI {read_bw {1100} write_bw {50} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins $axi_noc2_0/S08_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.CONNECTIONS {M04_INI {read_bw {1100} write_bw {50} } M11_INI {read_bw {1100} write_bw {50} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins $axi_noc2_0/S09_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.CONNECTIONS {M05_INI {read_bw {700} write_bw {50} } M12_INI {read_bw {700} write_bw {50} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins $axi_noc2_0/S10_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.CONNECTIONS {M05_INI {read_bw {700} write_bw {50} } M12_INI {read_bw {700} write_bw {50} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins $axi_noc2_0/S11_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.CONNECTIONS {M06_INI {read_bw {700} write_bw {50} } M13_INI {read_bw {700} write_bw {50} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins $axi_noc2_0/S12_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.CONNECTIONS {M06_INI {read_bw {700} write_bw {50} } M13_INI {read_bw {700} write_bw {50} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins $axi_noc2_0/S13_AXI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI:S01_AXI:S02_AXI:S03_AXI:S04_AXI:S05_AXI:S06_AXI:S07_AXI:S08_AXI:S09_AXI:S10_AXI:S11_AXI:S12_AXI:S13_AXI} \
 ] [get_bd_pins $axi_noc2_0/aclk0]

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilvector_logic util_vector_logic_0 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_0


  # Create instance: axi_gpio, and set properties
  set axi_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio axi_gpio ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_DOUT_DEFAULT {0x000000FF} \
    CONFIG.C_GPIO_WIDTH {8} \
  ] $axi_gpio


  # Create instance: v_mix_0, and set properties
  set v_mix_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_mix v_mix_0 ]
  set_property -dict [list \
    CONFIG.AXIMM_ADDR_WIDTH {64} \
    CONFIG.AXIMM_DATA_WIDTH {512} \
    CONFIG.C_M_AXI_MM_VIDEO1_DATA_WIDTH {512} \
    CONFIG.C_M_AXI_MM_VIDEO2_DATA_WIDTH {512} \
    CONFIG.C_M_AXI_MM_VIDEO3_DATA_WIDTH {512} \
    CONFIG.C_M_AXI_MM_VIDEO4_DATA_WIDTH {512} \
    CONFIG.LAYER10_ALPHA {true} \
    CONFIG.LAYER10_VIDEO_FORMAT {20} \
    CONFIG.LAYER11_ALPHA {true} \
    CONFIG.LAYER11_VIDEO_FORMAT {20} \
    CONFIG.LAYER12_ALPHA {true} \
    CONFIG.LAYER12_VIDEO_FORMAT {20} \
    CONFIG.LAYER13_ALPHA {true} \
    CONFIG.LAYER13_VIDEO_FORMAT {24} \
    CONFIG.LAYER14_ALPHA {true} \
    CONFIG.LAYER14_VIDEO_FORMAT {24} \
    CONFIG.LAYER1_ALPHA {true} \
    CONFIG.LAYER1_VIDEO_FORMAT {20} \
    CONFIG.LAYER2_ALPHA {true} \
    CONFIG.LAYER2_VIDEO_FORMAT {20} \
    CONFIG.LAYER3_ALPHA {true} \
    CONFIG.LAYER3_VIDEO_FORMAT {20} \
    CONFIG.LAYER4_ALPHA {true} \
    CONFIG.LAYER4_VIDEO_FORMAT {20} \
    CONFIG.LAYER5_ALPHA {true} \
    CONFIG.LAYER5_VIDEO_FORMAT {20} \
    CONFIG.LAYER6_ALPHA {true} \
    CONFIG.LAYER6_VIDEO_FORMAT {20} \
    CONFIG.LAYER7_ALPHA {true} \
    CONFIG.LAYER7_VIDEO_FORMAT {20} \
    CONFIG.LAYER8_ALPHA {true} \
    CONFIG.LAYER8_VIDEO_FORMAT {20} \
    CONFIG.LAYER9_ALPHA {true} \
    CONFIG.LAYER9_VIDEO_FORMAT {20} \
    CONFIG.MAX_COLS {7680} \
    CONFIG.MAX_DATA_WIDTH {12} \
    CONFIG.MAX_ROWS {4320} \
    CONFIG.NR_LAYERS {15} \
    CONFIG.SAMPLES_PER_CLOCK {8} \
    CONFIG.VIDEO_FORMAT {0} \
  ] $v_mix_0


  # Create instance: v_fifo_dc, and set properties
  set v_fifo_dc [ create_bd_cell -type ip -vlnv xilinx.com:ip:video_cke_sync v_fifo_dc ]

  # Create instance: axi_smartconnect_0, and set properties
  set axi_smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect axi_smartconnect_0 ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {2} \
    CONFIG.NUM_MI {7} \
    CONFIG.NUM_SI {1} \
  ] $axi_smartconnect_0


  # Create instance: axi_iic_0, and set properties
  set axi_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic axi_iic_0 ]
  set_property CONFIG.TEN_BIT_ADR {7_bit} $axi_iic_0


  # Create instance: hdmiphy_ss_0
  create_hier_cell_hdmiphy_ss_0 $hier_obj hdmiphy_ss_0

  # Create instance: gt_refclk_buf_ss_0
  create_hier_cell_gt_refclk_buf_ss_0 $hier_obj gt_refclk_buf_ss_0

  # Create instance: gt_refclk_buf_ss_1
  create_hier_cell_gt_refclk_buf_ss_1 $hier_obj gt_refclk_buf_ss_1

  # Create instance: gt_refclk_buf_ss_2
  create_hier_cell_gt_refclk_buf_ss_2 $hier_obj gt_refclk_buf_ss_2

  # Create instance: vfmc_ctlr_ss_0
  create_hier_cell_vfmc_ctlr_ss_0 $hier_obj vfmc_ctlr_ss_0

  # Create instance: axi_timer_0, and set properties
  set axi_timer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer axi_timer_0 ]
  set_property CONFIG.COUNT_WIDTH {32} $axi_timer_0


  # Create instance: ilconstant_0, and set properties
  set ilconstant_0 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconstant ilconstant_0 ]
  set_property CONFIG.CONST_VAL {0} $ilconstant_0


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins axi_smartconnect_0/S00_AXI] [get_bd_intf_pins S00_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins axi_noc2_0/M00_INI] [get_bd_intf_pins M00_INI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins axi_noc2_0/M01_INI] [get_bd_intf_pins M01_INI]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins axi_noc2_0/M02_INI] [get_bd_intf_pins M02_INI]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins axi_noc2_0/M03_INI] [get_bd_intf_pins M03_INI]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins axi_noc2_0/M07_INI] [get_bd_intf_pins M07_INI]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins axi_noc2_0/M08_INI] [get_bd_intf_pins M08_INI]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins axi_noc2_0/M09_INI] [get_bd_intf_pins M09_INI]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins axi_noc2_0/M10_INI] [get_bd_intf_pins M10_INI]
  connect_bd_intf_net -intf_net Conn10 [get_bd_intf_pins axi_noc2_0/M11_INI] [get_bd_intf_pins M11_INI]
  connect_bd_intf_net -intf_net Conn11 [get_bd_intf_pins axi_noc2_0/M12_INI] [get_bd_intf_pins M12_INI]
  connect_bd_intf_net -intf_net Conn12 [get_bd_intf_pins axi_noc2_0/M13_INI] [get_bd_intf_pins M13_INI]
  connect_bd_intf_net -intf_net axi_noc2_0_M04_INI [get_bd_intf_pins M04_INI] [get_bd_intf_pins axi_noc2_0/M04_INI]
  connect_bd_intf_net -intf_net axi_noc2_0_M05_INI [get_bd_intf_pins M05_INI] [get_bd_intf_pins axi_noc2_0/M05_INI]
  connect_bd_intf_net -intf_net axi_noc2_0_M06_INI [get_bd_intf_pins M06_INI] [get_bd_intf_pins axi_noc2_0/M06_INI]
  connect_bd_intf_net -intf_net axi_smartconnect_0_M01_AXI [get_bd_intf_pins axi_smartconnect_0/M01_AXI] [get_bd_intf_pins vfmc_ctlr_ss_0/S_AXI]
  connect_bd_intf_net -intf_net axi_smartconnect_0_M03_AXI [get_bd_intf_pins axi_smartconnect_0/M03_AXI] [get_bd_intf_pins axi_iic_0/S_AXI]
  connect_bd_intf_net -intf_net axi_smartconnect_0_M04_AXI [get_bd_intf_pins axi_smartconnect_0/M04_AXI] [get_bd_intf_pins v_mix_0/s_axi_CTRL]
  connect_bd_intf_net -intf_net axi_smartconnect_0_M05_AXI [get_bd_intf_pins axi_smartconnect_0/M05_AXI] [get_bd_intf_pins axi_gpio/S_AXI]
  connect_bd_intf_net -intf_net axi_smartconnect_0_M06_AXI [get_bd_intf_pins axi_smartconnect_0/M06_AXI] [get_bd_intf_pins axi_timer_0/S_AXI]
  connect_bd_intf_net -intf_net intf_net_bdry_in_GT_DRU_FRL_CLK_IN [get_bd_intf_pins GT_DRU_FRL_CLK_IN] [get_bd_intf_pins gt_refclk_buf_ss_0/IBUFDSGT_IN]
  connect_bd_intf_net -intf_net intf_net_bdry_in_HDMI_RX_CLK_P_IN_V [get_bd_intf_pins HDMI_RX_CLK_P_IN_V] [get_bd_intf_pins gt_refclk_buf_ss_2/IBUFDSGT_IN]
  connect_bd_intf_net -intf_net intf_net_bdry_in_TX_REFCLK_P_IN_V [get_bd_intf_pins TX_REFCLK_P_IN_V] [get_bd_intf_pins gt_refclk_buf_ss_1/IBUFDSGT_IN]
  connect_bd_intf_net -intf_net intf_net_cips_ss_0_IIC [get_bd_intf_pins HDMI_CTRL] [get_bd_intf_pins axi_iic_0/IIC]
  connect_bd_intf_net -intf_net intf_net_cips_ss_0_M00_AXI [get_bd_intf_pins axi_smartconnect_0/M00_AXI] [get_bd_intf_pins hdmiphy_ss_0/vid_phy_axi4lite]
  connect_bd_intf_net -intf_net intf_net_cips_ss_0_M02_AXI [get_bd_intf_pins axi_smartconnect_0/M02_AXI] [get_bd_intf_pins v_hdmi_txss1/S_AXI_CPU_IN]
  connect_bd_intf_net -intf_net intf_net_hdmiphy_ss_0_phy_data [get_bd_intf_pins GT_Serial] [get_bd_intf_pins hdmiphy_ss_0/phy_data]
  connect_bd_intf_net -intf_net intf_net_hdmiphy_ss_0_vid_phy_status_sb_tx [get_bd_intf_pins hdmiphy_ss_0/vid_phy_status_sb_tx] [get_bd_intf_pins v_hdmi_txss1/SB_STATUS_IN]
  connect_bd_intf_net -intf_net intf_net_tx_video_axis_reg_slice_M_AXIS [get_bd_intf_pins tx_video_axis_reg_slice/M_AXIS] [get_bd_intf_pins v_hdmi_txss1/VIDEO_IN]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_txss1_DDC_OUT [get_bd_intf_pins TX_DDC_OUT] [get_bd_intf_pins v_hdmi_txss1/DDC_OUT]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_txss1_LINK_DATA0_OUT [get_bd_intf_pins v_hdmi_txss1/LINK_DATA0_OUT] [get_bd_intf_pins hdmiphy_ss_0/vid_phy_tx_axi4s_ch0]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_txss1_LINK_DATA1_OUT [get_bd_intf_pins v_hdmi_txss1/LINK_DATA1_OUT] [get_bd_intf_pins hdmiphy_ss_0/vid_phy_tx_axi4s_ch1]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_txss1_LINK_DATA2_OUT [get_bd_intf_pins v_hdmi_txss1/LINK_DATA2_OUT] [get_bd_intf_pins hdmiphy_ss_0/vid_phy_tx_axi4s_ch2]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_txss1_LINK_DATA3_OUT [get_bd_intf_pins v_hdmi_txss1/LINK_DATA3_OUT] [get_bd_intf_pins hdmiphy_ss_0/vid_phy_tx_axi4s_ch3]
  connect_bd_intf_net -intf_net v_mix_0_m_axi_mm_video1 [get_bd_intf_pins v_mix_0/m_axi_mm_video1] [get_bd_intf_pins axi_noc2_0/S01_AXI]
  connect_bd_intf_net -intf_net v_mix_0_m_axi_mm_video2 [get_bd_intf_pins v_mix_0/m_axi_mm_video2] [get_bd_intf_pins axi_noc2_0/S02_AXI]
  connect_bd_intf_net -intf_net v_mix_0_m_axi_mm_video3 [get_bd_intf_pins v_mix_0/m_axi_mm_video3] [get_bd_intf_pins axi_noc2_0/S03_AXI]
  connect_bd_intf_net -intf_net v_mix_0_m_axi_mm_video4 [get_bd_intf_pins axi_noc2_0/S00_AXI] [get_bd_intf_pins v_mix_0/m_axi_mm_video4]
  connect_bd_intf_net -intf_net v_mix_0_m_axi_mm_video5 [get_bd_intf_pins v_mix_0/m_axi_mm_video5] [get_bd_intf_pins axi_noc2_0/S04_AXI]
  connect_bd_intf_net -intf_net v_mix_0_m_axi_mm_video6 [get_bd_intf_pins v_mix_0/m_axi_mm_video6] [get_bd_intf_pins axi_noc2_0/S05_AXI]
  connect_bd_intf_net -intf_net v_mix_0_m_axi_mm_video7 [get_bd_intf_pins v_mix_0/m_axi_mm_video7] [get_bd_intf_pins axi_noc2_0/S06_AXI]
  connect_bd_intf_net -intf_net v_mix_0_m_axi_mm_video8 [get_bd_intf_pins v_mix_0/m_axi_mm_video8] [get_bd_intf_pins axi_noc2_0/S07_AXI]
  connect_bd_intf_net -intf_net v_mix_0_m_axi_mm_video9 [get_bd_intf_pins v_mix_0/m_axi_mm_video9] [get_bd_intf_pins axi_noc2_0/S08_AXI]
  connect_bd_intf_net -intf_net v_mix_0_m_axi_mm_video10 [get_bd_intf_pins v_mix_0/m_axi_mm_video10] [get_bd_intf_pins axi_noc2_0/S09_AXI]
  connect_bd_intf_net -intf_net v_mix_0_m_axi_mm_video11 [get_bd_intf_pins v_mix_0/m_axi_mm_video11] [get_bd_intf_pins axi_noc2_0/S10_AXI]
  connect_bd_intf_net -intf_net v_mix_0_m_axi_mm_video12 [get_bd_intf_pins v_mix_0/m_axi_mm_video12] [get_bd_intf_pins axi_noc2_0/S11_AXI]
  connect_bd_intf_net -intf_net v_mix_0_m_axi_mm_video13 [get_bd_intf_pins v_mix_0/m_axi_mm_video13] [get_bd_intf_pins axi_noc2_0/S12_AXI]
  connect_bd_intf_net -intf_net v_mix_0_m_axi_mm_video14 [get_bd_intf_pins v_mix_0/m_axi_mm_video14] [get_bd_intf_pins axi_noc2_0/S13_AXI]
  connect_bd_intf_net -intf_net v_mix_0_m_axis_video [get_bd_intf_pins tx_video_axis_reg_slice/S_AXIS] [get_bd_intf_pins v_mix_0/m_axis_video]

  # Create port connections
  connect_bd_net -net Net  [get_bd_pins Op1] \
  [get_bd_pins rst_processor_1_100M/ext_reset_in] \
  [get_bd_pins util_vector_logic_0/Op1] \
  [get_bd_pins rst_processor_1_100M/aux_reset_in] \
  [get_bd_pins rst_processor_1_100M/dcm_locked]
  connect_bd_net -net axi_gpio_gpio_io_o  [get_bd_pins axi_gpio/gpio_io_o] \
  [get_bd_pins ilslice_5/Din]
  connect_bd_net -net axi_iic_0_iic2intc_irpt  [get_bd_pins axi_iic_0/iic2intc_irpt] \
  [get_bd_pins iic2intc_irpt]
  connect_bd_net -net axi_timer_0_interrupt  [get_bd_pins axi_timer_0/interrupt] \
  [get_bd_pins Timer_interrupt]
  connect_bd_net -net hdmiphy_ss_0_irq  [get_bd_pins hdmiphy_ss_0/irq] \
  [get_bd_pins hdmi_gt_irq]
  connect_bd_net -net ilconstant_0_dout  [get_bd_pins ilconstant_0/dout] \
  [get_bd_pins v_hdmi_txss1/s_axis_audio_aclk] \
  [get_bd_pins v_hdmi_txss1/fid]
  connect_bd_net -net ilconstant_1_dout  [get_bd_pins ilconstant_1/dout] \
  [get_bd_pins v_mix_0/s_axis_video_TDATA] \
  [get_bd_pins v_mix_0/s_axis_video_TVALID]
  connect_bd_net -net ilslice_5_Dout  [get_bd_pins ilslice_5/Dout] \
  [get_bd_pins v_mix_0/ap_rst_n]
  connect_bd_net -net net_bdry_in_IDT8T49N241_LOL_IN  [get_bd_pins IDT8T49N241_LOL_IN] \
  [get_bd_pins hdmiphy_ss_0/tx_refclk_rdy]
  connect_bd_net -net net_bdry_in_TX_HPD_IN  [get_bd_pins TX_HPD_IN] \
  [get_bd_pins v_hdmi_txss1/hpd]
  connect_bd_net -net net_cips_ss_0_clk_out2  [get_bd_pins clkx_wiz_0/clk_out2] \
  [get_bd_pins tx_video_axis_reg_slice/aclk] \
  [get_bd_pins v_fifo_dc/rstn_clk] \
  [get_bd_pins v_hdmi_txss1/s_axis_video_aclk] \
  [get_bd_pins axi_noc2_0/aclk0] \
  [get_bd_pins v_mix_0/ap_clk] \
  [get_bd_pins axi_gpio/s_axi_aclk] \
  [get_bd_pins rst_processor_1_300M/slowest_sync_clk] \
  [get_bd_pins axi_smartconnect_0/aclk1]
  connect_bd_net -net net_cips_ss_0_dcm_locked  [get_bd_pins rst_processor_1_300M/peripheral_aresetn] \
  [get_bd_pins tx_video_axis_reg_slice/aresetn] \
  [get_bd_pins v_fifo_dc/rstn] \
  [get_bd_pins v_hdmi_txss1/s_axis_video_aresetn] \
  [get_bd_pins axi_gpio/s_axi_aresetn]
  connect_bd_net -net net_cips_ss_0_frl_clk  [get_bd_pins clkx_wiz_0/clk_out1] \
  [get_bd_pins v_hdmi_txss1/frl_clk]
  connect_bd_net -net net_cips_ss_0_peripheral_aresetn  [get_bd_pins rst_processor_1_100M/peripheral_aresetn] \
  [get_bd_pins v_hdmi_txss1/s_axi_cpu_aresetn] \
  [get_bd_pins hdmiphy_ss_0/vid_phy_sb_aresetn] \
  [get_bd_pins hdmiphy_ss_0/vid_phy_axi4lite_aresetn] \
  [get_bd_pins vfmc_ctlr_ss_0/s_axi_aresetn] \
  [get_bd_pins axi_iic_0/s_axi_aresetn] \
  [get_bd_pins axi_timer_0/s_axi_aresetn]
  connect_bd_net -net net_clkx_wiz_0_locked  [get_bd_pins clkx_wiz_0/locked] \
  [get_bd_pins rst_processor_1_300M/aux_reset_in] \
  [get_bd_pins rst_processor_1_300M/dcm_locked] \
  [get_bd_pins rst_processor_1_300M/ext_reset_in]
  connect_bd_net -net net_gt_refclk_buf_ss_0_IBUFDSGT_ODIV2_OUT  [get_bd_pins gt_refclk_buf_ss_0/IBUFDSGT_ODIV2_OUT] \
  [get_bd_pins hdmiphy_ss_0/dru_ref_clk_odiv2_in]
  connect_bd_net -net net_gt_refclk_buf_ss_0_IBUFDSGT_OUT  [get_bd_pins gt_refclk_buf_ss_0/IBUFDSGT_OUT] \
  [get_bd_pins hdmiphy_ss_0/dru_ref_clk_in]
  connect_bd_net -net net_gt_refclk_buf_ss_1_IBUFDSGT_ODIV2_OUT  [get_bd_pins gt_refclk_buf_ss_1/IBUFDSGT_ODIV2_OUT] \
  [get_bd_pins hdmiphy_ss_0/tx_ref_clk_odiv2_in]
  connect_bd_net -net net_gt_refclk_buf_ss_1_IBUFDSGT_OUT  [get_bd_pins gt_refclk_buf_ss_1/IBUFDSGT_OUT] \
  [get_bd_pins hdmiphy_ss_0/tx_ref_clk_in]
  connect_bd_net -net net_gt_refclk_buf_ss_2_IBUFDSGT_ODIV2_OUT  [get_bd_pins gt_refclk_buf_ss_2/IBUFDSGT_ODIV2_OUT] \
  [get_bd_pins hdmiphy_ss_0/rx_ref_clk_odiv2_in]
  connect_bd_net -net net_gt_refclk_buf_ss_2_IBUFDSGT_OUT  [get_bd_pins gt_refclk_buf_ss_2/IBUFDSGT_OUT] \
  [get_bd_pins hdmiphy_ss_0/rx_ref_clk_in]
  connect_bd_net -net net_hdmiphy_ss_0_rx_tmds_clk_n  [get_bd_pins hdmiphy_ss_0/rx_tmds_clk_n] \
  [get_bd_pins RX_REFCLK_N_OUT]
  connect_bd_net -net net_hdmiphy_ss_0_rx_tmds_clk_p  [get_bd_pins hdmiphy_ss_0/rx_tmds_clk_p] \
  [get_bd_pins RX_REFCLK_P_OUT]
  connect_bd_net -net net_hdmiphy_ss_0_rx_video_clk  [get_bd_pins hdmiphy_ss_0/rx_video_clk] \
  [get_bd_pins v_fifo_dc/a_clk]
  connect_bd_net -net net_hdmiphy_ss_0_tx_video_clk  [get_bd_pins hdmiphy_ss_0/tx_video_clk] \
  [get_bd_pins v_hdmi_txss1/video_clk] \
  [get_bd_pins v_fifo_dc/b_clk]
  connect_bd_net -net net_hdmiphy_ss_0_txoutclk  [get_bd_pins hdmiphy_ss_0/txoutclk] \
  [get_bd_pins v_hdmi_txss1/link_clk]
  connect_bd_net -net net_rst_processor_1_100M_interconnect_aresetn  [get_bd_pins rst_processor_1_100M/interconnect_aresetn] \
  [get_bd_pins axi_smartconnect_0/aresetn]
  connect_bd_net -net net_util_vector_logic_0_Res  [get_bd_pins util_vector_logic_0/Res] \
  [get_bd_pins clkx_wiz_0/reset]
  connect_bd_net -net net_v_fifo_dc_b_de_out  [get_bd_pins v_fifo_dc/b_de_out] \
  [get_bd_pins v_hdmi_txss1/video_cke_in]
  connect_bd_net -net net_v_hdmi_txss1_locked  [get_bd_pins v_hdmi_txss1/locked] \
  [get_bd_pins LED0]
  connect_bd_net -net net_vcc_const_dout  [get_bd_pins vcc_const/dout] \
  [get_bd_pins hdmiphy_ss_0/vid_phy_tx_axi4s_aresetn] \
  [get_bd_pins hdmiphy_ss_0/vid_phy_rx_axi4s_aresetn] \
  [get_bd_pins v_fifo_dc/a_dat_in] \
  [get_bd_pins v_fifo_dc/b_rd_in]
  connect_bd_net -net net_vfmc_ctlr_ss_0_VFMC_RX_ONSEMI_ENABLE  [get_bd_pins vfmc_ctlr_ss_0/VFMC_RX_ONSEMI_ENABLE] \
  [get_bd_pins TX_TI_ENABLE]
  connect_bd_net -net ps_wizard_0_pl0_ref_clk  [get_bd_pins clk_in1] \
  [get_bd_pins v_hdmi_txss1/s_axi_cpu_aclk] \
  [get_bd_pins hdmiphy_ss_0/vid_phy_sb_aclk] \
  [get_bd_pins hdmiphy_ss_0/vid_phy_axi4lite_aclk] \
  [get_bd_pins vfmc_ctlr_ss_0/s_axi_aclk] \
  [get_bd_pins hdmiphy_ss_0/drpclk] \
  [get_bd_pins rst_processor_1_100M/slowest_sync_clk] \
  [get_bd_pins axi_iic_0/s_axi_aclk] \
  [get_bd_pins axi_smartconnect_0/aclk] \
  [get_bd_pins clkx_wiz_0/clk_in1] \
  [get_bd_pins axi_timer_0/s_axi_aclk]
  connect_bd_net -net v_hdmi_txss1_irq  [get_bd_pins v_hdmi_txss1/irq] \
  [get_bd_pins hdmi_txss_irq]
  connect_bd_net -net v_mix_0_interrupt  [get_bd_pins v_mix_0/interrupt] \
  [get_bd_pins Mixer_irq]

  # Perform GUI Layout
  regenerate_bd_layout -hierarchy [get_bd_cells /hdmi_tx_ss_hier] -layout_string {
   "ActiveEmotionalView":"Default View",
   "Default View_ScaleFactor":"0.790332",
   "Default View_TopLeft":"-702,3",
   "DisplayHardenedConnections":"1",
   "DisplayPinAutomationMissing":"1",
   "DisplayPinsOfHiddenNets":"1",
   "DisplayTieOff":"1",
   "ExpandedHierarchyInLayout":"",
   "guistr":"# # String gsaved with Nlview 7.8.0 2024-04-26 e1825d835c VDI=44 GEI=38 GUI=JA:21.0 TLS
#  -string -flagsOSRD
preplace port TX_DDC_OUT -pg 1 -lvl 8 -x 3060 -y 1030 -defaultsOSRD
preplace port HDMI_CTRL -pg 1 -lvl 8 -x 3060 -y 460 -defaultsOSRD
preplace port GT_Serial -pg 1 -lvl 8 -x 3060 -y 650 -defaultsOSRD
preplace port GT_DRU_FRL_CLK_IN -pg 1 -lvl 0 -x 0 -y 1110 -defaultsOSRD
preplace port TX_REFCLK_P_IN_V -pg 1 -lvl 0 -x 0 -y 1250 -defaultsOSRD
preplace port HDMI_RX_CLK_P_IN_V -pg 1 -lvl 0 -x 0 -y 1600 -defaultsOSRD
preplace port S00_AXI -pg 1 -lvl 0 -x 0 -y 570 -defaultsOSRD
preplace port M00_INI -pg 1 -lvl 8 -x 3060 -y 70 -defaultsOSRD
preplace port M01_INI -pg 1 -lvl 8 -x 3060 -y 90 -defaultsOSRD
preplace port M02_INI -pg 1 -lvl 8 -x 3060 -y 110 -defaultsOSRD
preplace port M03_INI -pg 1 -lvl 8 -x 3060 -y 130 -defaultsOSRD
preplace port M04_INI -pg 1 -lvl 8 -x 3060 -y 150 -defaultsOSRD
preplace port M05_INI -pg 1 -lvl 8 -x 3060 -y 170 -defaultsOSRD
preplace port M06_INI -pg 1 -lvl 8 -x 3060 -y 190 -defaultsOSRD
preplace port M07_INI -pg 1 -lvl 8 -x 3060 -y 210 -defaultsOSRD
preplace port M08_INI -pg 1 -lvl 8 -x 3060 -y 230 -defaultsOSRD
preplace port M09_INI -pg 1 -lvl 8 -x 3060 -y 250 -defaultsOSRD
preplace port M10_INI -pg 1 -lvl 8 -x 3060 -y 270 -defaultsOSRD
preplace port M11_INI -pg 1 -lvl 8 -x 3060 -y 290 -defaultsOSRD
preplace port M12_INI -pg 1 -lvl 8 -x 3060 -y 310 -defaultsOSRD
preplace port M13_INI -pg 1 -lvl 8 -x 3060 -y 330 -defaultsOSRD
preplace port port-id_TX_HPD_IN -pg 1 -lvl 0 -x 0 -y 1080 -defaultsOSRD
preplace port port-id_LED0 -pg 1 -lvl 8 -x 3060 -y 1050 -defaultsOSRD
preplace port port-id_IDT8T49N241_LOL_IN -pg 1 -lvl 0 -x 0 -y 1170 -defaultsOSRD
preplace port port-id_RX_REFCLK_P_OUT -pg 1 -lvl 8 -x 3060 -y 850 -defaultsOSRD
preplace port port-id_RX_REFCLK_N_OUT -pg 1 -lvl 8 -x 3060 -y 870 -defaultsOSRD
preplace port port-id_Timer_interrupt -pg 1 -lvl 8 -x 3060 -y 1430 -defaultsOSRD
preplace port port-id_clk_in1 -pg 1 -lvl 0 -x 0 -y 1390 -defaultsOSRD
preplace port port-id_hdmi_txss_irq -pg 1 -lvl 8 -x 3060 -y 1070 -defaultsOSRD
preplace port port-id_hdmi_gt_irq -pg 1 -lvl 8 -x 3060 -y 950 -defaultsOSRD
preplace port port-id_iic2intc_irpt -pg 1 -lvl 8 -x 3060 -y 480 -defaultsOSRD
preplace port port-id_Mixer_irq -pg 1 -lvl 8 -x 3060 -y 400 -defaultsOSRD
preplace portBus TX_TI_ENABLE -pg 1 -lvl 8 -x 3060 -y 1260 -defaultsOSRD
preplace portBus Op1 -pg 1 -lvl 0 -x 0 -y 1330 -defaultsOSRD
preplace inst rst_processor_1_300M -pg 1 -lvl 3 -x 930 -y 1350 -defaultsOSRD
preplace inst tx_video_axis_reg_slice -pg 1 -lvl 5 -x 1880 -y 640 -defaultsOSRD
preplace inst ilslice_5 -pg 1 -lvl 3 -x 930 -y 260 -defaultsOSRD
preplace inst v_hdmi_txss1 -pg 1 -lvl 6 -x 2270 -y 780 -defaultsOSRD
preplace inst ilconstant_1 -pg 1 -lvl 3 -x 930 -y 160 -defaultsOSRD
preplace inst rst_processor_1_100M -pg 1 -lvl 2 -x 520 -y 1500 -defaultsOSRD
preplace inst vcc_const -pg 1 -lvl 4 -x 1450 -y 990 -defaultsOSRD
preplace inst clkx_wiz_0 -pg 1 -lvl 2 -x 520 -y 1340 -defaultsOSRD
preplace inst axi_noc2_0 -pg 1 -lvl 7 -x 2820 -y 200 -defaultsOSRD
preplace inst util_vector_logic_0 -pg 1 -lvl 1 -x 170 -y 1330 -defaultsOSRD
preplace inst axi_gpio -pg 1 -lvl 4 -x 1450 -y 640 -defaultsOSRD
preplace inst v_mix_0 -pg 1 -lvl 4 -x 1450 -y 210 -defaultsOSRD
preplace inst v_fifo_dc -pg 1 -lvl 5 -x 1880 -y 940 -defaultsOSRD
preplace inst axi_smartconnect_0 -pg 1 -lvl 3 -x 930 -y 600 -defaultsOSRD
preplace inst axi_iic_0 -pg 1 -lvl 7 -x 2820 -y 480 -defaultsOSRD
preplace inst hdmiphy_ss_0 -pg 1 -lvl 7 -x 2820 -y 800 -defaultsOSRD
preplace inst gt_refclk_buf_ss_0 -pg 1 -lvl 6 -x 2270 -y 1110 -defaultsOSRD
preplace inst gt_refclk_buf_ss_1 -pg 1 -lvl 6 -x 2270 -y 1250 -defaultsOSRD
preplace inst gt_refclk_buf_ss_2 -pg 1 -lvl 6 -x 2270 -y 1600 -defaultsOSRD
preplace inst vfmc_ctlr_ss_0 -pg 1 -lvl 7 -x 2820 -y 1200 -defaultsOSRD
preplace inst axi_timer_0 -pg 1 -lvl 7 -x 2820 -y 1400 -defaultsOSRD
preplace inst ilconstant_0 -pg 1 -lvl 5 -x 1880 -y 760 -defaultsOSRD
preplace netloc Net 1 0 2 20 1270 320
preplace netloc axi_gpio_gpio_io_o 1 2 3 740 420 NJ 420 1690
preplace netloc axi_iic_0_iic2intc_irpt 1 7 1 NJ 480
preplace netloc axi_timer_0_interrupt 1 7 1 NJ 1430
preplace netloc hdmiphy_ss_0_irq 1 7 1 NJ 950
preplace netloc ilconstant_0_dout 1 5 1 2060 740n
preplace netloc ilconstant_1_dout 1 3 1 1110 160n
preplace netloc ilslice_5_Dout 1 3 1 NJ 260
preplace netloc net_bdry_in_IDT8T49N241_LOL_IN 1 0 7 20J 460 NJ 460 NJ 460 1150J 470 NJ 470 NJ 470 2560J
preplace netloc net_bdry_in_TX_HPD_IN 1 0 6 NJ 1080 NJ 1080 NJ 1080 NJ 1080 NJ 1080 2050J
preplace netloc net_cips_ss_0_clk_out2 1 2 5 730 720 1190 720 1700 820 2030 340 NJ
preplace netloc net_cips_ss_0_dcm_locked 1 3 3 1210 730 1710 1060 2060
preplace netloc net_cips_ss_0_frl_clk 1 2 4 740 1120 NJ 1120 NJ 1120 2070J
preplace netloc net_cips_ss_0_peripheral_aresetn 1 2 5 700 470 1140J 480 NJ 480 2020 510 2530
preplace netloc net_clkx_wiz_0_locked 1 2 1 710 1320n
preplace netloc net_gt_refclk_buf_ss_0_IBUFDSGT_ODIV2_OUT 1 6 1 2600 980n
preplace netloc net_gt_refclk_buf_ss_0_IBUFDSGT_OUT 1 6 1 2580 960n
preplace netloc net_gt_refclk_buf_ss_1_IBUFDSGT_ODIV2_OUT 1 6 1 2570 740n
preplace netloc net_gt_refclk_buf_ss_1_IBUFDSGT_OUT 1 6 1 2550 720n
preplace netloc net_gt_refclk_buf_ss_2_IBUFDSGT_ODIV2_OUT 1 6 1 2610 780n
preplace netloc net_gt_refclk_buf_ss_2_IBUFDSGT_OUT 1 6 1 2590 760n
preplace netloc net_hdmiphy_ss_0_rx_tmds_clk_n 1 7 1 NJ 870
preplace netloc net_hdmiphy_ss_0_rx_tmds_clk_p 1 7 1 NJ 850
preplace netloc net_hdmiphy_ss_0_rx_video_clk 1 4 4 1730 1170 NJ 1170 2620J 1080 3030
preplace netloc net_hdmiphy_ss_0_tx_video_clk 1 4 4 1740 1070 2010 1040 NJ 1040 3040
preplace netloc net_hdmiphy_ss_0_txoutclk 1 5 3 2090 1030 2450J 1050 3020
preplace netloc net_rst_processor_1_100M_interconnect_aresetn 1 2 1 720 610n
preplace netloc net_util_vector_logic_0_Res 1 1 1 NJ 1330
preplace netloc net_v_fifo_dc_b_de_out 1 5 1 2040 920n
preplace netloc net_v_hdmi_txss1_locked 1 6 2 2460J 1060 3040J
preplace netloc net_vcc_const_dout 1 4 3 1720 1090 2080J 1020 2560
preplace netloc net_vfmc_ctlr_ss_0_VFMC_RX_ONSEMI_ENABLE 1 7 1 NJ 1260
preplace netloc ps_wizard_0_pl0_ref_clk 1 0 7 NJ 1390 330 590 740 480 1130J 490 NJ 490 2070 490 2520
preplace netloc v_hdmi_txss1_irq 1 6 2 2470J 1070 NJ
preplace netloc v_mix_0_interrupt 1 4 4 NJ 360 NJ 360 2560J 400 NJ
preplace netloc Conn1 1 0 3 NJ 570 NJ 570 NJ
preplace netloc Conn2 1 7 1 NJ 70
preplace netloc Conn3 1 7 1 NJ 90
preplace netloc Conn4 1 7 1 NJ 110
preplace netloc Conn5 1 7 1 NJ 130
preplace netloc Conn6 1 7 1 NJ 210
preplace netloc Conn7 1 7 1 NJ 230
preplace netloc Conn8 1 7 1 NJ 250
preplace netloc Conn9 1 7 1 NJ 270
preplace netloc Conn10 1 7 1 NJ 290
preplace netloc Conn11 1 7 1 NJ 310
preplace netloc Conn12 1 7 1 NJ 330
preplace netloc axi_noc2_0_M04_INI 1 7 1 NJ 150
preplace netloc axi_noc2_0_M05_INI 1 7 1 NJ 170
preplace netloc axi_noc2_0_M06_INI 1 7 1 NJ 190
preplace netloc axi_smartconnect_0_M01_AXI 1 3 4 1170 520 NJ 520 NJ 520 2490J
preplace netloc axi_smartconnect_0_M03_AXI 1 3 4 1160 460 NJ 460 NJ 460 NJ
preplace netloc axi_smartconnect_0_M05_AXI 1 3 1 1170 620n
preplace netloc intf_net_bdry_in_GT_DRU_FRL_CLK_IN 1 0 6 NJ 1110 NJ 1110 NJ 1110 NJ 1110 NJ 1110 NJ
preplace netloc intf_net_bdry_in_HDMI_RX_CLK_P_IN_V 1 0 6 NJ 1600 NJ 1600 NJ 1600 NJ 1600 NJ 1600 NJ
preplace netloc intf_net_bdry_in_TX_REFCLK_P_IN_V 1 0 6 NJ 1250 NJ 1250 NJ 1250 NJ 1250 NJ 1250 NJ
preplace netloc intf_net_cips_ss_0_IIC 1 7 1 NJ 460
preplace netloc intf_net_cips_ss_0_M00_AXI 1 3 4 NJ 540 NJ 540 2010J 530 2550
preplace netloc intf_net_cips_ss_0_M02_AXI 1 3 3 1180J 560 NJ 560 2060
preplace netloc intf_net_hdmiphy_ss_0_phy_data 1 7 1 NJ 650
preplace netloc intf_net_hdmiphy_ss_0_vid_phy_status_sb_tx 1 5 3 2090 540 2540J 560 3020
preplace netloc intf_net_tx_video_axis_reg_slice_M_AXIS 1 5 1 2010 640n
preplace netloc intf_net_v_hdmi_txss1_DDC_OUT 1 6 2 2510J 1030 NJ
preplace netloc intf_net_v_hdmi_txss1_LINK_DATA0_OUT 1 6 1 2450 620n
preplace netloc intf_net_v_hdmi_txss1_LINK_DATA1_OUT 1 6 1 2460 640n
preplace netloc intf_net_v_hdmi_txss1_LINK_DATA2_OUT 1 6 1 2470 660n
preplace netloc intf_net_v_hdmi_txss1_LINK_DATA3_OUT 1 6 1 2480 680n
preplace netloc v_mix_0_m_axi_mm_video1 1 4 3 N 60 NJ 60 2490J
preplace netloc v_mix_0_m_axi_mm_video2 1 4 3 1710 100 NJ 100 NJ
preplace netloc v_mix_0_m_axi_mm_video3 1 4 3 1700 120 NJ 120 NJ
preplace netloc v_mix_0_m_axi_mm_video4 1 4 3 1690 70 NJ 70 2560J
preplace netloc v_mix_0_m_axi_mm_video5 1 4 3 N 140 NJ 140 NJ
preplace netloc v_mix_0_m_axi_mm_video6 1 4 3 N 160 NJ 160 NJ
preplace netloc v_mix_0_m_axi_mm_video7 1 4 3 N 180 NJ 180 NJ
preplace netloc v_mix_0_m_axi_mm_video8 1 4 3 N 200 NJ 200 NJ
preplace netloc v_mix_0_m_axi_mm_video9 1 4 3 N 220 NJ 220 NJ
preplace netloc v_mix_0_m_axi_mm_video10 1 4 3 N 240 NJ 240 NJ
preplace netloc v_mix_0_m_axi_mm_video11 1 4 3 N 260 NJ 260 NJ
preplace netloc v_mix_0_m_axi_mm_video12 1 4 3 N 280 NJ 280 NJ
preplace netloc v_mix_0_m_axi_mm_video13 1 4 3 N 300 NJ 300 NJ
preplace netloc v_mix_0_m_axi_mm_video14 1 4 3 N 320 NJ 320 NJ
preplace netloc v_mix_0_m_axis_video 1 4 1 1710 340n
preplace netloc axi_smartconnect_0_M04_AXI 1 3 1 1120 160n
preplace netloc axi_smartconnect_0_M06_AXI 1 3 4 1200J 500 NJ 500 NJ 500 2500
levelinfo -pg 1 0 170 520 930 1450 1880 2270 2820 3060
pagesize -pg 1 -db -bbox -sgen -210 0 3250 1660
"
}

  # Restore current instance
  current_bd_instance $oldCurInst
}


proc available_tcl_procs { } {
   puts "##################################################################"
   puts "# Available Tcl procedures to recreate hierarchical blocks:"
   puts "#"
   puts "#    create_hier_cell_hdmi_tx_ss_hier parentCell nameHier"
   puts "#    create_hier_cell_hdmiphy_ss_0 parentCell nameHier"
   puts "#    create_hier_cell_gt_refclk_buf_ss_0 parentCell nameHier"
   puts "#    create_hier_cell_gt_refclk_buf_ss_1 parentCell nameHier"
   puts "#    create_hier_cell_gt_refclk_buf_ss_2 parentCell nameHier"
   puts "#    create_hier_cell_vfmc_ctlr_ss_0 parentCell nameHier"
   puts "#"
   puts "##################################################################"
}

available_tcl_procs

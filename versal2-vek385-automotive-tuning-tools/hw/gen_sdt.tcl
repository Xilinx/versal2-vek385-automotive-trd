# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
# -----------------------------------------------

# parse arguments
for { set i 0 } { $i < $argc } { incr i } {
  # xsa path
  if { [lindex $argv $i] == "-xsa_path" } {
    incr i
    set xsa_path [lindex $argv $i]
  }
}

set script_dir [file dirname [file normalize [info script]]]
set sdt_repo_url "https://github.com/Xilinx/system-device-tree-xlnx.git"
set sdt_repo_branch "xilinx_v2026.1"
set sdt_repo_dir "$script_dir/system-device-tree-xlnx"
set sdt_patch "$script_dir/0001-isp-add-SP2-and-RAW-output-port-support-in-graph-gen.patch"

# clone system-device-tree-xlnx if not already present
if { ![file isdirectory "$sdt_repo_dir/.git"] } {
  exec git clone -b $sdt_repo_branch $sdt_repo_url $sdt_repo_dir >@stdout 2>@stderr
}

# apply the ISP SP2/RAW output port patch (skip if already applied)
if { [catch {exec git -C $sdt_repo_dir apply --check --reverse $sdt_patch}] } {
  if { [catch {exec git -C $sdt_repo_dir am $sdt_patch >@stdout 2>@stderr} err] } {
    catch {exec git -C $sdt_repo_dir am --abort}
    error "Failed to apply patch $sdt_patch: $err"
  }
}

set ::env(CUSTOM_SDT_REPO) [file normalize $sdt_repo_dir]

sdtgen set_dt_param -debug enable
sdtgen set_dt_param -dir ./Versal2_T50_Tuning_trd_sdt
sdtgen set_dt_param -xsa $xsa_path
sdtgen set_dt_param -board_dts versal2-vek385-revb
sdtgen generate_sdt

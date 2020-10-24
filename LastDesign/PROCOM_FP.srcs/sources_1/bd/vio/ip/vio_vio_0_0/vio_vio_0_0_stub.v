// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Thu Oct 22 10:15:19 2020
// Host        : DESKTOP-24EKN4F running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/PROCOM_FP/PROCOM_FP.srcs/sources_1/bd/vio/ip/vio_vio_0_0/vio_vio_0_0_stub.v
// Design      : vio_vio_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35ticsg324-1L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2019.2" *)
module vio_vio_0_0(clk, probe_in0, probe_in1, probe_in2, probe_in3)
/* synthesis syn_black_box black_box_pad_pin="clk,probe_in0[2:0],probe_in1[2:0],probe_in2[2:0],probe_in3[2:0]" */;
  input clk;
  input [2:0]probe_in0;
  input [2:0]probe_in1;
  input [2:0]probe_in2;
  input [2:0]probe_in3;
endmodule

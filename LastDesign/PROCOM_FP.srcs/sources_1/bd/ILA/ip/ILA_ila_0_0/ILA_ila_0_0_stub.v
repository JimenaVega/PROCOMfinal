// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Fri Aug 28 21:53:25 2020
// Host        : DESKTOP-24EKN4F running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/asus/PROCOM2020/RUN/PROCOM_FP/PROCOM_FP.srcs/sources_1/bd/ILA/ip/ILA_ila_0_0/ILA_ila_0_0_stub.v
// Design      : ILA_ila_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35ticsg324-1L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2019.2" *)
module ILA_ila_0_0(clk, probe0, probe1, probe2, probe3, probe4)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[2:0],probe1[2:0],probe2[2:0],probe3[2:0],probe4[3:0]" */;
  input clk;
  input [2:0]probe0;
  input [2:0]probe1;
  input [2:0]probe2;
  input [2:0]probe3;
  input [3:0]probe4;
endmodule

//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
//Date        : Sat Aug 29 12:05:20 2020
//Host        : DESKTOP-24EKN4F running 64-bit major release  (build 9200)
//Command     : generate_target ila.bd
//Design      : ila
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "ila,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=ila,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "ila.hwdef" *) 
module ila
   (clk_0,
    probe0_0,
    probe1_0,
    probe2_0,
    probe3_0,
    probe4_0);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_0, CLK_DOMAIN ila_clk_0, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000" *) input clk_0;
  input [2:0]probe0_0;
  input [2:0]probe1_0;
  input [2:0]probe2_0;
  input [2:0]probe3_0;
  input [3:0]probe4_0;

  wire clk_0_1;
  wire [2:0]probe0_0_1;
  wire [2:0]probe1_0_1;
  wire [2:0]probe2_0_1;
  wire [2:0]probe3_0_1;
  wire [3:0]probe4_0_1;

  assign clk_0_1 = clk_0;
  assign probe0_0_1 = probe0_0[2:0];
  assign probe1_0_1 = probe1_0[2:0];
  assign probe2_0_1 = probe2_0[2:0];
  assign probe3_0_1 = probe3_0[2:0];
  assign probe4_0_1 = probe4_0[3:0];
  ila_ila_0_0 ila_0
       (.clk(clk_0_1),
        .probe0(probe0_0_1),
        .probe1(probe1_0_1),
        .probe2(probe2_0_1),
        .probe3(probe3_0_1),
        .probe4(probe4_0_1));
endmodule

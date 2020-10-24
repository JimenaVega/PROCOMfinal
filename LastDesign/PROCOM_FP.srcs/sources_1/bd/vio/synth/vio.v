//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
//Date        : Thu Oct 22 10:12:07 2020
//Host        : DESKTOP-24EKN4F running 64-bit major release  (build 9200)
//Command     : generate_target vio.bd
//Design      : vio
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "vio,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=vio,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "vio.hwdef" *) 
module vio
   (clk_0,
    probe_in0_0,
    probe_in1_0,
    probe_in2_0,
    probe_in3_0);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_0, CLK_DOMAIN vio_clk_0, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000" *) input clk_0;
  input [2:0]probe_in0_0;
  input [2:0]probe_in1_0;
  input [2:0]probe_in2_0;
  input [2:0]probe_in3_0;

  wire clk_0_1;
  wire [2:0]probe_in0_0_1;
  wire [2:0]probe_in1_0_1;
  wire [2:0]probe_in2_0_1;
  wire [2:0]probe_in3_0_1;

  assign clk_0_1 = clk_0;
  assign probe_in0_0_1 = probe_in0_0[2:0];
  assign probe_in1_0_1 = probe_in1_0[2:0];
  assign probe_in2_0_1 = probe_in2_0[2:0];
  assign probe_in3_0_1 = probe_in3_0[2:0];
  vio_vio_0_0 vio_0
       (.clk(clk_0_1),
        .probe_in0(probe_in0_0_1),
        .probe_in1(probe_in1_0_1),
        .probe_in2(probe_in2_0_1),
        .probe_in3(probe_in3_0_1));
endmodule

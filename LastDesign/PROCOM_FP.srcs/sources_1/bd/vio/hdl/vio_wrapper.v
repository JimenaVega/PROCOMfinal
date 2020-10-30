//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
//Date        : Thu Oct 22 10:12:07 2020
//Host        : DESKTOP-24EKN4F running 64-bit major release  (build 9200)
//Command     : generate_target vio_wrapper.bd
//Design      : vio_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module vio_wrapper
   (clk_0,
    probe_in0_0,
    probe_in1_0,
    probe_in2_0,
    probe_in3_0);
  input clk_0;
  input [2:0]probe_in0_0;
  input [2:0]probe_in1_0;
  input [2:0]probe_in2_0;
  input [2:0]probe_in3_0;

  wire clk_0;
  wire [2:0]probe_in0_0;
  wire [2:0]probe_in1_0;
  wire [2:0]probe_in2_0;
  wire [2:0]probe_in3_0;

  vio vio_i
       (.clk_0(clk_0),
        .probe_in0_0(probe_in0_0),
        .probe_in1_0(probe_in1_0),
        .probe_in2_0(probe_in2_0),
        .probe_in3_0(probe_in3_0));
endmodule

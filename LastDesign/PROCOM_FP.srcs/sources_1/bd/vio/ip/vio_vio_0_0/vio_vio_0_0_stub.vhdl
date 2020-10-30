-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
-- Date        : Thu Oct 22 10:15:19 2020
-- Host        : DESKTOP-24EKN4F running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               C:/PROCOM_FP/PROCOM_FP.srcs/sources_1/bd/vio/ip/vio_vio_0_0/vio_vio_0_0_stub.vhdl
-- Design      : vio_vio_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35ticsg324-1L
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vio_vio_0_0 is
  Port ( 
    clk : in STD_LOGIC;
    probe_in0 : in STD_LOGIC_VECTOR ( 2 downto 0 );
    probe_in1 : in STD_LOGIC_VECTOR ( 2 downto 0 );
    probe_in2 : in STD_LOGIC_VECTOR ( 2 downto 0 );
    probe_in3 : in STD_LOGIC_VECTOR ( 2 downto 0 )
  );

end vio_vio_0_0;

architecture stub of vio_vio_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe_in0[2:0],probe_in1[2:0],probe_in2[2:0],probe_in3[2:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "vio,Vivado 2019.2";
begin
end;

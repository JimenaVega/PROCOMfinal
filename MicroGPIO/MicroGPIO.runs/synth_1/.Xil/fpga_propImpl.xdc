set_property SRC_FILE_INFO {cfile:c:/Users/miner/Documents/JIME/4toAnio/procom/vivado_stuff/MicroGPIO/MicroGPIO.srcs/sources_1/bd/MicroGPIO/ip/MicroGPIO_clk_wiz_0_1/MicroGPIO_clk_wiz_0_1/MicroGPIO_clk_wiz_0_1_in_context.xdc rfile:../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ip/MicroGPIO_clk_wiz_0_1/MicroGPIO_clk_wiz_0_1/MicroGPIO_clk_wiz_0_1_in_context.xdc id:1 order:EARLY scoped_inst:u_micro/clk_wiz_0} [current_design]
set_property SRC_FILE_INFO {cfile:c:/Users/miner/Documents/JIME/4toAnio/procom/vivado_stuff/MicroGPIO/MicroGPIO.srcs/sources_1/bd/MicroGPIO/ip/MicroGPIO_dlmb_bram_if_cntlr_1/MicroGPIO_dlmb_bram_if_cntlr_1/MicroGPIO_dlmb_bram_if_cntlr_1_in_context.xdc rfile:../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ip/MicroGPIO_dlmb_bram_if_cntlr_1/MicroGPIO_dlmb_bram_if_cntlr_1/MicroGPIO_dlmb_bram_if_cntlr_1_in_context.xdc id:2 order:EARLY scoped_inst:u_micro/microblaze_0_local_memory/dlmb_bram_if_cntlr} [current_design]
set_property SRC_FILE_INFO {cfile:c:/Users/miner/Documents/JIME/4toAnio/procom/vivado_stuff/MicroGPIO/MicroGPIO.srcs/sources_1/bd/MicroGPIO/ip/MicroGPIO_ilmb_bram_if_cntlr_1/MicroGPIO_ilmb_bram_if_cntlr_1/MicroGPIO_ilmb_bram_if_cntlr_1_in_context.xdc rfile:../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ip/MicroGPIO_ilmb_bram_if_cntlr_1/MicroGPIO_ilmb_bram_if_cntlr_1/MicroGPIO_ilmb_bram_if_cntlr_1_in_context.xdc id:3 order:EARLY scoped_inst:u_micro/microblaze_0_local_memory/ilmb_bram_if_cntlr} [current_design]
set_property SRC_FILE_INFO {cfile:c:/Users/miner/Documents/JIME/4toAnio/procom/vivado_stuff/MicroGPIO/MicroGPIO.srcs/sources_1/bd/MicroGPIO/ip/MicroGPIO_mdm_1_1/MicroGPIO_mdm_1_1/MicroGPIO_mdm_1_1_in_context.xdc rfile:../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ip/MicroGPIO_mdm_1_1/MicroGPIO_mdm_1_1/MicroGPIO_mdm_1_1_in_context.xdc id:4 order:EARLY scoped_inst:u_micro/mdm_1} [current_design]
set_property SRC_FILE_INFO {cfile:C:/Users/miner/Documents/JIME/4toAnio/procom/vivado_stuff/rtl_procom/top_board/Arty_Master.xdc rfile:../../../../rtl_procom/top_board/Arty_Master.xdc id:5} [current_design]
current_instance u_micro/clk_wiz_0
set_property src_info {type:SCOPED_XDC file:1 line:1 export:INPUT save:INPUT read:READ} [current_design]
create_clock -period 10.000 [get_ports -no_traverse {}]
set_property src_info {type:SCOPED_XDC file:1 line:4 export:INPUT save:INPUT read:READ} [current_design]
create_generated_clock -source [get_ports clk_in1] -edges {1 2 3} -edge_shift {0.000 0.000 0.000} [get_ports {}]
current_instance
current_instance u_micro/microblaze_0_local_memory/dlmb_bram_if_cntlr
set_property src_info {type:SCOPED_XDC file:2 line:2 export:INPUT save:INPUT read:READ} [current_design]
create_clock -period 10.000 [get_ports {}]
current_instance
current_instance u_micro/microblaze_0_local_memory/ilmb_bram_if_cntlr
set_property src_info {type:SCOPED_XDC file:3 line:2 export:INPUT save:INPUT read:READ} [current_design]
create_clock -period 10.000 [get_ports {}]
current_instance
current_instance u_micro/mdm_1
set_property src_info {type:SCOPED_XDC file:4 line:2 export:INPUT save:INPUT read:READ} [current_design]
create_clock -period 33.333 [get_ports {}]
set_property src_info {type:SCOPED_XDC file:4 line:4 export:INPUT save:INPUT read:READ} [current_design]
create_clock -period 33.333 [get_ports {}]
current_instance
set_property src_info {type:XDC file:5 line:8 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk100 }]; #IO_L12P_T1_MRCC_35 Sch=gclk[100]
set_property src_info {type:XDC file:5 line:12 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN A8    IOSTANDARD LVCMOS33 } [get_ports { i_sw[0] }]; #IO_L12N_T1_MRCC_16 Sch=sw[0]
set_property src_info {type:XDC file:5 line:13 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN C11   IOSTANDARD LVCMOS33 } [get_ports { i_sw[1] }]; #IO_L13P_T2_MRCC_16 Sch=sw[1]
set_property src_info {type:XDC file:5 line:14 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN C10   IOSTANDARD LVCMOS33 } [get_ports { i_sw[2] }]; #IO_L13N_T2_MRCC_16 Sch=sw[2]
set_property src_info {type:XDC file:5 line:15 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN A10   IOSTANDARD LVCMOS33 } [get_ports { i_sw[3] }]; #IO_L14P_T2_SRCC_16 Sch=sw[3]
set_property src_info {type:XDC file:5 line:18 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN G6    IOSTANDARD LVCMOS33 } [get_ports { out_leds_rgb0[0] }]; #IO_L18N_T2_35 Sch=led0_b
set_property src_info {type:XDC file:5 line:19 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN F6    IOSTANDARD LVCMOS33 } [get_ports { out_leds_rgb0[1] }]; #IO_L19N_T3_VREF_35 Sch=led0_g
set_property src_info {type:XDC file:5 line:20 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN E1    IOSTANDARD LVCMOS33 } [get_ports { out_leds_rgb0[2] }]; #IO_L19P_T3_35 Sch=led0_r
set_property src_info {type:XDC file:5 line:21 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN G3    IOSTANDARD LVCMOS33 } [get_ports { out_leds_rgb1[0] }]; #IO_L20P_T3_35 Sch=led1_b
set_property src_info {type:XDC file:5 line:22 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN J4    IOSTANDARD LVCMOS33 } [get_ports { out_leds_rgb1[1] }]; #IO_L21P_T3_DQS_35 Sch=led1_g
set_property src_info {type:XDC file:5 line:23 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN G4    IOSTANDARD LVCMOS33 } [get_ports { out_leds_rgb1[2] }]; #IO_L20N_T3_35 Sch=led1_r
set_property src_info {type:XDC file:5 line:24 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN J3    IOSTANDARD LVCMOS33 } [get_ports { out_leds_rgb2[0] }]; #IO_L21N_T3_DQS_35 Sch=led2_b
set_property src_info {type:XDC file:5 line:25 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN J2    IOSTANDARD LVCMOS33 } [get_ports { out_leds_rgb2[1] }]; #IO_L22N_T3_35 Sch=led2_g
set_property src_info {type:XDC file:5 line:26 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN H4    IOSTANDARD LVCMOS33 } [get_ports { out_leds_rgb2[2] }]; #IO_L22P_T3_35 Sch=led2_r
set_property src_info {type:XDC file:5 line:27 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN K1    IOSTANDARD LVCMOS33 } [get_ports { out_leds_rgb3[0] }]; #IO_L23P_T3_35 Sch=led3_b
set_property src_info {type:XDC file:5 line:28 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN H6    IOSTANDARD LVCMOS33 } [get_ports { out_leds_rgb3[1] }]; #IO_L24P_T3_35 Sch=led3_g
set_property src_info {type:XDC file:5 line:29 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN K2    IOSTANDARD LVCMOS33 } [get_ports { out_leds_rgb3[2] }]; #IO_L23N_T3_35 Sch=led3_r
set_property src_info {type:XDC file:5 line:33 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN H5    IOSTANDARD LVCMOS33 } [get_ports { out_leds[0] }]; #IO_L24N_T3_35 Sch=led[4]
set_property src_info {type:XDC file:5 line:34 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN J5    IOSTANDARD LVCMOS33 } [get_ports { out_leds[1] }]; #IO_25_35 Sch=led[5]
set_property src_info {type:XDC file:5 line:35 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { out_leds[2] }]; #IO_L24P_T3_A01_D17_14 Sch=led[6]
set_property src_info {type:XDC file:5 line:36 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { out_leds[3] }]; #IO_L24N_T3_A00_D16_14 Sch=led[7]
set_property src_info {type:XDC file:5 line:91 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { out_tx_uart }]; #IO_L19N_T3_VREF_16 Sch=uart_rxd_out
set_property src_info {type:XDC file:5 line:92 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN A9    IOSTANDARD LVCMOS33 } [get_ports { in_rx_uart  }]; #IO_L14N_T2_SRCC_16 Sch=uart_txd_in
set_property src_info {type:XDC file:5 line:184 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN C2    IOSTANDARD LVCMOS33 } [get_ports { in_reset }]; #IO_L16P_T2_35 Sch=ck_rst

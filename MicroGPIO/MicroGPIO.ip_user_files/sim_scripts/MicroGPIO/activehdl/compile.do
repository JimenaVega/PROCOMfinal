vlib work
vlib activehdl

vlib activehdl/xpm
vlib activehdl/xil_defaultlib
vlib activehdl/microblaze_v11_0_3
vlib activehdl/lmb_v10_v3_0_11
vlib activehdl/lmb_bram_if_cntlr_v4_0_18
vlib activehdl/blk_mem_gen_v8_4_4
vlib activehdl/axi_lite_ipif_v3_0_4
vlib activehdl/mdm_v3_2_18
vlib activehdl/lib_cdc_v1_0_2
vlib activehdl/proc_sys_reset_v5_0_13
vlib activehdl/lib_pkg_v1_0_2
vlib activehdl/lib_srl_fifo_v1_0_2
vlib activehdl/axi_uartlite_v2_0_25
vlib activehdl/generic_baseblocks_v2_1_0
vlib activehdl/axi_infrastructure_v1_1_0
vlib activehdl/axi_register_slice_v2_1_21
vlib activehdl/fifo_generator_v13_2_5
vlib activehdl/axi_data_fifo_v2_1_20
vlib activehdl/axi_crossbar_v2_1_22
vlib activehdl/interrupt_control_v3_1_4
vlib activehdl/axi_gpio_v2_0_23

vmap xpm activehdl/xpm
vmap xil_defaultlib activehdl/xil_defaultlib
vmap microblaze_v11_0_3 activehdl/microblaze_v11_0_3
vmap lmb_v10_v3_0_11 activehdl/lmb_v10_v3_0_11
vmap lmb_bram_if_cntlr_v4_0_18 activehdl/lmb_bram_if_cntlr_v4_0_18
vmap blk_mem_gen_v8_4_4 activehdl/blk_mem_gen_v8_4_4
vmap axi_lite_ipif_v3_0_4 activehdl/axi_lite_ipif_v3_0_4
vmap mdm_v3_2_18 activehdl/mdm_v3_2_18
vmap lib_cdc_v1_0_2 activehdl/lib_cdc_v1_0_2
vmap proc_sys_reset_v5_0_13 activehdl/proc_sys_reset_v5_0_13
vmap lib_pkg_v1_0_2 activehdl/lib_pkg_v1_0_2
vmap lib_srl_fifo_v1_0_2 activehdl/lib_srl_fifo_v1_0_2
vmap axi_uartlite_v2_0_25 activehdl/axi_uartlite_v2_0_25
vmap generic_baseblocks_v2_1_0 activehdl/generic_baseblocks_v2_1_0
vmap axi_infrastructure_v1_1_0 activehdl/axi_infrastructure_v1_1_0
vmap axi_register_slice_v2_1_21 activehdl/axi_register_slice_v2_1_21
vmap fifo_generator_v13_2_5 activehdl/fifo_generator_v13_2_5
vmap axi_data_fifo_v2_1_20 activehdl/axi_data_fifo_v2_1_20
vmap axi_crossbar_v2_1_22 activehdl/axi_crossbar_v2_1_22
vmap interrupt_control_v3_1_4 activehdl/interrupt_control_v3_1_4
vmap axi_gpio_v2_0_23 activehdl/axi_gpio_v2_0_23

vlog -work xpm  -sv2k12 "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/8b3d" "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/ec67/hdl" \
"C:/xilinx/Vivado/2020.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/xilinx/Vivado/2020.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"C:/xilinx/Vivado/2020.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/8b3d" "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/ec67/hdl" \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ip/MicroGPIO_clk_wiz_0_1/MicroGPIO_clk_wiz_0_1_clk_wiz.v" \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ip/MicroGPIO_clk_wiz_0_1/MicroGPIO_clk_wiz_0_1.v" \

vcom -work microblaze_v11_0_3 -93 \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/1efc/hdl/microblaze_v11_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ip/MicroGPIO_microblaze_0_1/sim/MicroGPIO_microblaze_0_1.vhd" \

vcom -work lmb_v10_v3_0_11 -93 \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/c2ed/hdl/lmb_v10_v3_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ip/MicroGPIO_dlmb_v10_1/sim/MicroGPIO_dlmb_v10_1.vhd" \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ip/MicroGPIO_ilmb_v10_1/sim/MicroGPIO_ilmb_v10_1.vhd" \

vcom -work lmb_bram_if_cntlr_v4_0_18 -93 \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/246e/hdl/lmb_bram_if_cntlr_v4_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ip/MicroGPIO_dlmb_bram_if_cntlr_1/sim/MicroGPIO_dlmb_bram_if_cntlr_1.vhd" \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ip/MicroGPIO_ilmb_bram_if_cntlr_1/sim/MicroGPIO_ilmb_bram_if_cntlr_1.vhd" \

vlog -work blk_mem_gen_v8_4_4  -v2k5 "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/8b3d" "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/ec67/hdl" \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/2985/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/8b3d" "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/ec67/hdl" \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ip/MicroGPIO_lmb_bram_1/sim/MicroGPIO_lmb_bram_1.v" \

vcom -work axi_lite_ipif_v3_0_4 -93 \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/66ea/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \

vcom -work mdm_v3_2_18 -93 \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/e9fa/hdl/mdm_v3_2_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ip/MicroGPIO_mdm_1_1/sim/MicroGPIO_mdm_1_1.vhd" \

vcom -work lib_cdc_v1_0_2 -93 \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_13 -93 \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ip/MicroGPIO_rst_clk_wiz_0_100M_1/sim/MicroGPIO_rst_clk_wiz_0_100M_1.vhd" \

vcom -work lib_pkg_v1_0_2 -93 \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/0513/hdl/lib_pkg_v1_0_rfs.vhd" \

vcom -work lib_srl_fifo_v1_0_2 -93 \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/51ce/hdl/lib_srl_fifo_v1_0_rfs.vhd" \

vcom -work axi_uartlite_v2_0_25 -93 \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/43b7/hdl/axi_uartlite_v2_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ip/MicroGPIO_axi_uartlite_0_1/sim/MicroGPIO_axi_uartlite_0_1.vhd" \

vlog -work generic_baseblocks_v2_1_0  -v2k5 "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/8b3d" "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/ec67/hdl" \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_infrastructure_v1_1_0  -v2k5 "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/8b3d" "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/ec67/hdl" \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_21  -v2k5 "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/8b3d" "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/ec67/hdl" \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/2ef9/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work fifo_generator_v13_2_5  -v2k5 "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/8b3d" "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/ec67/hdl" \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/276e/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_5 -93 \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/276e/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_5  -v2k5 "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/8b3d" "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/ec67/hdl" \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/276e/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work axi_data_fifo_v2_1_20  -v2k5 "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/8b3d" "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/ec67/hdl" \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/47c9/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_22  -v2k5 "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/8b3d" "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/ec67/hdl" \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/b68e/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/8b3d" "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/ec67/hdl" \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ip/MicroGPIO_xbar_0/sim/MicroGPIO_xbar_0.v" \

vcom -work interrupt_control_v3_1_4 -93 \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/a040/hdl/interrupt_control_v3_1_vh_rfs.vhd" \

vcom -work axi_gpio_v2_0_23 -93 \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/bb35/hdl/axi_gpio_v2_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ip/MicroGPIO_axi_gpio_0_1/sim/MicroGPIO_axi_gpio_0_1.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/8b3d" "+incdir+../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/ipshared/ec67/hdl" \
"../../../../MicroGPIO.srcs/sources_1/bd/MicroGPIO/sim/MicroGPIO.v" \

vlog -work xil_defaultlib \
"glbl.v"


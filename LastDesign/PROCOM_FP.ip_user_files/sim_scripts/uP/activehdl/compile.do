vlib work
vlib activehdl

vlib activehdl/xpm
vlib activehdl/xil_defaultlib
vlib activehdl/microblaze_v11_0_2
vlib activehdl/lmb_v10_v3_0_10
vlib activehdl/lmb_bram_if_cntlr_v4_0_17
vlib activehdl/blk_mem_gen_v8_4_4
vlib activehdl/generic_baseblocks_v2_1_0
vlib activehdl/axi_infrastructure_v1_1_0
vlib activehdl/axi_register_slice_v2_1_20
vlib activehdl/fifo_generator_v13_2_5
vlib activehdl/axi_data_fifo_v2_1_19
vlib activehdl/axi_crossbar_v2_1_21
vlib activehdl/axi_lite_ipif_v3_0_4
vlib activehdl/axi_intc_v4_1_14
vlib activehdl/xlconcat_v2_1_3
vlib activehdl/mdm_v3_2_17
vlib activehdl/lib_cdc_v1_0_2
vlib activehdl/proc_sys_reset_v5_0_13
vlib activehdl/lib_pkg_v1_0_2
vlib activehdl/lib_srl_fifo_v1_0_2
vlib activehdl/axi_uartlite_v2_0_24
vlib activehdl/lib_fifo_v1_0_14
vlib activehdl/axi_datamover_v5_1_22
vlib activehdl/axi_sg_v4_1_13
vlib activehdl/axi_dma_v7_1_21
vlib activehdl/axis_infrastructure_v1_1_0
vlib activehdl/axis_data_fifo_v2_0_2
vlib activehdl/axi_protocol_converter_v2_1_20
vlib activehdl/axi_clock_converter_v2_1_19
vlib activehdl/axi_dwidth_converter_v2_1_20

vmap xpm activehdl/xpm
vmap xil_defaultlib activehdl/xil_defaultlib
vmap microblaze_v11_0_2 activehdl/microblaze_v11_0_2
vmap lmb_v10_v3_0_10 activehdl/lmb_v10_v3_0_10
vmap lmb_bram_if_cntlr_v4_0_17 activehdl/lmb_bram_if_cntlr_v4_0_17
vmap blk_mem_gen_v8_4_4 activehdl/blk_mem_gen_v8_4_4
vmap generic_baseblocks_v2_1_0 activehdl/generic_baseblocks_v2_1_0
vmap axi_infrastructure_v1_1_0 activehdl/axi_infrastructure_v1_1_0
vmap axi_register_slice_v2_1_20 activehdl/axi_register_slice_v2_1_20
vmap fifo_generator_v13_2_5 activehdl/fifo_generator_v13_2_5
vmap axi_data_fifo_v2_1_19 activehdl/axi_data_fifo_v2_1_19
vmap axi_crossbar_v2_1_21 activehdl/axi_crossbar_v2_1_21
vmap axi_lite_ipif_v3_0_4 activehdl/axi_lite_ipif_v3_0_4
vmap axi_intc_v4_1_14 activehdl/axi_intc_v4_1_14
vmap xlconcat_v2_1_3 activehdl/xlconcat_v2_1_3
vmap mdm_v3_2_17 activehdl/mdm_v3_2_17
vmap lib_cdc_v1_0_2 activehdl/lib_cdc_v1_0_2
vmap proc_sys_reset_v5_0_13 activehdl/proc_sys_reset_v5_0_13
vmap lib_pkg_v1_0_2 activehdl/lib_pkg_v1_0_2
vmap lib_srl_fifo_v1_0_2 activehdl/lib_srl_fifo_v1_0_2
vmap axi_uartlite_v2_0_24 activehdl/axi_uartlite_v2_0_24
vmap lib_fifo_v1_0_14 activehdl/lib_fifo_v1_0_14
vmap axi_datamover_v5_1_22 activehdl/axi_datamover_v5_1_22
vmap axi_sg_v4_1_13 activehdl/axi_sg_v4_1_13
vmap axi_dma_v7_1_21 activehdl/axi_dma_v7_1_21
vmap axis_infrastructure_v1_1_0 activehdl/axis_infrastructure_v1_1_0
vmap axis_data_fifo_v2_0_2 activehdl/axis_data_fifo_v2_0_2
vmap axi_protocol_converter_v2_1_20 activehdl/axi_protocol_converter_v2_1_20
vmap axi_clock_converter_v2_1_19 activehdl/axi_clock_converter_v2_1_19
vmap axi_dwidth_converter_v2_1_20 activehdl/axi_dwidth_converter_v2_1_20

vlog -work xpm  -sv2k12 "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/4fba" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/ec67/hdl" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/8713/hdl" \
"C:/xilinx/Vivado/2019.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/xilinx/Vivado/2019.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"C:/xilinx/Vivado/2019.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"C:/xilinx/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/4fba" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/ec67/hdl" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/8713/hdl" \
"../../../bd/uP/ip/uP_clk_wiz_0_0/uP_clk_wiz_0_0_clk_wiz.v" \
"../../../bd/uP/ip/uP_clk_wiz_0_0/uP_clk_wiz_0_0.v" \

vcom -work microblaze_v11_0_2 -93 \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/f871/hdl/microblaze_v11_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/uP/ip/uP_microblaze_0_0/sim/uP_microblaze_0_0.vhd" \

vcom -work lmb_v10_v3_0_10 -93 \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/2e88/hdl/lmb_v10_v3_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/uP/ip/uP_dlmb_v10_1/sim/uP_dlmb_v10_1.vhd" \
"../../../bd/uP/ip/uP_ilmb_v10_1/sim/uP_ilmb_v10_1.vhd" \

vcom -work lmb_bram_if_cntlr_v4_0_17 -93 \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/db6f/hdl/lmb_bram_if_cntlr_v4_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/uP/ip/uP_dlmb_bram_if_cntlr_1/sim/uP_dlmb_bram_if_cntlr_1.vhd" \
"../../../bd/uP/ip/uP_ilmb_bram_if_cntlr_1/sim/uP_ilmb_bram_if_cntlr_1.vhd" \

vlog -work blk_mem_gen_v8_4_4  -v2k5 "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/4fba" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/ec67/hdl" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/8713/hdl" \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/2985/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/4fba" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/ec67/hdl" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/8713/hdl" \
"../../../bd/uP/ip/uP_lmb_bram_1/sim/uP_lmb_bram_1.v" \

vlog -work generic_baseblocks_v2_1_0  -v2k5 "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/4fba" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/ec67/hdl" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/8713/hdl" \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_infrastructure_v1_1_0  -v2k5 "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/4fba" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/ec67/hdl" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/8713/hdl" \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_20  -v2k5 "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/4fba" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/ec67/hdl" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/8713/hdl" \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/72d4/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work fifo_generator_v13_2_5  -v2k5 "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/4fba" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/ec67/hdl" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/8713/hdl" \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/276e/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_5 -93 \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/276e/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_5  -v2k5 "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/4fba" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/ec67/hdl" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/8713/hdl" \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/276e/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work axi_data_fifo_v2_1_19  -v2k5 "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/4fba" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/ec67/hdl" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/8713/hdl" \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/60de/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_21  -v2k5 "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/4fba" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/ec67/hdl" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/8713/hdl" \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/6b0d/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/4fba" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/ec67/hdl" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/8713/hdl" \
"../../../bd/uP/ip/uP_xbar_1/sim/uP_xbar_1.v" \

vcom -work axi_lite_ipif_v3_0_4 -93 \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/66ea/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \

vcom -work axi_intc_v4_1_14 -93 \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/f78a/hdl/axi_intc_v4_1_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/uP/ip/uP_microblaze_0_axi_intc_1/sim/uP_microblaze_0_axi_intc_1.vhd" \

vlog -work xlconcat_v2_1_3  -v2k5 "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/4fba" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/ec67/hdl" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/8713/hdl" \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/442e/hdl/xlconcat_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/4fba" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/ec67/hdl" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/8713/hdl" \
"../../../bd/uP/ip/uP_microblaze_0_xlconcat_1/sim/uP_microblaze_0_xlconcat_1.v" \

vcom -work mdm_v3_2_17 -93 \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/f9aa/hdl/mdm_v3_2_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/uP/ip/uP_mdm_1_1/sim/uP_mdm_1_1.vhd" \

vcom -work lib_cdc_v1_0_2 -93 \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_13 -93 \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/uP/ip/uP_rst_mig_7series_0_83M_1/sim/uP_rst_mig_7series_0_83M_1.vhd" \

vcom -work lib_pkg_v1_0_2 -93 \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/0513/hdl/lib_pkg_v1_0_rfs.vhd" \

vcom -work lib_srl_fifo_v1_0_2 -93 \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/51ce/hdl/lib_srl_fifo_v1_0_rfs.vhd" \

vcom -work axi_uartlite_v2_0_24 -93 \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/d8db/hdl/axi_uartlite_v2_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/uP/ip/uP_axi_uartlite_0_0/sim/uP_axi_uartlite_0_0.vhd" \

vcom -work lib_fifo_v1_0_14 -93 \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/a5cb/hdl/lib_fifo_v1_0_rfs.vhd" \

vcom -work axi_datamover_v5_1_22 -93 \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/1e40/hdl/axi_datamover_v5_1_vh_rfs.vhd" \

vcom -work axi_sg_v4_1_13 -93 \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/4919/hdl/axi_sg_v4_1_rfs.vhd" \

vcom -work axi_dma_v7_1_21 -93 \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/ec2a/hdl/axi_dma_v7_1_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/uP/ip/uP_axi_dma_0_0/sim/uP_axi_dma_0_0.vhd" \

vlog -work axis_infrastructure_v1_1_0  -v2k5 "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/4fba" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/ec67/hdl" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/8713/hdl" \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/8713/hdl/axis_infrastructure_v1_1_vl_rfs.v" \

vlog -work axis_data_fifo_v2_0_2  -v2k5 "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/4fba" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/ec67/hdl" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/8713/hdl" \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/3341/hdl/axis_data_fifo_v2_0_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/4fba" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/ec67/hdl" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/8713/hdl" \
"../../../bd/uP/ip/uP_axis_data_fifo_0_0/sim/uP_axis_data_fifo_0_0.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_addr_decode.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_read.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_reg.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_reg_bank.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_top.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_write.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_axi_mc.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_axi_mc_ar_channel.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_axi_mc_aw_channel.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_axi_mc_b_channel.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_axi_mc_cmd_arbiter.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_axi_mc_cmd_fsm.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_axi_mc_cmd_translator.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_axi_mc_fifo.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_axi_mc_incr_cmd.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_axi_mc_r_channel.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_axi_mc_simple_fifo.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_axi_mc_wrap_cmd.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_axi_mc_wr_cmd_fsm.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_axi_mc_w_channel.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_ddr_axic_register_slice.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_ddr_axi_register_slice.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_ddr_axi_upsizer.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_ddr_a_upsizer.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_and.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_latch_and.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_latch_or.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_or.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_ddr_command_fifo.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_ddr_comparator.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_ddr_comparator_sel.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_ddr_comparator_sel_static.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_ddr_r_upsizer.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/axi/mig_7series_v4_2_ddr_w_upsizer.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/clocking/mig_7series_v4_2_clk_ibuf.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/clocking/mig_7series_v4_2_infrastructure.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/clocking/mig_7series_v4_2_iodelay_ctrl.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/clocking/mig_7series_v4_2_tempmon.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/controller/mig_7series_v4_2_arb_mux.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/controller/mig_7series_v4_2_arb_row_col.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/controller/mig_7series_v4_2_arb_select.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/controller/mig_7series_v4_2_bank_cntrl.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/controller/mig_7series_v4_2_bank_common.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/controller/mig_7series_v4_2_bank_compare.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/controller/mig_7series_v4_2_bank_mach.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/controller/mig_7series_v4_2_bank_queue.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/controller/mig_7series_v4_2_bank_state.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/controller/mig_7series_v4_2_col_mach.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/controller/mig_7series_v4_2_mc.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/controller/mig_7series_v4_2_rank_cntrl.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/controller/mig_7series_v4_2_rank_common.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/controller/mig_7series_v4_2_rank_mach.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/controller/mig_7series_v4_2_round_robin_arb.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/ecc/mig_7series_v4_2_ecc_buf.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/ecc/mig_7series_v4_2_ecc_dec_fix.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/ecc/mig_7series_v4_2_ecc_gen.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/ecc/mig_7series_v4_2_ecc_merge_enc.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/ecc/mig_7series_v4_2_fi_xor.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/ip_top/mig_7series_v4_2_memc_ui_top_axi.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/ip_top/mig_7series_v4_2_mem_intfc.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_byte_group_io.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_byte_lane.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_calib_top.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_if_post_fifo.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_mc_phy.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_mc_phy_wrapper.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_of_pre_fifo.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_4lanes.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ck_addr_cmd_delay.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_dqs_found_cal.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_dqs_found_cal_hr.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_init.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_cntlr.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_data.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_edge.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_lim.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_mux.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_samp.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_oclkdelay_cal.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_prbs_rdlvl.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_rdlvl.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_tempmon.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_top.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_wrcal.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_wrlvl.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_wrlvl_off_delay.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_prbs_gen.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_ddr_skip_calib_tap.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_poc_cc.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_poc_edge_store.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_poc_meta.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_poc_pd.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_poc_tap_base.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/phy/mig_7series_v4_2_poc_top.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/ui/mig_7series_v4_2_ui_cmd.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/ui/mig_7series_v4_2_ui_rd_data.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/ui/mig_7series_v4_2_ui_top.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/ui/mig_7series_v4_2_ui_wr_data.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/uP_mig_7series_0_2_mig_sim.v" \
"../../../bd/uP/ip/uP_mig_7series_0_2/uP_mig_7series_0_2/user_design/rtl/uP_mig_7series_0_2.v" \
"../../../bd/uP/sim/uP.v" \

vlog -work axi_protocol_converter_v2_1_20  -v2k5 "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/4fba" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/ec67/hdl" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/8713/hdl" \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/c4a6/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/4fba" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/ec67/hdl" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/8713/hdl" \
"../../../bd/uP/ip/uP_auto_pc_3/sim/uP_auto_pc_3.v" \

vlog -work axi_clock_converter_v2_1_19  -v2k5 "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/4fba" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/ec67/hdl" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/8713/hdl" \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/9e81/hdl/axi_clock_converter_v2_1_vl_rfs.v" \

vlog -work axi_dwidth_converter_v2_1_20  -v2k5 "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/4fba" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/ec67/hdl" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/8713/hdl" \
"../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/d394/hdl/axi_dwidth_converter_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/4fba" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/ec67/hdl" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/uP/ipshared/8713/hdl" \
"../../../bd/uP/ip/uP_auto_us_0/sim/uP_auto_us_0.v" \
"../../../bd/uP/ip/uP_auto_us_1/sim/uP_auto_us_1.v" \
"../../../bd/uP/ip/uP_auto_us_2/sim/uP_auto_us_2.v" \
"../../../bd/uP/ip/uP_auto_us_3/sim/uP_auto_us_3.v" \
"../../../bd/uP/ip/uP_auto_ds_0/sim/uP_auto_ds_0.v" \
"../../../bd/uP/ip/uP_auto_pc_0/sim/uP_auto_pc_0.v" \
"../../../bd/uP/ip/uP_auto_ds_1/sim/uP_auto_ds_1.v" \
"../../../bd/uP/ip/uP_auto_pc_1/sim/uP_auto_pc_1.v" \
"../../../bd/uP/ip/uP_auto_ds_2/sim/uP_auto_ds_2.v" \
"../../../bd/uP/ip/uP_auto_pc_2/sim/uP_auto_pc_2.v" \

vlog -work xil_defaultlib \
"glbl.v"


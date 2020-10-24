vlib work
vlib riviera

vlib riviera/xpm
vlib riviera/xil_defaultlib

vmap xpm riviera/xpm
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xpm  -sv2k12 "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/ILA/ipshared/1b7e/hdl/verilog" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/ILA/ipshared/122e/hdl/verilog" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/ILA/ipshared/b205/hdl/verilog" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/ILA/ipshared/8f82/hdl/verilog" \
"C:/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"C:/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"C:/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/ILA/ipshared/1b7e/hdl/verilog" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/ILA/ipshared/122e/hdl/verilog" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/ILA/ipshared/b205/hdl/verilog" "+incdir+../../../../PROCOM_FP.srcs/sources_1/bd/ILA/ipshared/8f82/hdl/verilog" \
"../../../bd/ila/ip/ila_ila_0_0_1/sim/ila_ila_0_0.v" \
"../../../bd/ila/sim/ila.v" \

vlog -work xil_defaultlib \
"glbl.v"


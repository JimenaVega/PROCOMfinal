connect -url tcp:localhost:3121
targets -set -filter {jtag_cable_name =~ "Digilent Arty 210319A2D006A" && level==0} -index 0
fpga -file C:/Educacion/Procom2020/PROCOMfinal/Vitis_workspace/up_FIFO/_ide/bitstream/uP_wrapper.bit
configparams mdm-detect-bscan-mask 2
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2"  && jtag_cable_name =~ "Digilent Arty 210319A2D006A"} -index 0
rst -system
after 3000
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2"  && jtag_cable_name =~ "Digilent Arty 210319A2D006A"} -index 0
dow C:/Educacion/Procom2020/PROCOMfinal/Vitis_workspace/up_FIFO/Debug/up_FIFO.elf
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2"  && jtag_cable_name =~ "Digilent Arty 210319A2D006A"} -index 0
con

connect -url tcp:localhost:3121
targets -set -filter {jtag_cable_name =~ "Digilent Arty 210319A288D7A" && level==0} -index 0
fpga -file C:/Educacion/Procom2020/PROCOMfinal/3.uP/BlockDesign/FinalConvolve_NoFirstLoad.bit
configparams mdm-detect-bscan-mask 2
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2"  && jtag_cable_name =~ "Digilent Arty 210319A288D7A"} -index 0
rst -system
after 3000
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2"  && jtag_cable_name =~ "Digilent Arty 210319A288D7A"} -index 0
dow C:/Educacion/Procom2020/PROCOMfinal/Vitis_workspace/up_CONVOLVE/Debug/up_CONVOLVE.elf
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2"  && jtag_cable_name =~ "Digilent Arty 210319A288D7A"} -index 0
con

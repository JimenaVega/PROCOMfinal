onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib MicroGPIO_opt

do {wave.do}

view wave
view structure
view signals

do {MicroGPIO.udo}

run -all

quit -force

onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -L xpm -L fifo_generator_v13_1_1 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.fifo_32x8bit_0 xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {fifo_32x8bit_0.udo}

run -all

quit -force
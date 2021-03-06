onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib fifo_32x8bit_0_opt

do {wave.do}

view wave
view structure
view signals

do {fifo_32x8bit_0.udo}

run -all

quit -force

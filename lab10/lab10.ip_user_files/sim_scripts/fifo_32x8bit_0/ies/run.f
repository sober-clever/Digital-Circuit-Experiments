-makelib ies_lib/xpm -sv \
  "D:/Vivado/Vivado/2020.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "D:/Vivado/Vivado/2020.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/Vivado/Vivado/2020.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/fifo_generator_v13_1_1 \
  "../../../ipstatic/fifo_generator_v13_1_1/simulation/fifo_generator_vlog_beh.v" \
-endlib
-makelib ies_lib/fifo_generator_v13_1_1 \
  "../../../ipstatic/fifo_generator_v13_1_1/hdl/fifo_generator_v13_1_rfs.vhd" \
-endlib
-makelib ies_lib/fifo_generator_v13_1_1 \
  "../../../ipstatic/fifo_generator_v13_1_1/hdl/fifo_generator_v13_1_rfs.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../lab10.srcs/sources_1/ip/fifo_32x8bit_0/sim/fifo_32x8bit_0.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib


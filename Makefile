SIM           = icarus
TOPLEVEL_LANG = verilog

VERILOG_SOURCES  = /mnt/c/Users/shaik/uart\ protocol/rtl/baud_rate_gen.v
VERILOG_SOURCES += /mnt/c/Users/shaik/uart\ protocol/rtl/transmitter.v
VERILOG_SOURCES += /mnt/c/Users/shaik/uart\ protocol/rtl/receiver.v
VERILOG_SOURCES += /mnt/c/Users/shaik/uart\ protocol/rtl/sync_fifo.v
VERILOG_SOURCES += /mnt/c/Users/shaik/uart\ protocol/rtl/uart_top.v

TOPLEVEL = uart_top
MODULE   = tests.test_uart

WAVES = 1

include $(shell cocotb-config --makefiles)/Makefile.sim

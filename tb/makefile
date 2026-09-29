SIM ?= verilator
TOPLEVEL_LANG ?= verilog
WAVES ?= 1

ifeq ($(SIM),verilator)
    # Flag passati al compilatore Verilator
    COMPILE_ARGS += --trace --trace-structs --public-flat-rw -Wno-fatal
endif

ifeq ($(SIM),icarus)
    COMPILE_ARGS += -g2012
endif

# 1. Package compilato per primo
VERILOG_SOURCES = $(PWD)/../rtl/package/isa_pkg.sv

# 2. File RTL
VERILOG_SOURCES += $(wildcard $(PWD)/../rtl/core/*.sv)
VERILOG_SOURCES += $(wildcard $(PWD)/../rtl/top_level/*.sv)

# Nome esatto del modulo top-level SystemVerilog
TOPLEVEL = rv32I_top

# Modulo Python di test (aggiornato per le versioni recenti di Cocotb)
COCOTB_TEST_MODULES = test_top

include $(shell cocotb-config --makefiles)/Makefile.sim
TOPLEVEL_LANG = verilog

SIM ?= verilator 
#SIM ?= icarus
WAVES ?= 1

COCOTB_HDL_TIMEUNIT = 1ns
COCOTB_HDL_TIMEPRECISION = 1ps
export COCOTB_RESOLVE_X ?= RANDOM

DUT      	= passthrough 
TYPE	 	= typedef
AXI_PKG	 	= axi_pkg 
INTERFACE	= interafce 
REGISTER	= spill_register 

TOPLEVEL = $(DUT)
MODULE   = test_$(DUT)

VERILOG_SOURCES += ./$(DUT).sv
VERILOG_SOURCES += ./$(INTERFACE).sv
VERILOG_SOURCES += ./$(TYPE).sv
VERILOG_SOURCES += ./$(AXI_PK).sv
VERILOG_SOURCES += ./$(REGISTER).sv
VERILOG_SOURCES += ./$(REGISTER)_flushable.sv

# module parameters
export AXI_ADDR_WIDTH := 32
export AXI_DATA_WIDTH := 16
export NumSlvPorts := 32'd2
#export PARAM_STRB_WIDddTH := $(shell expr $(PARAM_DATA_WIDTH) / 8 )
ifeq ($(SIM), icarus)
	PLUSARGS += -fst

	COMPILE_ARGS += $(foreach v,$(filter PARAM_%,$(.VARIABLES)),-P $(TOPLEVEL).$(subst PARAM_,,$(v))=$($(v)))

	ifeq ($(WAVES), 1)
		VERILOG_SOURCES += iverilog_dump.v
		COMPILE_ARGS += -s iverilog_dump
	endif
else ifeq ($(SIM), verilator)
	COMPILE_ARGS += -Wno-SELRANGE -Wno-WIDTH

	COMPILE_ARGS += $(foreach v,$(filter PARAM_%,$(.VARIABLES)),-G$(subst PARAM_,,$(v))=$($(v)))

	ifeq ($(WAVES), 1)
		COMPILE_ARGS += --trace-fst
	endif
endif

include $(shell cocotb-config --makefiles)/Makefile.sim

iverilog_dump.v:
	echo 'module iverilog_dump();' > $@
	echo 'initial begin' >> $@
	echo '    $$dumpfile("$(TOPLEVEL).fst");' >> $@
	echo '    $$dumpvars(0, $(TOPLEVEL));' >> $@
	echo 'end' >> $@
	echo 'endmodule' >> $@

clean::
	@rm -rf iverilog_dump.v
	@rm -rf dump.fst $(TOPLEVEL).fst

sim:
	SIM=verilator INCLUDE_PATH=/Users/xjy/XJY/cocotb/xjy_test/tri/ pytest -o log_cli=True test_passthrough.py

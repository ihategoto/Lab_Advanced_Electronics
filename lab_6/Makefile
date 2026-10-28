####################################################
####	Laboratory of Advanced Electronics	####
####	UniTN, Dept. of Physics			####
####	A.Y. 2022-23				####
####	- This is a Makefile for Verilog	####
####	compilation via Vivado tcl scripting -	####
####	Modify this file AT YOUR OWN RISK.	####
####################################################

#### SHORTHANDS
xc00=$(shell echo "\e[38;5;187m")
xcbl=$(shell echo "\e[38;5;39m")
xcyl=$(shell echo "\e[38;5;220m")
xcrd=$(shell echo "\e[38;5;196m")
xcgr=$(shell echo "\e[38;5;35m")
xfbl=$(shell echo "\e[1m")
xfun=$(shell echo "\e[4m")
xfrs=$(shell echo "\e[0m")

#### LOADING SETTINGS
ifeq ($(filter $(MAKECMDGOALS),clean help),)
ifneq ("$(CFG)","")
ifeq ("$(wildcard $(CFG))","")
$(error $(xcrd)$(xfbl)ERROR:$(xfrs) Configuration file "$(CFG)" provided via CFG not found)
else
include $(CFG)
endif
else
CFG:=compiler.config
ifeq ("$(wildcard $(CFG))","")
$(error $(xcrd)$(xfbl)ERROR:$(xfrs) No configuration filename provided via CFG; default configuration "compiler.config" not found)
else
include $(CFG)
endif
endif
endif

#### CHECK COMPILER CONFIGURATION
ifeq ($(filter $(MAKECMDGOALS),clean help prog programDevice),)
ifndef VERILOG_SOURCES
$(error $(xcrd)$(xfbl)ERROR:$(xfrs) No source file listed in the configuration file)
endif
ifndef CONSTRAINTS_SOURCES
$(error $(xcrd)$(xfbl)ERROR:$(xfrs) No constraints file listed in configuration file)
endif
ifndef TOP_LEVEL_MODULE
$(error $(xcrd)$(xfbl)ERROR:$(xfrs) No top-level module specified)
endif
ifndef TARGET_CHIP
$(error $(xcrd)$(xfbl)ERROR:$(xfrs) No target chip code specified)
endif
endif

#### HANDLE VIVADO PATH
ifeq ($(filter $(MAKECMDGOALS),clean help),)
ifeq ("$(VIVADO_EXEC)","")
ifeq ("$(shell which vivado)","")
$(error $(xcrd)$(xfbl)ERROR:$(xfrs) Vivado cannot be found; an explicit path was not provided via configuration file)
else
VIVADO_EXEC:=$(shell readlink `which vivado`)
endif
else
ifeq ("$(wildcard $(VIVADO_EXEC))","")
ifeq ("$(shell which vivado)","")
$(error $(xcrd)$(xfbl)ERROR:$(xfrs) Vivado cannot be found neither at the default path, not at the path provided via configuration file, "$(VIVADO_EXEC)")
else
VIVADO_EXEC:=$(shell readlink `which vivado`)
$(warning $(xcyl)$(xfbl)WARNING:$(xfrs) vivado was not found at the path provided via configuration file, but the vivado executable was found at $(VIVADO_EXEC). Continuing)
endif
endif
endif
endif

#### GENERATE FILE NAMES
PROJECT_NAME ?= $(shell echo `basename $(PWD)` | sed -r 's/\<./\L&/g')
BITFILE := $(PROJECT_NAME).bit
TCLSCRIPT := pipeline.tcl

############################
#### RECIPES DEFINITION ####
############################

.PHONY: default
default: $(BITFILE)

$(BITFILE): $(VERILOG_SOURCES) $(CONSTRAINTS_SOURCES) $(SYNTHESIZED_SOURCES)
	@echo "$(xfbl)$(xc00)\n\
	##################################################\n\
	####    LABORATORY OF ADVANCED ELECTRONICS    ####\n\
	####    UniTN, Dept. of Physics - 2022/23     ####\n\
	####    This is a GNUmake + TCL pipeline to   ####\n\
	####    compile Verilog sources into .bit     ####\n\
	##################################################\n$(xfrs)"
	@echo "$(xc00)> Compilation pipeline parameters:$(xfrs)\n\
	$(xc00)\tTarget file: $(xfun)$(BITFILE)$(xfrs)\n\
	$(xc00)\tTarget device: $(xfun)$(TARGET_CHIP)$(xfrs)\n\
	$(xc00)\tTop-level module: $(xfun)$(TOP_LEVEL_MODULE)$(xfrs)"
	@rm -rf build/
	@mkdir -p build/
	@echo -n "$(xc00)> Copying files to build directory...$(xfrs)"
	@cp $(VERILOG_SOURCES) build/
	@cp $(CONSTRAINTS_SOURCES) build/
	@if [ -n "$(SYNTHESIZED_SOURCES)" ]; then cp $(SYNTHESIZED_SOURCES) build/ ; fi
	@echo "$(xcgr) done.$(xfrs)"
	@echo -n "$(xc00)> Preparing compilation pipeline script...$(xfrs)"
	@$(foreach file,$(VERILOG_SOURCES),echo "read_verilog $(file)" >> build/$(TCLSCRIPT);)
	@$(foreach file,$(CONSTRAINTS_SOURCES),echo "read_xdc $(file)" >> build/$(TCLSCRIPT);)
	@if [ -n "$(SYNTHESIZED_SOURCES)" ]; then \
		echo -n ; \
		$(foreach file,$(SYNTHESIZED_SOURCES),echo "read_edif $(file)" >> build/$(TCLSCRIPT);) \
		fi
	@echo "synth_design -top "$(TOP_LEVEL_MODULE)" -part "$(TARGET_CHIP) >> build/$(TCLSCRIPT)
	@echo "opt_design" >> build/$(TCLSCRIPT)
	@echo "place_design" >> build/$(TCLSCRIPT)
	@echo "route_design" >> build/$(TCLSCRIPT)
	@echo "write_bitstream -force "$(BITFILE) >> build/$(TCLSCRIPT)
	@echo "$(xcgr) done.$(xfrs)"
	@echo "$(xc00)> Lauching compilation pipeline - $(xfbl)this will take a while.$(xfrs)"
	@echo "$(xc00)> Vivado log messages are echoed below.$(xfrs)\n"
	@cd build/; $(VIVADO_EXEC) -mode batch -source $(TCLSCRIPT) 2>&1 | \
		stdbuf -o0  sed ''s/INFO/`printf "\e[38;5;39m\e[1mINFO\e[0m"`/g'' | \
		stdbuf -o0  sed ''s/WARNING/`printf "\e[38;5;220m\e[1mWARNING\e[0m"`/g'' | \
		stdbuf -o0  sed ''s/ERROR/`printf "\e[38;5;196m\e[1mERROR\e[0m"`/g'' | \
		grep -e "INFO" -e "ERROR" -e "WARNING"
	@cd build/; \
		if [ -f '$(BITFILE)' ]; then \
		mv $(BITFILE) ..; \
		echo "\n$(xc00)> Compilation $(xfbl)$(xcgr)ended successfully!$(xfrs)$(xc00)\n> Cleaning build directory.\n> Bitfile produced: $(xfrs)$(xfbl)$(xcgr)'$(BITFILE)'.$(xfrs)\n"; \
		else \
		cp vivado.log ../_vivado_error.log ; \
		echo "\n$(xc00)> Compilation $(xfbl)$(xcrd)error(s)$(xfrs)$(xc00).\n> Check '_vivado_error.log' for details.$(xfrs)\n"; exit; \
		fi
	@rm -rf build/

.PHONY: prog
prog: programDevice

.PHONY: programDevice
programDevice:
	@if [ ! -f '$(BITFILE)' ]; then \
		echo "\n$(xc00)> Bitfile '$(BITFILE)'$(xfbl)$(xcrd) not found$(xfrs)$(xc00).\n> To compile and produce a bitfile, use 'make' or 'make $(BITFILE)'.$(xfrs)\n"; exit 1; \
	fi
	@echo "$(xfbl)$(xc00)\n\
	##################################################\n\
	####    LABORATORY OF ADVANCED ELECTRONICS    ####\n\
	####    UniTN, Dept. of Physics - 2022/23     ####\n\
	####    This is a GNUmake + TCL pipeline to   ####\n\
	####    compile Verilog sources into .bit     ####\n\
	##################################################\n$(xfrs)"
	@echo "$(xc00)> Programming device.$(xfrs)\n$(xc00)\tBinary file: $(xfun)"$(BITFILE)"$(xfrs)\n";
	@echo -n "$(xc00)> Making a copy of the binary file...$(xfrs)"
	@rm -rf progdev/
	@mkdir -p progdev/
	@cp $(BITFILE) progdev/
	@echo "$(xcgr) done.$(xfrs)"
	@echo -n "$(xc00)> Preparing device programming script...$(xfrs)"
	@echo "open_hw_manager" >> progdev/$(TCLSCRIPT)
	@echo "connect_hw_server -url localhost:3121" >> progdev/$(TCLSCRIPT)
	@echo "current_hw_target [get_hw_targets */xilinx_tcf/Digilent/*]" >> progdev/$(TCLSCRIPT)
	@echo "open_hw_target" >> progdev/$(TCLSCRIPT)
	@echo "current_hw_device [lindex [get_hw_devices] 1]" >> progdev/$(TCLSCRIPT)
	@echo "refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 1]" >> progdev/$(TCLSCRIPT)
	@echo "set_property PROGRAM.FILE \"$(BITFILE)\" [lindex [get_hw_devices] 1]" >> progdev/$(TCLSCRIPT)
	@echo "program_hw_devices [lindex [get_hw_devices] 1]" >> progdev/$(TCLSCRIPT)
	@echo "$(xcgr) done.$(xfrs)"
	@echo "$(xc00)> Lauching programming sequence - $(xfbl)this will take a while.$(xfrs)"
	@echo "$(xc00)> Vivado log messages are echoed below.$(xfrs)\n"
	@cd progdev/; $(VIVADO_EXEC) -mode batch -source $(TCLSCRIPT) 2>&1 | \
		stdbuf -o0  sed ''s/INFO/`printf "\e[38;5;39m\e[1mINFO\e[0m"`/g'' | \
		stdbuf -o0  sed ''s/WARNING/`printf "\e[38;5;220m\e[1mWARNING\e[0m"`/g'' | \
		stdbuf -o0  sed ''s/ERROR/`printf "\e[38;5;196m\e[1mERROR\e[0m"`/g'' | \
		grep -e "INFO" -e "ERROR" -e "WARNING"

.PHONY: help
help:
	@echo "$(xfbl)$(xc00)\n\
	##################################################\n\
	####    LABORATORY OF ADVANCED ELECTRONICS    ####\n\
	####    UniTN, Dept. of Physics - 2022/23     ####\n\
	####    This is a GNUmake + TCL pipeline to   ####\n\
	####    compile Verilog sources into .bit     ####\n\
	##################################################\n$(xfrs)"
	@echo "$(xc00)> List of available recipes:$(xfrs)\n\n\
	$(xc00)\t> make \t\t\t\t:: compile sources into binary;$(xfrs)\n\
	$(xc00)\t> make programDevice\t\t:: load bitfile onto a connected device (also as 'make prog');$(xfrs)\n\
	$(xc00)\t> make clean\t\t\t:: remove temporary files and binary files.$(xfrs)\n\
	$(xc00)\t> make help\t\t\t:: show this help.$(xfrs)\n"

.PHONY: clean
clean:
	@echo "$(xc00)\n> Cleaning build directory, bit file and log files.$(xfrs)\n";
	@rm -rf build/
	@rm -rf progdev/
	@rm -rf .Xil/
	@rm -f _vivado_error.log
	@rm -f *.bit

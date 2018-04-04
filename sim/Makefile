# Makefile for simulating various addressing modes of the 6502 processor

SHELL = /bin/bash

ROMS_DIR = ../roms
BUILD_DIR = ../build
SIM_DIR = .
LIB_DIR = $(SIM_DIR)/proc_lib
LOG_DIR = $(SIM_DIR)/logs

MEMORY_IP = memory_block
MEMORY_DIR = $(BUILD_DIR)/$(MEMORY_IP)
MEMORY_MODEL = $(MEMORY_DIR)/blk_mem_gen_v8_3.v

# Default goal
.PHONY: help
help:
	@printf "\n"
	@printf "Available goals:\n"
	@printf "\n"
	@printf " help  - Display this summary\n"
	@printf " clean - Delete all generated files not in source tree\n"
	@printf " sim   - Run a processor simulation with TESTBENCH=[testname]\n"
	@printf "\n"

# Report status prior to major targets
.PHONY: status_msg
status_msg:
	@printf "\n"

# Remove all non-source tree files created during simulations
.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(LIB_DIR)
	rm -rf $(LOG_DIR)
	rm -f $(ROMS_DIR)/*.coe
	rm -f $(ROMS_DIR)/*.mif
	rm -f $(SIM_DIR)/*.coe
	rm -f $(SIM_DIR)/*.mif

# Assemble a

# Build the model, given a new
$(MEMORY_MODEL): $(ROMS_DIR)/$(TESTBENCH).mif
	@printf "No ROM found, building new block RAM.\n"

# Run one of many possible processor simulations
sim: status_msg $(MEMORY_MODEL)
	@printf "Check to make sure that TESTBENCH was provided and is valid.\n"

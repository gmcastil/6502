QUESTA_PATH = /opt/Altera/intelFPGA_pro/17.0/modelsim_ase/linux

VSIM = ${QUESTA_PATH}/vsim
VLOG = ${QUESTA_PATH}/vlog
VLIB = ${QUESTA_PATH}/vlib

SRC_DIR = ../src
INCLUDES_DIR = ${SRC_DIR}/includes
LOG_DIR = ./logs
TESTBENCH_DIR = ../testbench
DOFILES_DIR = ./dofiles

# This is broken
LIB_NAME = ram_lib

.PHONY: test
test:

	${VLIB} ./${LIB_NAME}

	${VLOG} \
		-work ${LIB_NAME} \
		-novopt \
		-y ${SRC_DIR} \
		-l ${LOG_DIR}/alu.log \
		+libext+.v \
		+libext+.vh \
		+libext+.sv \
		+incdir+${INCLUDES_DIR} \
		${TESTBENCH_DIR}/proc_tb.sv

	${VSIM} \
		-t 1ps \
		-novopt \
		-c \
		-do ${DOFILES_DIR}/proc_sim.do \
		-do "quit -f;" \
		${LIB_NAME}.proc_tb

.PHONY: ram
ram:

	${VLIB} ./${LIB_NAME}

	${VLOG} \
		-work ${LIB_NAME} \
		-novopt \
		-y ${SRC_DIR} \
		-y ${TESTBENCH_DIR} \
		-l ${LOG_DIR}/ram.log \
		+libext+.v \
		+libext+.vh \
		+libext+.sv \
		${TESTBENCH_DIR}/ram_tb.sv

	${VSIM} \
		-t 1ps \
		-novopt \
		-c \
		-do ${DOFILES_DIR}/ram_sim.do \
		-do "quit -f;" \
		${LIB_NAME}.ram_tb


.PHONY: clean
clean:

	rm -rf ${LOG_DIR}
	rm -rf ${LIB_NAME}
	rm vsim.wlf

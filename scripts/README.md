# Scripts
A set of scripts to aid in development.  Most of these were developed to
automate common tasks that needed to be performed on a regular basis, usually
involving simulation.

The typical use case is to run one of the shell scripts, which sets up some
environmental variables, creates temporary directories, and then calls Vivado
in batch mode with various parameters and fires off a Tcl script.

## Generating an Initial Memory Array
Development of the MOS 6502 processor commonly needs a memory artifact of some
sort to interact with.  Currently, the processor is in an early stage of
development and the current goal is to get it to awaken from reset, load the
reset vector, and begin executing commands from that location.  To support this,
a 64KB block memory is created using the Xilinx Block Memory Generator and
populated with an initial configuration of machine instructions and data.  This
is a tedious task which needs to be performed many times as the program and
testbench evolve.  To make this easier, a series of scripts were developed to
automate this.

First, to create the initial memory map, run the `coe_gen.py` program:
```bash
$ ./coe_gen.py
```
This will create a `basic.coe` file, such as the one in the `/roms/`
directory, but entirely filled with NOP (0xEA) instructions. Using a text
editor, carefully insert opcodes and data as desired into the `.coe` file at
each address. Then, from the `/scripts/` directory, run the `memory_gen.sh`
script.
```bash
$ ./memory_gen.sh my-basic.coe
```
This will call Vivado and generate a 64KB memory IP block using whatever
customized `.coe` file you've supplied.

## Simulating the Operation of the Memory Array
After the initial memory array has been generated as described in the previous
paragraph, run the `memory_sim.sh` script to run a simulation in Vivado.
```bash
$ ./memory_sim.sh my-basic.coe
```
This won't launch Vivado right away - to actually view the waveform, you'll
need to open a static simulation, which can be done from the Vivado start
screen. or via a series of Tcl commands from the console in Vivado. With the
waveform open, you can check the memory contents to make sure that the initial
program for the processor is complete and accurate (Tip: Remember that the MOS
6502 is little endian, so be sure to verify byte ordering). If all goes well,
you should see every address of the memory array read out, matching what you put
in at each address.

## Processor Simulation
TBD

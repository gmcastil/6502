# MOS Technology 6502

This project is a hardware emulation of the MOS Technology 6502 microprocessor
in Verilog. The MOS 6502 was originally released in 1975 and was, at the time,
the most advanced microprocessor on the market. It was used in a number of PC
and video game applications, notably the original Apple II, the Commodore 64,
and the original 8-bit Nintendo Entertainment System (NES).

There are many 6502 software and hardware emulators available on the internet.
This particular implementation is primarily oriented towards emulation of the
6502 variant that was used in the original 8-bit NES. It is also under active
development, so expect a lot of changes to occur along the way.

# Status

So far, only a couple dozen instructions have been implemented, but the rest of
the addressing modes should be rather easy to implement.

# Usage

This design is released under an MIT license, which is a fairly permissive
license. A special note to engineering students who wish to use this in a senior
design project: while I obviously have no problems with your use of my hardware,
I want to underline the educational value of implementing your own processor. I
had no idea how processors worked until I decided to go off and make my own.

Anyway, here are a couple caveats to anyone looking to use this:

* This is an emulator for the original MOS 6502. There are several variants of
  the original version which added some instructions and fixed some original
  bugs. Since the goal of this design is to eventually serve in an NES emulator,
  it is fundamentally incompatible with later versions of the 6502 (notably, the
  65C02 which fixed a few bugs that NES software developers depended upon).

* No attempt has been made to create a vendor-neutral design. I am specifically
  targeting a Xilinx 7-series for the design, although I am not currently using
  any Xilinx primitives in the processor (and likely will not). However, the
  reset module explicitly uses Xilinx primitives and the simulation scripts all
  assume their use as well.

* Pretty much all of the simulation and synthesis scripts assume the following:
  * A Linux variant of some sort - you could easily take the RTL and make your
    own Windows version, but I've not gone to the trouble of trying to make that
    happen.
  * Environment assumes GNU bash - I'm not really sure what version is
    necessary, but if you're running a recent Linux distro, you should be fine.
    You will need to make sure some environment variables are set, although I've
    tried to make it work as much out of the box as I can.
  * For simulation, I've written my simulation scripts to target the student
    version of the QuestaSim simulator from Altera.
  * Synthesis will eventually be directed towards the Xilinx Vivado design
    Suite - I have no intention to support 3rd party synthesis tools.

That's all I can think of right now. I'm sure that things will change over
time.

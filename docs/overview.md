# Goal
Develop a cycle-accurate, synthesizable RTL model of a 65C02 microprocessor that
supports modern as well as legacy (e.g., 8-bit NES) operation

# Development
The major development efforts that will be performed are
- Developing a 6502-based single board computer with data capture and logging
  capabilities, for the primary purpose of supporting hardware testing of the
  emulator.
- Generating test ROMs to run on the SBC and capturing the hardware state as VCD
  dump files that can be viewed in ModelSim or Vivado, or be used for hardware
  verification.
- Developing the hardware and software infrastructure to support running test
  ROMs in simulation and in hardware with the actual 6502 microprocessor or with
  the RTL emulator.

# Requirements
## Single Board Computer
### Power Supply
The single board computer shall be capable of being powered from a single 5V DC
input, either from a bench DC power supply or a USB 2.0 adaptor.
### Clock and Reset
The PHI2 system clock shall be driven by an external crystal oscillator or
programmable clock generator.

The PHI2 system clock frequency shall be between 1-2MHz

Upon power up, the RESB input to the microprocessor shall be held low at least
two clock cycles after VDD reaches the nominal operating voltage.  Deassertion
of RESB shall be synchronized to the rising edge of the PHI2 system clock.  In
addition to the power on reset, a debounced, push-button reset shall also be
available which provides a similar reset to the entire system.

TBD: Need a timing diagram of the reset functionality here

### Nonvolatile Storage and Memory
The single board computer shall contain a minimum of 32kB non-volatile EEPROM
storage for boot ROM and primary program storage.

The single board computer shall provide 16kB of static RAM.

### Status and IO
The following IO signals shall be supported
- Serial communication via UART (with a hardware UART-to-USB bridge)
- Four slider or DIP switches
- Two push button switches in addition to the board reset switch
- One board reset switch, which resets the entire board
- One toggle power switch, which interrupts the 5V main input power (and also
  triggers the POR)
- Two-digit, seven-segment display (SSEG) module
- 16x2 LCD panel display module

The following signals shall be instrumented and visually apparent to the user
- Main power on LED
- Main power undervolt LED
- Main power good status LED
- Wait status LED, which is asserted when the RDY input is pulled low by the
  processor indicating a ‘wait for interrupt’ condition
- Clock present LED
- Reset status LED
- UART TX and RX status LED

### Data Logging
The following signal lines shall be logged and captured on each edge of the
phase 2 (PHI2) clock
- Processor data lines (8) D0-D7
- Processor address lines (16) A0-A15
- Processor control signals (10): bus enable (BE), interrupt request (IRQB),
  memory lock (MLB), non-maskable interrupt (NMIB), read/write (RWB), ready
  (RDY), reset (RSTB), set overflow (SOB), synchronize with opcode fetch (SYNC),
  vector pull (VPB)
- RDY status (i.e., whether RDY is being pulled low by the processor, indicating
  a WAI for interrupt instruction was received)
Including the system clock, this yields a minimum of 36 signals which need to be
captured by an external logic analyzer or some other mechanism.

## FPGA RTL Emulator

# Implementation
## SBC Block Design
## Address Decode Logic
## Memory Map
## Components
## Logging Interface
## Mechanical


# Notes
Are there discrete ICs to do reset generation for me or is my own power on reset
generator the way to go?
How to connect the logic analyzer to the board - not even sure what I have at
this point.
Some sort of SPI device would be nice to add at some point




// ----------------------------------------------------------------------------
// Module:  opcodes.vh
// Project:
// Author:  George Castillo <gmcastil@gmail.com>
// Date:    17 July 2017
//
// Description: Opcode definitions used by the processor.  This file is best
// viewed in an editor with good syntax highlighting since it also contains
// tabulated properties of each opcode based upon chapter 18 from [1] in the
// comments.
//
// References
//
// [1] D. Eyes and R. Lichty, Programming the 65816: Including the 6502, 65C02
//     and 65802. New York, NY: Prentice Hall, 1986.
//
// [2] http://www.oxyron.de/html/opcodes02.html
// ----------------------------------------------------------------------------

// A convention for identifying addressing modes (from [2]):
//
// imm   Immediate                           #$00
// abs   Absolute                            $0000
// zp    Zero page                           $00
// abx   Absolute indexed with X             $0000, X
// aby   Absolute indexed with Y             $0000, Y
// zpx   Zero page indexed with X            $00, X
// zpy   Zero page indexed with Y            $00, Y
// izx   Zero page indexed indirect with X   ($00, X)
// izy   Zero page indirect indexed with Y   ($00), Y
// ind   Absolute indirect                   ($0000)
// rel   Program counter relative            $0000


// Note that there is some asymmetry here between indexed indirect mode
// (used only with the X register) and indirect indexed mode (used only with
// the Y register).  These modes are distinct with respect to each other and
// should not be confused.

// Some notes on cycle counting:
//
// 1 - Add 1 cycle if adding index crosses a page boundary

// Also note that each instruction will affect the status of processor flags

`ifndef OPCODES

`define OPCODES

localparam
  //
  // Add With Carry
  //
  // Flags Affected: n v - - - z c
  //
  //        Opcode      Bytes   Cycles   Notes
  ADC_imm = 8'h69,  //  2       2
  ADC_abs = 8'h62,  //  3       4
  ADC_zp  = 8'h65,  //  2       3
  ADC_abx = 8'h7D,  //  3       4        1
  ADC_aby = 8'h79,  //  3       4        1
  ADC_zpx = 8'h75,  //  2       4
  ADC_izx = 8'h61,  //  2       6
  ADC_izy = 8'h71;  //  2       5

localparam
  //
  // OR Accumulator with Memory
  //
  // Flags Affected: n - - - - z -
  //
  //        Opcode      Bytes   Cycles   Notes
  ORA_abs = 8'h0D,  //  3       4

localparam

  NOP = 8'hEA,
  JMP = 8'h4C,
  LDA = 8'hA9;



`endif //  `ifndef OPCODES

// -*- var-name:

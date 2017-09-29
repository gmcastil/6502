// ----------------------------------------------------------------------------
// Module:  opcodes.vh
// Project: MOS 6502 Processor
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
  // Flags Affected: n v - - - - z c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  ADC_imm = 8'h69,  //  2       2
  ADC_abs = 8'h6D,  //  3       4                Y
  ADC_zp  = 8'h65,  //  2       3
  ADC_abx = 8'h7D,  //  3       4        1
  ADC_aby = 8'h79,  //  3       4        1
  ADC_zpx = 8'h75,  //  2       4
  ADC_izx = 8'h61,  //  2       6
  ADC_izy = 8'h71;  //  2       5

localparam
  //
  // AND Accumulator with Memory
  //
  // Flags Affected: n - - - - - z -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  AND_abs = 8'h2D;  //  3       4                Y

localparam
  //
  // Shift Memory or Accumulator Left
  //
  // Flags Affected: n - - - - - z c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  ASL_abs = 8'h0E;  //  3       6                Y

localparam
  //
  // Test Memory Bits Against Accumulator
  //
  // Flags Affected: n v - - - - z - (other than immediate)
  //                 - - - - - - z - (immediate only)
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  BIT_abs = 8'h2C;  //  3       4
localparam
  //
  // Compare Accumulator with Memory
  //
  // Flags Affected: n - - - - - z c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  CMP_abs = 8'hCD;  //  3       4

localparam
  //
  // Decrement
  //
  // Flags Affected: n - - - - - z -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  DEC_abs = 8'hCE;  //  3       6

localparam
  //
  // Exclusive-Or Accumulator with Memory
  //
  // Flags Affected: n - - - - - z -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  EOR_abs = 8'h4D;  //  3       4

localparam
  //
  // OR Accumulator with Memory
  //
  // Flags Affected: n - - - - - z -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  ORA_abs = 8'h0D;  //  3       4

localparam

  NOP_imp = 8'hEA,
  JMP_abs = 8'h4C,
  LDA_abs = 8'hAD;

localparam

  LDA_imm = 8'hA9;

localparam
  //
  // Clear Carry Flag
  //
  // Flags Affected: - - - - - - - c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  CLC_imp = 8'h18;  //  1       2                Y

localparam
  //
  // Clear Overflow Flag
  //
  // Flags Affected: - v - - - - - -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  CLV_imp = 8'hB8;  //  1       2                Y

`endif //  `ifndef OPCODES

// -*- var-name:

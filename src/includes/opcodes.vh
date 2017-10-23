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

// Notes to myself
//
// Absolute addressing mode status:

// ADC - Done
// AND - Done
// ASL - Done
// BIT - Done
// CMP - Done, but I'm not sure that the ALU implements SUB correctly to perform
//       this operation properly, or that the flag assignment in the processor
//       logic is correct.  Might need to fix this later.
// CPX - Done, but I'm not sure that the ALU implements SUB correctly to perform
//       this operation properly, or that the flag assignment in the processor
//       logic is correct.  Might need to fix this later.
// CPY - Done, but I'm not sure that the ALU implements SUB correctly to perform
//       this operation properly, or that the flag assignment in the processor
//       logic is correct.  Might need to fix this later.
// DEC - Done, assuming my write logic is correct
// DEX - Done, assuming my write logic is correct
// DEY - Done, assuming my write logic is correct
// EOR - Done
// INC - Done, assuming my write logic is correct
// INX - Done, assuming my write logic is correct
// INY - Done, assuming my write logic is correct
// JMP - Done
// JSR
// LDA - Done
// LDX - Done
// LDY - Done
// LSR - Done
// ORA - Done
// ROL - Done
// ROR - Done
// SBC - Done
// STA - Done
// STX - Done
// STY - Done

localparam
  //
  // Add With Carry
  //
  // Flags Affected: n v - - - - z c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  ADC_abs = 8'h6D;  //  3       4

localparam
  //
  // AND Accumulator with Memory
  //
  // Flags Affected: n - - - - - z -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  AND_abs = 8'h2D;  //  3       4

localparam
  //
  // Shift Memory or Accumulator Left
  //
  // Flags Affected: n - - - - - z c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  ASL_abs = 8'h0E;  //  3       6

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
  // Compare X Index Register with Memory
  //
  // Flags Affected: n - - - - - z c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  CPX_abs = 8'hEC;  //  3       4

localparam
  //
  // Compare Y Index Register with Memory
  //
  // Flags Affected: n - - - - - z c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  CPY_abs = 8'hCC;  //  3       4

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
  // Decrement Index X
  //
  // Flags Affected: n - - - - - z -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  DEX_imp = 8'hCA;  //  3       6

localparam
  //
  // Decrement Index Y
  //
  // Flags Affected: n - - - - - z -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  DEY_imp = 8'h88;  //  3       6

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
  // Increment
  //
  // Flags Affected: n - - - - - z -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  INC_abs = 8'hEE;  //  3       6

localparam
  //
  // Increment Index X
  //
  // Flags Affected: n - - - - - z -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  INX_imp = 8'hE8;  //  3       6

localparam
  //
  // Increment Index Y
  //
  // Flags Affected: n - - - - - z -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  INY_imp = 8'hC8;  //  3       6

localparam
  //
  // Jump
  //
  // Flags Affected: - - - - - - - -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  JMP_abs = 8'h4C;  //  3       3

localparam
  //
  // Jump to Subroutine
  //
  // Flags Affected: - - - - - - - -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  JSR_abs = 8'h20;  //  3       6

localparam
  //
  // Load Accumulator from Memory
  //
  // Flags Affected: n - - - - - z -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  LDA_imm = 8'hA9,  //  2       2
  LDA_abs = 8'hAD;  //  3       4

localparam
  //
  // Load Index Register X from Memory
  //
  // Flags Affected: n - - - - - z -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  LDX_imm = 8'hA2,  //  2       2
  LDX_abs = 8'hAE;  //  3       4

localparam
  //
  // Load Index Register Y from Memory
  //
  // Flags Affected: n - - - - - z -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  LDY_imm = 8'hA0,  //  2       2
  LDY_abs = 8'hAC;  //  3       4

localparam
  //
  // Logical Shift Memory or Accumulator Right
  //
  // Flags Affected: n - - - - - z c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  LSR_abs = 8'h4E;  //  3       6

localparam
  //
  // No Operation
  //
  // Flags Affected: - - - - - - - -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  NOP_imp = 8'hEA;  //  1       2

localparam
  //
  // OR Accumulator with Memory
  //
  // Flags Affected: n - - - - - z -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  ORA_abs = 8'h0D;  //  3       4

localparam
  //
  // Rotate Memory or Accumulator Left
  //
  // Flags Affected: n - - - - - z c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  ROL_abs = 8'h2E;  //  3       6                Y

localparam
  //
  // Rotate Memory or Accumulator Right
  //
  // Flags Affected: n - - - - - z c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  ROR_abs = 8'h6E;  //  3       6

localparam
  //
  // Subtract with Borrow from Accumulator
  //
  // Flags Affected: n v - - - - z c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  SBC_abs = 8'hED;  //  3       4

localparam
  //
  // Store Accumulator to Memory
  //
  // Flags Affected: - - - - - - - -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  STA_abs = 8'h8D;  //  3       4

localparam
  //
  // Store Index X to Memory
  //
  // Flags Affected: - - - - - - - -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  STX_abs = 8'h8E;  //  3       4

localparam
  //
  // Store Index Y to Memory
  //
  // Flags Affected: - - - - - - - -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  STY_abs = 8'h8C;  //  3       4

localparam
  //
  // Clear Carry Flag
  //
  // Flags Affected: - - - - - - - c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  CLC_imp = 8'h18;  //  1       2

localparam
  //
  // Clear Overflow Flag
  //
  // Flags Affected: - v - - - - - -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  CLV_imp = 8'hB8;  //  1       2

localparam
  //
  // Set Carry Flag
  //
  // Flags Affected: - - - - - - - c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  SEC_imp = 8'h38;  //  1       2

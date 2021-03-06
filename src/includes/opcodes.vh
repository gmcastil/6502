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
// acc   Accumulator
// abs   Absolute                            $0000
// zp    Zero page                           $00
// abx   Absolute indexed with X             $0000, X
// aby   Absolute indexed with Y             $0000, Y
// zpx   Zero page indexed with X            $00, X
// zpy   Zero page indexed with Y            $00, Y
// inx   Indexed indirect with X             ($00, X)
// iny   Indirect indexed with Y             ($00), Y
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

localparam
  //
  // Add With Carry
  //
  // Flags Affected: n v - - - - z c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  ADC_imm = 8'h69,  //  2       2
  ADC_zp  = 8'h65,  //  2       3
  ADC_zpx = 8'h75,  //  2       4
  ADC_abs = 8'h6D,  //  3       4                Y
  ADC_abx = 8'h7D,  //  3       4+
  ADC_aby = 8'h79,  //  3       4+
  ADC_inx = 8'h61,  //  2       6
  ADC_iny = 8'h71;  //  2       5+

localparam
  //
  // AND Accumulator with Memory
  //
  // Flags Affected: n - - - - - z -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  AND_imm = 8'h29,  //  2       2
  AND_zp  = 8'h25,  //  2       3
  AND_zpx = 8'h35,  //  2       4
  AND_abs = 8'h2D,  //  3       4                Y
  AND_abx = 8'h3D,  //  3       4+
  AND_aby = 8'h39,  //  3       4+
  AND_inx = 8'h21,  //  2       6
  AND_iny = 8'h31;  //  2       5+

localparam
  //
  // Shift Memory or Accumulator Left
  //
  // Flags Affected: n - - - - - z c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  ASL_acc = 8'h0A,  //  1       2
  ASL_zp  = 8'h06,  //  2       5
  ASL_zpx = 8'h16,  //  2       6
  ASL_abs = 8'h0E,  //  3       6
  ASL_abx = 8'h1E;  //  3       7

localparam
  //
  // Test Memory Bits Against Accumulator
  //
  // Flags Affected: n v - - - - z - (other than immediate)
  //                 - - - - - - z - (immediate only)
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  BIT_zp  = 8'h24,  //  2       3
  BIT_abs = 8'h2C;  //  3       4

localparam
  //
  // Branching instructions
  //
  // Flags Affected: - - - - - - - -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  BPL     = 8'h10,  //  2       2+
  BMI     = 8'h30,  //  2       2+
  BVC     = 8'h50,  //  2       3
  BVS     = 8'h70,  //  2       2+
  BCC     = 8'h90,  //  2       2+
  BCS     = 8'hB0,  //  2       2+
  BNE     = 8'hD0,  //  2       2+
  BEQ     = 8'hF0;  //  2       2+

localparam
  //
  // Break
  //
  // Flags Affected: - - - - - - - -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  BRK     = 8'h00;  //  1       7

localparam
  //
  // Compare Accumulator with Memory
  //
  // Flags Affected: n - - - - - z c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  CMP_imm = 8'hC9,  //  2       2
  CMP_zp  = 8'hC5,  //  2       3
  CMP_zpx = 8'hD5,  //  2       4
  CMP_abs = 8'hCD,  //  3       4
  CMP_abx = 8'hDD,  //  3       4+
  CMP_aby = 8'hD9,  //  3       4+
  CMP_inx = 8'hC1,  //  2       6
  CMP_iny = 8'hD1;  //  2       5+

localparam
  //
  // Compare X Index Register with Memory
  //
  // Flags Affected: n - - - - - z c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  CPX_imm = 8'hE0,  //  2       2
  CPX_zp  = 8'hE4,  //  2       3
  CPX_abs = 8'hEC;  //  3       4

localparam
  //
  // Compare Y Index Register with Memory
  //
  // Flags Affected: n - - - - - z c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  CPY_imm = 8'hC0,  //  2       2
  CPY_zp  = 8'hC4,  //  2       3
  CPY_abs = 8'hCC;  //  3       4

localparam
  //
  // Decrement
  //
  // Flags Affected: n - - - - - z -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  DEC_zp  = 8'hC6,  //  2       5
  DEC_zpx = 8'hD6,  //  2       6
  DEC_abs = 8'hCE,  //  3       6
  DEC_abx = 8'hDE;  //  3       7

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
  EOR_imm = 8'h49,  //  2       2
  EOR_zp  = 8'h45,  //  2       3
  EOR_zpx = 8'h55,  //  2       4
  EOR_abs = 8'h4D,  //  3       4
  EOR_abx = 8'h5D,  //  3       4+       3
  EOR_aby = 8'h59,  //  3       4+       3
  EOR_inx = 8'h41,  //  2       6
  EOR_iny = 8'h51;  //  2       5+

localparam
  //
  // Increment
  //
  // Flags Affected: n - - - - - z -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  INC_zp  = 8'hE6,  //  2       5
  INC_zpx = 8'hf6,  //  2       6
  INC_abs = 8'hEE,  //  3       6
  INC_abx = 8'hFE;  //  3       7

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
  JMP_abs = 8'h4C,  //  3       3
  JMP_ind = 8'h6C;  //  3       5

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
  LDA_zp  = 8'hA5,  //  2       3
  LDA_zpx = 8'hB5,  //  2       4
  LDA_abs = 8'hAD,  //  3       4
  LDA_abx = 8'hBD,  //  3       4+       3
  LDA_aby = 8'hB8,  //  3       4+       3
  LDA_inx = 8'hA1,  //  2       6
  LDA_iny = 8'hB1;  //  2       5+

localparam
  //
  // Load Index Register X from Memory
  //
  // Flags Affected: n - - - - - z -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  LDX_imm = 8'hA2,  //  2       2
  LDX_zp  = 8'hA6,  //  2       3
  LDX_zpy = 8'hB6,  //  2       4
  LDX_abs = 8'hAE,  //  3       4
  LDX_aby = 8'hBE;  //  3       4+       3

localparam
  //
  // Load Index Register Y from Memory
  //
  // Flags Affected: n - - - - - z -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  LDY_imm = 8'hA0,  //  2       2
  LDY_zp  = 8'hA4,  //  2       3
  LDY_zpx = 8'hB4,  //  2       4
  LDY_abs = 8'hAC,  //  3       4
  LDY_abx = 8'hBC;  //  3       4+       4

localparam
  //
  // Logical Shift Memory or Accumulator Right
  //
  // Flags Affected: n - - - - - z c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  LSR_acc = 8'h4A,  //  1       2
  LSR_zp  = 8'h46,  //  2       5
  LSR_zpx = 8'h56,  //  2       6
  LSR_abs = 8'h4E,  //  3       6
  LSR_abx = 8'h5E;  //  3       7

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
  ORA_imm = 8'h09,  //  2       2
  ORA_zp  = 8'h05,  //  2       3
  ORA_zpx = 8'h15,  //  2       4
  ORA_abs = 8'h0D,  //  3       4
  ORA_abx = 8'h1D,  //  3       4+       3
  ORA_aby = 8'h19,  //  3       4+       3
  ORA_inx = 8'h01,  //  2       6
  ORA_iny = 8'h11;  //  2       5+

localparam
  //
  // Rotate Memory or Accumulator Left
  //
  // Flags Affected: n - - - - - z c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  ROL_acc = 8'h2A,  //  1       2
  ROL_zp  = 8'h26,  //  2       5
  ROL_zpx = 8'h36,  //  2       6
  ROL_abs = 8'h2E,  //  3       6                Y
  ROL_abx = 8'h3E;  //  3       7

localparam
  //
  // Rotate Memory or Accumulator Right
  //
  // Flags Affected: n - - - - - z c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  ROR_acc = 8'h6A,  //  1       2
  ROR_zp  = 8'h66,  //  2       5
  ROR_zpx = 8'h76,  //  2       6
  ROR_abs = 8'h6E,  //  3       6
  ROR_abx = 8'h7E;  //  3       7

localparam
  //
  // Subtract with Borrow from Accumulator
  //
  // Flags Affected: n v - - - - z c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  SBC_imm = 8'hE9,  //  2       2
  SBC_zp  = 8'hE5,  //  2       3
  SBC_zpx = 8'hF5,  //  2       4
  SBC_abs = 8'hED,  //  3       4
  SBC_abx = 8'hFD,  //  3       4+       3
  SBC_aby = 8'hF9,  //  3       4+       3
  SBC_inx = 8'hE1,  //  2       6
  SBC_iny = 8'hF1;  //  2       5+

localparam
  //
  // Store Accumulator to Memory
  //
  // Flags Affected: - - - - - - - -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  STA_zp  = 8'h85,  //  2       3
  STA_xpz = 8'h95,  //  2       4
  STA_abs = 8'h8D,  //  3       4
  STA_abx = 8'h9D,  //  3       5
  STA_aby = 8'h99,  //  3       5
  STA_inx = 8'h81,  //  2       6
  STA_iny = 8'h91;  //  2       6

localparam
  //
  // Store Index X to Memory
  //
  // Flags Affected: - - - - - - - -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  STX_zp  = 8'h86,  //  2       3
  STX_zpy = 8'h96,  //  2       4
  STX_abs = 8'h8E;  //  3       4

localparam
  //
  // Store Index Y to Memory
  //
  // Flags Affected: - - - - - - - -
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  STY_zp  = 8'h84,  //  2       3
  STY_zpx = 8'h94,  //  2       4
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
  // Rotate Memory or Accumulator Left
  //
  // Flags Affected: n - - - - - z c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  ROL_acc = 8'h2A;  //  1       2

localparam
  //
  // Rotate Memory or Accumulator Right
  //
  // Flags Affected: n - - - - - z c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  ROR_acc = 8'h6A;  //  1       2

localparam
  //
  // Set Carry Flag
  //
  // Flags Affected: - - - - - - - c
  //
  //        Opcode      Bytes   Cycles   Notes   Implemented
  SEC_imp = 8'h38;  //  1       2

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
// ----------------------------------------------------------------------------

// A convention for identifying addressing modes:
//
// <none> Immediate or accumulator                         DEX
// IM     Immediate                                        LDA  #55
// A      Absolute                                         LDA  $2000
// PCR    PC relative                                      BEQ  LABEL12
// S      Stack                                            PHA
// Z      Zero page                                        LDA  $81
// X      Absolute indexed with X                          LDA  $2000, X
// Y      Absolute indexed with Y                          LDA  $2000, Y
// ZX     Zero page indexed with X                         LDA  $55, X
// ZY     Zero page indexed with Y                         LDA  $55, Y
// AI     Absolute indirect                                JMP  ($1020)
// ZIX    Zero page indexed indirect with X (preindexed)   LDA  ($55), Y
// ZIY    Zero page indirect indexed with Y (postindexed)  LDA  ($55, Y)

// Note that there is some asymmetry here between indexed indirect mode
// (used only with the X register) and indirect indexed mode (used only with
// the Y register).  These modes are distinct with respect to each other and
// should not be confused.

// Some notes on cycle counting:
//
// 1 -
// 2 -
// 3 -
// 4 -

// Also note that each instruction will affect the status of processor flags
// These data are not included here.  See chapter 18 in [1] for details.

localparam
  //
  // Add With Carry (ADC)
  //
  //        Opcode     Addr Mode          Syntax        Bytes   Cycles   Notes    Implemented?
  //        ------     ---------          ------        ------  ------   -----    ------------
  ADC     = 8'h69,  // Immediate          ADC #const    2       2        1,4
  ADC_A   = 8'h6D,  // Absolute           ADC addr      3       4        1,4
  ADC_Z   = 8'h65,  // ZP                 ADC zp        2       3        1,2,4
  ADC_X   = 8'h7D,  // Absolute X         ADC addr, X   3       4        1,3,4
  ADC_Y   = 8'h79,  // Absolute Y         ADC addr, Y   3       4        1,3,4
  ADC_ZX  = 8'h75,  // ZP index X         ADC zp, X     2       4        1,2,4
  ADC_ZIX = 8'h61,  // ZP ind indirect X  ADC (zp, X)   2       6        1,2,4
  ADC_ZIY = 8'h71;  // ZP indirect ind Y  ADC (zp), Y   2       5        1,2,3,4

  //
  // And Accumulator With Memory (AND)
  //
  //        Opcode     Addr Mode      Syntax        Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------        ------  ------   -----    ------------


  //
  // Shift Memory or Accumulator Left (ASL)
  //
  //        Opcode     Addr Mode      Syntax        Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------        ------  ------   -----    ------------


  //
  // Branch if Carry Clear (BCC)
  //
  //        Opcode     Addr Mode      Syntax        Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------        ------  ------   -----    ------------


  //
  // Branch if Carry Set (BCS)
  //
  //        Opcode     Addr Mode      Syntax        Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------        ------  ------   -----    ------------


  //
  // Branch if Equal (BEQ)
  //
  //        Opcode     Addr Mode      Syntax        Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------        ------  ------   -----    ------------


  //
  // Test Memory Bits Against Accumulator (BIT)
  //
  //        Opcode     Addr Mode      Syntax        Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------        ------  ------   -----    ------------


  //
  // Brand if Minus (BMI)
  //
  //        Opcode     Addr Mode      Syntax        Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------        ------  ------   -----    ------------


  //
  // Branch if Not Equal (BNE)
  //
  //        Opcode     Addr Mode      Syntax        Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------        ------  ------   -----    ------------


  //
  // Branch if Plus (BPL)
  //
  //        Opcode     Addr Mode      Syntax        Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------        ------  ------   -----    ------------


  //
  // Software Break (BRK)
  //
  //        Opcode     Addr Mode      Syntax        Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------        ------  ------   -----    ------------


  //
  // Branch if Overflow Clear (BVC)
  //
  //        Opcode     Addr Mode      Syntax        Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------        ------  ------   -----    ------------


  //
  // Branch if Overflow Set (BVS)
  //
  //        Opcode     Addr Mode      Syntax        Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------        ------  ------   -----    ------------


  //
  // Clear Carry Flag (CLC)
  //
  //        Opcode     Addr Mode      Syntax        Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------        ------  ------   -----    ------------


  //
  // Clear Decimal Mode Flag (CLD)
  //
  //        Opcode     Addr Mode      Syntax        Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------        ------  ------   -----    ------------


  //
  // Clear Interrupt Disable Flag (CLI)
  //
  //        Opcode     Addr Mode      Syntax        Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------        ------  ------   -----    ------------


  //
  // Clear Overflow Flag (CLV)
  //
  //        Opcode     Addr Mode      Syntax        Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------        ------  ------   -----    ------------


  //
  // Compare Accumulator with Memory (CMP)
  //
  //        Opcode     Addr Mode      Syntax        Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------        ------  ------   -----    ------------


  //
  // Compare Index Register X with Memory (CPX)
  //
  //        Opcode     Addr Mode      Syntax        Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------        ------  ------   -----    ------------


  //
  // Compare Index Register Y with Memory (CPY)
  //
  //        Opcode     Addr Mode      Syntax        Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------        ------  ------   -----    ------------


  //
  // Decrement (DEC)
  //
  //        Opcode     Addr Mode      Syntax        Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------        ------  ------   -----    ------------


  //
  // Decrement Index Register X (DEX)
  //
  //        Opcode     Addr Mode      Syntax        Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------        ------  ------   -----    ------------


  //
  // Decrement Index Register Y (DEY)
  //
  //        Opcode     Addr Mode      Syntax        Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------        ------  ------   -----    ------------


  //
  // Jump (JMP)
  //
  //        Opcode     Addr Mode      Syntax        Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------        ------  ------   -----    ------------

localparam NOP = 8'hEA; //
localparam JMP = 8'h4C; //
localparam LDA = 8'hA9; //

// -*- var-name:

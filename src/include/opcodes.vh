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
// <none> immediate, accumulator, or PC relative
// A      absolute
// D      direct page
// DI     DP indirect
// X      absolute indexed, X
// Y      absolute indexed, Y
// DX     DP indexed, X
// DIX    DP indexed indirect, X
// DIY    DP indirect indexed, Y

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
  //                                              65C02
  //        Opcode     Addr Mode      Syntax      Only    Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------      -----   ------  ------   -----    ------------
  ADC     = 8'h69,  // Immediate      ADC #const          2       2        1,4
  ADC_A   = 8'h6D,  // Abs            ADC addr            3       4        1,4
  ADC_D   = 8'h65,  // DP             ADC dp              2       3        1,2,4
  ADC_DI  = 8'h72,  // DP indirect    ADC (dp)      *     2       5        1,2,4
  ADC_X   = 8'h7D,  // Abs X          ADC addr, X         3       4        1,3,4
  ADC_Y   = 8'h79,  // Abs Y          ADC addr, Y         3       4        1,3,4
  ADC_DX  = 8'h75,  // DP index X     ADC dp, X           2       4        1,2,4
  ADC_DIX = 8'h61,  // DP indirect X  ADC (dp, X)         2       6        1,2,4
  ADC_DIY = 8'h71;  // DP indirect Y  ADC (dp), Y         2       5        1,2,3,4

localparam
  //
  // And Accumulator With Memory (AND)
  //                                              65C02
  //        Opcode     Addr Mode      Syntax      Only    Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------      -----   ------  ------   -----    ------------
  AND     = 8'h29,  // Immediate      AND #const          2       2        1
  AND_A   = 8'h2D,  // Abs            AND addr            3       4        1
  AND_D   = 8'h25,  // DP             AND dp              2       3        1,2
  AND_DI  = 8'h32,  // DP indirect    AND (dp)      *     2       5        1,2
  AND_X   = 8'h3D,  // Abs X          AND addr, X         3       4        1,3
  AND_Y   = 8'h39,  // Abs Y          AND addr, Y         3       4        1,3
  AND_DX  = 8'h35,  // DP index X     AND dp, X           2       4        1,2
  AND_DIX = 8'h21,  // DP indirect X  AND (dp, X)         2       6        1,2
  AND_DIY = 8'h31;  // DP indirect Y  AND (dp) Y          2       5        1,2,3

localparam
  //
  // Shift Memory or Accumulator Left (ASL)
  //                                              65C02
  //        Opcode     Addr Mode      Syntax      Only    Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------      -----   ------  ------   -----    ------------
  ASL     = 8'h0A,  // Accumulator    ASL A               1       2
  ASL_A   = 8'h0E,  // Abs            ASL addr            3       6        1
  ASL_D   = 8'h06,  // DP             ASL dp              2       5        1,2
  ASL_X   = 8'h1E,  // Abs X          ASL addr, X         3       7        1,3
  ASL_DX  = 8'h16;  // DP index X     ASL dp, X           2       6        1,2

localparam
  //
  // Branch if Carry Clear (BCC)
  //                                              65C02
  //        Opcode     Addr Mode      Syntax      Only    Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------      -----   ------  ------   -----    ------------
  BCC     = 8'h90;  // PC relative    BCC label           2       2        1,2

localparam
  //
  // Branch if Carry Set (BCS)
  //                                              65C02
  //        Opcode     Addr Mode      Syntax      Only    Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------      -----   ------  ------   -----    ------------
  BCS     = 8'hB0;  // PC relative    BCS label           2       2        1,2

localparam
  //
  // Branch if Equal (BEQ)
  //                                              65C02
  //        Opcode     Addr Mode      Syntax      Only    Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------      -----   ------  ------   -----    ------------
  BEQ     = 8'hF0;  // PC relative    BEQ label           2       2        1,2

localparam
  //
  // Test Memory Bits Against Accumulator (BIT)
  //                                              65C02
  //        Opcode     Addr Mode      Syntax      Only    Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------      -----   ------  ------   -----    ------------
  BIT     = 8'h89,  // Immediate      BIT #const    *     2       2        1
  BIT_A   = 8'h2C,  // Abs            BIT addr            3       4        1
  BIT_D   = 8'h24,  // DP             BIT dp              2       3        1,2
  BIT_X   = 8'h3C,  // Abs X          BIT addr, X   *     3       4        1,3
  BIT_DX  = 8'h34;  // DP X           BIT dp, X     *     2       4        1,2

localparam
  //
  // Brand if Minus (BMI)
  //                                              65C02
  //        Opcode     Addr Mode      Syntax      Only    Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------      -----   ------  ------   -----    ------------
  BMI     = 8'h30;  // PC relative    BMI label           2       2        1,2

localparam
  //
  // Branch if Not Equal (BNE)
  //                                              65C02
  //        Opcode     Addr Mode      Syntax      Only    Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------      -----   ------  ------   -----    ------------
  BNE     = 8'hD0;  // PC relative    BNE label           2       2        1,2

localparam
  //
  // Branch if Plus (BPL)
  //                                              65C02
  //        Opcode     Addr Mode      Syntax      Only    Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------      -----   ------  ------   -----    ------------
  BPL     = 8'h10;  // PC relative    BPL label           2       2        1,2

localparam
  //
  // Branch Always (BRA)
  //                                              65C02
  //        Opcode     Addr Mode      Syntax      Only    Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------      -----   ------  ------   -----    ------------
  BRA     = 8'h80;  // PC relative    BRA label     *     2       3        1

localparam
  //
  // Software Break (BRK)
  //                                              65C02
  //        Opcode     Addr Mode      Syntax      Only    Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------      -----   ------  ------   -----    ------------
  BRK     = 8'h00;  // Stack / IRQ    BRK                 2       7        1

localparam
  //
  // Branch if Overflow Clear (BVC)
  //                                              65C02
  //        Opcode     Addr Mode      Syntax      Only    Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------      -----   ------  ------   -----    ------------
  BVC     = 8'h50;  // PC relative    BVC label           2       2        1,2

localparam
  //
  // Branch if Overflow Set (BVS)
  //                                              65C02
  //        Opcode     Addr Mode      Syntax      Only    Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------      -----   ------  ------   -----    ------------
  BVS     = 8'h70;  // PC relative    BVC label           2       2        1,2

localparam
  //
  // Clear Carry Flag (CLC)
  //                                              65C02
  //        Opcode     Addr Mode      Syntax      Only    Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------      -----   ------  ------   -----    ------------
  CLC     = 8'h18;  // Implied        CLC                 1       2

localparam
  //
  // Clear Decimal Mode Flag (CLD)
  //                                              65C02
  //        Opcode     Addr Mode      Syntax      Only    Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------      -----   ------  ------   -----    ------------
  CLD     = 8'hD8;  // Implied        CLD                 1       2

localparam
  //
  // Clear Interrupt Disable Flag (CLI)
  //                                              65C02
  //        Opcode     Addr Mode      Syntax      Only    Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------      -----   ------  ------   -----    ------------
  CLI     = 8'h58;  // Implied        CLI                 1       2

localparam
  //
  // Clear Overflow Flag (CLV)
  //                                              65C02
  //        Opcode     Addr Mode      Syntax      Only    Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------      -----   ------  ------   -----    ------------
  CLV     = 8'hB8;  // Implied        CLV                 1       2

localparam
  //
  // Compare Accumulator with Memory (CMP)
  //                                              65C02
  //        Opcode     Addr Mode      Syntax      Only    Bytes   Cycles   Notes    Implemented?
  //        ------     ---------      ------      -----   ------  ------   -----    ------------
  CMP     = 8'hC9,  // Immediate      CMP #const          2       2        1
  CMP_A   = 8'hCD,  // Abs            CMP addr            3       4        1
  CMP_D   = 8'hC5,  // DP             CMP dp              2       3        1,2
  CMP_DI  = 8'hD2,  // DP indirect    CMP (dp)      *     2       5        1,2
  CMP_X   = 8'hDD,  // Abs X          CMP addr, X         3       4        1,3
  CMP_Y   = 8'hD9,  // Abs Y          CMP addr, Y         3       4        1,3
  CMP_DX  = 8'hD5,  // DP index X     CMP dp, X           2       4        1,2
  CMP_DIX = 8'hC1,  // DP indirect X  CMP (dp, X)         2       6        1,2
  CMP_DIY = 8'hD1;  // DP indirect Y  CMP (dp), Y         2       5        1,2,3


localparam NOP = 8'hEA; //
localparam JMP = 8'h4C; //
localparam LDA = 8'hA9; //

// -*- var-name:

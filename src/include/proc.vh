// ----------------------------------------------------------------------------
// Module:  proc.vh
// Project:
// Author:  George Castillo <gmcastil@gmail.com>
// Date:    17 July 2017
//
// Description: Definitions used by the processor, specifically the FSM and
// opcode definitions.
// ----------------------------------------------------------------------------

// --- Opcode Definitions

// Helpful abbreviations

// <none> immediate
// A      absolute
// D      direct page
// DI     DP indirect
// X      absolute indexed, X
// Y      absolute indexed, Y
// DX     DP indexed, X
// DY     DP indexed, Y
// DIX    DP indirect indexed, X
// DIY    DP indirect indexed, Y

// Add With Carry (ADC)
//                                                       65C02
//         Inst      Opcode     Addr Mode    Syntax      Only    Bytes   Cycles   Notes  Implemented?
//         ----      ------     ---------    ------      -----   ------  ------   -----  ------------
// localparam ADC     = 8'h69;  // Immediate    ADC #const            2       2      1,4
// localparam ADC_A   = 8'h6D;  // Abs          ADC addr              3       4      1,4
// localparam ADC_D   = 8'h65;  // DP           ADC dp                2       3      1,2,4
// localparam ADC_DI  = 8'h72;  // DP indirect  ADC (dp)      X       2       5      1,2,4
// localparam ADC_X   = 8'h7D;  // Abs index X  ADC

// localparam



localparam NOP = 8'hEA; //
localparam JMP = 8'h4C; //
localparam LDA = 8'hA9; //

// -*- var-name:

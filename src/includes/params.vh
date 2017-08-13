// ----------------------------------------------------------------------------
// Module:  params.vh
// Project: MOS 6502 Processor
// Author:  George Castillo <gmcastil@gmail.com>
// Date:    30 July 2017
//
// Description: Common parameters used by the processor and the ALU
// ----------------------------------------------------------------------------

`ifndef PARAMS

`define PARAMS

  // --- Indices Into Processor Status Register
  parameter NEG    = 7;
  parameter OVF    = 6;
  parameter UNUSED = 5;
  parameter BREAK  = 4;
  parameter BCD    = 3;
  parameter IRQ    = 2;
  parameter ZERO   = 1;
  parameter CARRY  = 0;

  // --- ALU Control and Mux Signals
  parameter ADD    = 3'b000;
  parameter OR     = 3'b001;
  parameter XOR    = 3'b010;
  parameter AND    = 3'b011;
  parameter SR     = 3'b100;
  parameter SL     = 3'b101;
  parameter SUB    = 3'b110;

`endif //  `ifndef PARAMS

// ----------------------------------------------------------------------------
// Module:  params.vh
// Project: MOS 6502 Processor
// Author:  George Castillo <gmcastil@gmail.com>
// Date:    30 July 2017
//
// Description: Common localparams used by the processor and the ALU
// ----------------------------------------------------------------------------

// --- Indices Into Processor Status Register
localparam NEG    = 7;
localparam OVF    = 6;
localparam UNUSED = 5;
localparam BREAK  = 4;
localparam BCD    = 3;
localparam IRQ    = 2;
localparam ZERO   = 1;
localparam CARRY  = 0;

// --- ALU Control and Mux Signals
localparam ADD = 3'b000;
localparam SR  = 3'b001;
localparam AND = 3'b010;
localparam OR  = 3'b011;
localparam XOR = 3'b100;

// ----------------------------------------------------------------------------
// Module:  alu.v
// Project: MOS 6502 Processor
// Author:  George Castillo
// Date:    Sat Jul  8 15:31:17 2017
//
// Description: Arithmetic-logic unit for the MOS 6502 processor.
//
// Usage: The ALU is used by the processor to perform the majority of its
// arithmetic functions.  Some details about the implementation follow.
//
// Control Signals:
//   ADD = 3'b000
//   SR  = 3'b001
//   AND = 3'b010
//   OR  = 3'b011
//   XOR = 3'b100
//
// Logical operations do not distinguish between the A and B inputs.  The right
// shift operation however only supports the A input.
// ----------------------------------------------------------------------------

module alu
  (
   input [2:0]      alu_control,
   input [7:0]      alu_AI,
   input [7:0]      alu_BI,
   input            alu_carry_in,

   output reg [7:0] alu_Y,
   output reg       alu_carry_out,
   output reg       alu_overflow
   );

//`include "./includes/params.vh"
`include "../src/includes/params.vh"

  // --- Miscellaneous Signals
  reg [8:0]         result;  // 9-bits to keep track of the carry

  // Select which operation to bring out
  always @(*) begin

    case ( alu_control )

      ADD: begin

      end

      SR: begin

      end

      AND: begin

      end

      OR: begin

      end

      XOR: begin

      end

      default: begin end

    endcase // case ( ctrl )
  end

  // Select which value to use for the carry out bit
  always @(*) begin

  end

  // Compute the overflow value
  always @(*) begin

  end

endmodule // alu

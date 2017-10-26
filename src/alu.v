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
//   OR  = 3'b001
//   XOR = 3'b010
//   AND = 3'b011
//   SR  = 3'b100
//
// Logical operations do not distinguish between the A and B inputs.  The right
// shift operation however only supports the A input.
// ----------------------------------------------------------------------------

module alu
  (
   input [2:0]      control
   input [7:0]      AI,
   input [7:0]      BI,
   input            carry_in,

   output reg [7:0] Y,
   output reg       carry_out,
   output reg       overflow
   );

`include "./includes/params.vh"

  // --- Miscellaneous Signals
  reg [8:0]         result;  // 9-bits to keep track of the carry

  always @(*) begin

    // Default for all ALU output flags
    alu_flags = 8'b0;

    case ( alu_ctrl )

      ADD: begin
        // Affects Flags: N V Z C
          // Binary addition with carry in
          result = {1'b0, alu_AI} + {1'b0, alu_BI} + { 8'b0, alu_carry };
          alu_Y = result[7:0];
          alu_flags[CARRY] = result[8];
      end

      // OR: begin
      //   // Affects Flags: N Z
      //   alu_Y = alu_AI | alu_BI;
      //   // Set if result is zero; else cleared
      //   if (alu_Y == 8'b0) begin
      //     alu_flags[ZERO] = 1'b0;
      //   end else begin
      //     alu_flags[ZERO] = 1'b1;
      //   end
      //   // Set if MSB is set; else cleared
      //   alu_flags[NEG] = alu_Y[7];
      // end

//      XOR: begin
//        // Affects Flags: N Z
//        Y = AI ^ BI;
//        // Set if result is zero; else cleared
//        if (Y == 8'b0) begin
//          Z = 1'b0;
//        end else begin
//          Z = 1'b1;
//        end
//        // Set if MSB is set; else cleared
//        N = Y[7];
//      end

      AND: begin
        // Affects Flags: N Z
        alu_Y = alu_AI & alu_BI;
        // Set if result is zero; else cleared
        if (alu_Y == 8'b0) begin
          alu_flags[ZERO] = 1'b1;
        end else begin
          alu_flags[ZERO] = 1'b0;
        end
        // Set if MSB is set; else cleared
        alu_flags[NEG] = alu_Y[7];
      end

      SR: begin
        alu_Y = { 1'b0, alu_AI[7:1] };
        alu_flags[CARRY] = alu_AI[0];
        if (alu_Y == 8'b0) begin
          alu_flags[ZERO] = 1'b1;
        end else begin
          alu_flags[ZERO] = 1'b0;
        end
        alu_flags[NEG] = alu_Y[7];
      end

      SL: begin
        alu_Y = { alu_AI[6:0], 1'b0 };
        alu_flags[CARRY] = alu_AI[7];
        if (alu_Y == 8'b0) begin
          alu_flags[ZERO] = 1'b1;
        end else begin
          alu_flags[ZERO] = 1'b0;
        end
        alu_flags[NEG] = alu_Y[7];
      end

      default: begin end

    endcase // case ( ctrl )

  end

endmodule // alu

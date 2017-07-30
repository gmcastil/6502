// ----------------------------------------------------------------------------
// Module:  alu.sv
// Project: MOS 6502 Processor
// Author:  George Castillo
// Date:    Sat Jul  8 15:31:17 2017
//
// Description: Early cut at an arithmetic logic unit (ALU) for the
// 6502 processor. Does not completely support BCD mode yet and has
// had virtually zero testing performed on it.
// ----------------------------------------------------------------------------

module alu
  (
   input [2:0]      alu_ctrl,
   input [7:0]      alu_AI,
   input [7:0]      alu_BI,
   input            alu_carry,
   input            alu_BCD,

   output reg [7:0] alu_flags,
   output reg [7:0] alu_Y
   );

  // --- Control Signals
  localparam ADD    = 3'b000;
  localparam OR     = 3'b001;
  localparam XOR    = 3'b010;
  localparam AND    = 3'b011;
  localparam SR     = 3'b100;
  localparam SL     = 3'b101;
  localparam SUB    = 3'b110;

  // --- Indices Into ALU Status Flags (shared with processor)
  localparam NEG    = 7;  // negative result
  localparam OVF    = 6;  // overflow
  localparam UNUSED = 5;
  localparam BREAK  = 4;
  localparam BCD    = 3;  // mode for add and subtract
  localparam IRQ    = 2;  // enable or disable IRQ line
  localparam ZERO   = 1;
  localparam CARRY  = 0;

  // --- Other Miscellaneous Signals
  reg [8:0]         result;  // 9-bits

  always @(*) begin

    case ( alu_ctrl )

      ADD: begin
        // Affects Flags: N V Z C
        if (alu_BCD == 1'b1) begin
          // BCD addition
        end else begin
          // Binary addition with carry in
          result = {1'b0, alu_AI} + {1'b0, alu_BI} + alu_carry;
          alu_Y = result[7:0];
          alu_flags[CARRY] = result[8];
        end
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

//      SR: begin
//        // Affects Flags: N Z CO
//        Y = {CI, AI[7:1]};
//        // Low bit becomes carry: set if low bit is set; cleared if low bit was
//        // clear
//        CO = AI[0];
//        // Set if result is zero; else cleared
//        if (Y == 8'b0) begin
//          Z = 1'b0;
//        end else begin
//          Z = 1'b1;
//        end
//        // Set if MSB is set; else cleared
//        N = Y[7];
//      end

      default: begin end

    endcase // case ( ctrl )

  end

endmodule // alu

// ----------------------------------------------------------------------------
// Module:  alu.sv
// Project: MOS 6502 Processor
// Author:  George Castillo
// Date:    Sat Jul  8 15:31:17 2017
//
// Description: Early cut at an arithmetic logic unit (ALU) for the
// 6502 processor. Does not completely support BCD mode yet and has
// had virtually zero testing performed on it.
----------------------------------------------------------------------------

  module alu
    #(
      // parameter
      )
  (
   input [2:0]      alu_ctrl,
   input [7:0]      alu_AI,
   input [7:0]      alu_BI,
   input            alu_carry, // carry in
   input            alu_DAA,   // BCD enable

   output reg [7:0] alu_flags,
   output reg [7:0] alu_Y
   );

  // --- Control Signals
  parameter SUM = 3'b000;
  parameter OR  = 3'b001;
  parameter XOR = 3'b010;
  parameter AND = 3'b011;
  parameter SR  = 3'b100;

  // --- Index Into ALU Status Flags (shared with processor)
  localparam NEG   = 7;  // negative result
  localparam OFV   = 6;  // overflow
  localparam BREAK = 4;
  localparam BCD   = 3;  // mode for add and subtract
  localparam IRQ   = 2;  // enable or disable IRQ line
  localparam ZERO  = 1;
  localparam CARRY = 0;

  // Signals used in the case statement
  reg [8:0]         result;

  always @(*) begin

    // Set default values for processor status register
    N = 1'b0;
    V = 1'b0;
    Z = 1'b0;
    CO = 1'b0;
    HC = 1'b0;
    result = 9'b0;

    case ( ctrl )

      SUM: begin
        // Affects Flags: N V Z C
        if (DAA) begin
          // BCD addition (not sure if there is a carry here)
        end else begin
          // Binary addition with carry in
          result = {1'b0, AI} + {1'b0, BI} + CI;
          Y = result[7:0];
          CO = result[8];
        end
      end

      OR: begin
        // Affects Flags: N Z
        Y = AI | BI;
        // Set if result is zero; else cleared
        if (Y == 8'b0) begin
          Z = 1'b0;
        end else begin
          Z = 1'b1;
        end
        // Set if MSB is set; else cleared
        N = Y[7];
      end

      XOR: begin
        // Affects Flags: N Z
        Y = AI ^ BI;
        // Set if result is zero; else cleared
        if (Y == 8'b0) begin
          Z = 1'b0;
        end else begin
          Z = 1'b1;
        end
        // Set if MSB is set; else cleared
        N = Y[7];
      end

      AND: begin
        // Affects Flags: N Z
        Y = AI & BI;
        // Set if result is zero; else cleared
        if (Y == 8'b0) begin
          Z = 1'b0;
        end else begin
          Z = 1'b1;
        end
        // Set if MSB is set; else cleared
        N = Y[7];
      end

      SR: begin
        // Affects Flags: N Z CO
        Y = {CI, AI[7:1]};
        // Low bit becomes carry: set if low bit is set; cleared if low bit was
        // clear
        CO = AI[0];
        // Set if result is zero; else cleared
        if (Y == 8'b0) begin
          Z = 1'b0;
        end else begin
          Z = 1'b1;
        end
        // Set if MSB is set; else cleared
        N = Y[7];
      end

      default: begin end

    endcase // case ( ctrl )

  end

endmodule // alu

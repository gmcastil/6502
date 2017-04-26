module alu
  #(
    // parameter
    )
  (
   input [2:0]      ctrl,
   input [7:0]      AI,
   input [7:0]      BI,
   input            CI, // carry in
   input            DAA, // BCD enable

   // Processor status register flags
   output reg       N, // negative result
   output reg       V, // sign bit overflow
   output reg       Z, // zero result
   output reg       CO, // arithmetic carry
   output           HC, // half carry

   output reg [7:0] Y
   );

  parameter SUM = 3'b000;
  parameter OR  = 3'b001;
  parameter XOR = 3'b010;
  parameter AND = 3'b011;
  parameter SR  = 3'b100;

  // Signals used in the case statement
  reg [8:0]         result;

  always @(*) begin

    case (ctrl)

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

    endcase // case (ctrl)

  end

endmodule // alu

module alu
  #(
    // parameter
    )
  (
   input [3:0]  ctrl,
   input [7:0]  AI,
   input [7:0]  BI,
   input        CI, // carry in
   input        D, // BCD enable

   // Processor status register flags
   output       N, // negative result
   output       V, // sign bit overflow
   output       Z, // zero result
   output reg   CO, // arithmetic carry
   output       HC, // half carry

   output reg [7:0] out
   );

  parameter ADD = 4'b0000;
  parameter OR  = 4'b0001;
  parameter XOR = 4'b0010;
  parameter AND = 4'b0011;
  parameter SR  = 4'b0011;

  // Signals used in the case statement
  reg [8:0]     result;

  always @(*) begin

    case (ctrl)

      ADD: begin
        if (D) begin
          // BCD addition (not sure if there is a carry here)
        end else begin
          // Binary addition with carry in
          $display("Here.");
          result = {1'b0, AI} + {1'b0, BI} + CI;
          out = result[7:0];
          CO = result[8];
        end
      end

      OR: begin

      end

      XOR: begin

      end

      AND: begin

      end

      SR: begin

      end

      default: begin end

    endcase // case (ctrl)

  end

endmodule // alu

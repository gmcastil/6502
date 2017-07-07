module proc
  (
   input        clk,
   input        reset,
   input [15:0] address,
   input [7:0]  read_data,

   output [7:0] write_data,
   output       write_enable
   );

  localparam RESET    = 0;
  localparam VECTOR_1 = 1;
  localparam VECTOR_2 = 2;
  localparam FETCH    = 3;
  localparam DECODE   = 4;
  localparam OPER_A1  = 5;
  localparam OPER_A2  = 6;
  localparam OPER_B1  = 7;
  localparam EXECUTE  = 8;

  reg [8:0]     present_state;
  reg [8:0]     next_state;

  reg [15:0]    PC;
  reg [7:0]     IR;

  parameter RESET_VECTOR = 16'hFFFC;

  // Operands
  parameter NOP = 8'hEA;
  parameter JMP = 8'h4C;

  always @(posedge clk) begin
    if (reset) begin
      present_state <= 9'b0;
      present_state[RESET] <= 1'b1;
    end else begin
      next_state <= present_state;
    end
  end

  always @(*) begin

    next_state = 9'b0;

    case (1'b1)

      present_state[VECTOR_1]: begin
        next_state[VECTOR_2] = 1'b1;
      end

      present_state[VECTOR_2]: begin
        next_state[FETCH] = 1'b1;
      end

      present_state[FETCH]: begin
        next_state[DECODE] = 1'b1;
      end

      present_state[DECODE]: begin

        case (IR)

          NOP: begin
            next_state[FETCH] = 1'b1;
          end

          JMP: begin
            next_state[OPER_A1] = 1'b1;
          end

          default: begin end
        endcase
      end

      present_state[OPER_A1]: begin
        next_state[OPER_A2] = 1'b1;
      end

      present_state[OPER_A2]: begin
        next_state[EXECUTE] = 1'b1;
      end

      present_state[OPER_B1]: begin
        next_state[EXECUTE] = 1'b1;
      end

      present_state[EXECUTE]: begin
        next_state[FETCH] = 1'b1;
      end

      default: begin end

    endcase
  end

  always @(posedge clk) begin

    case (1'b1)

      next_state[VECTOR_1]: begin
        address <= RESET_VECTOR;
        if (next_state[VECTOR_2] == 1'b1) begin
          PC[7:0] <= read_data;
        end
      end

      next_state[VECTOR_2]: begin
        address <= RESET_VECTOR + 1'b1;
        if (next_state[FETCH] == 1'b1) begin
          PC[15:8] <= read_data;
        end
      end

      next_state[FETCH]: begin
        address <= PC;
        if (next_state[DECODE] == 1'b1) begin
          IR <= read_data;
        end
      end

      next_state[DECODE]: begin

      end

      default: begin end

    endcase // case (1'b1)
  end

endmodule // proc

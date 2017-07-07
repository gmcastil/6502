module proc
  (
   input        clk,
   input        reset,
   input [16:0] address,
   input [7:0]  read_data,

   output [7:0] write_data,
   output       write_enable
   );

  localparam RESET    = 0;
  localparam VECTOR_1 = 1;
  localparam VECTOR_2 = 2;
  localparam FETCH    = 3;
  localparam ARG_1    = 4;
  localparam ARG_2    = 5;
  localparam EXECUTE  = 6;

  reg [6:0]     present_state;
  reg [6:0]     next_state;

  reg [15:0]    PC;
  reg [7:0]     IR;
  reg [15:0]    argument;
  reg [1:0]     arg_number;

  always @(posedge clk) begin
    if (reset) begin
      present_state <= 7'b0;
      present[RESET] <= 1'b1;
    end else begin
      next_state <= present_state;
    end
  end

  always @(*) begin
    next = 7'b0;

    case (1'b1)

      present_state[VECTOR_1]: begin
        next_state[VECTOR_2] = 1'b1;
      end

      present_state[VECTOR_2]: begin
        next_state[FETCH] = 1'b1;
      end

      present_state[FETCH]: begin
        if
      end

      default: begin end

    endcase
  end

  always @(posedge clk) begin

    case (1'b1)

      present_state[FETCH]: begin
        address <= PC;
        write_enable <= 1'b0;


endmodule // proc

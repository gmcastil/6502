module memc
  #(
    )
  (
   input        clk,
   input        reset,
   input [15:0] addr,
   input        read_en,
   input        write_en,
   output       busy,
   output       data
   );

  localparam RESET = 0;
  localparam BIST  = 1;
  localparam IDLE  = 2;
  localparam READ  = 3;
  localparam WRITE = 4;

  reg [4:0]     state;
  reg [4:0]     next;

  always @(posedge clk) begin
    if (!reset) begin
      state        <= 5'b0;
      state[RESET] <= 1'b1;
    end else begin
      state <= next;
r end
  end

  always @(*) begin

    next = 5'b0;

    case (1'b1)

      state[RESET]: begin
      end

      state[BIST]: begin
      end

      state[IDLE]: begin
      end

      state[READ]: begin
      end

      state[WRITE]: begin
      end

      default: begin
      end

    endcase // case (1'b1)
  end

  // Instantiate a 64k x 8 BRMA

endmodule // memc

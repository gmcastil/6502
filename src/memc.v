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

  // --- State machine signals
  localparam RESET      = 0;
  localparam BIST       = 1;
  localparam TEST_WR1   = 2;
  localparam TEST_RD1   = 3;
  localparam TEST_WR2   = 4;
  localparam TEST_RD2   = 5;
  localparam ERROR      = 6;
  localparam IDLE       = 7;
  localparam READ       = 8;
  localparam WRITE      = 9;

  reg [4:0]     state;
  reg [4:0]     next;

  // --- Signal declarations
  localparam [7:0] WR_PATT_1 = 8'hAA;
  localparam [7:0] WR_PATT_2 = 8'h55;

  reg [15:0]    bist_addr;
  reg [15:0]    top_addr;
  reg [15:0]    bottom_addr;
  reg [7:0]     read_pattern;
  reg           error;
  reg           bist_done;

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

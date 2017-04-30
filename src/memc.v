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

  reg [9:0]     state;
  reg [9:0]     next;

  // --- Signal declarations
  localparam [7:0] WR_PATT_1 = 8'b01010101;
  localparam [7:0] WR_PATT_2 = 8'b10101010;

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
    end
  end

  always @(*) begin

    next = 10'b0;

    case (1'b1)

      state[RESET]: begin
        next <= BIST;
      end

      state[BIST]: begin
        if (bist_done == 1'b0) begin
          next <= TEST_WR1;
        end else begin
          next <= IDLE;
        end
      end

      state[TEST_WR1]: begin
        next <= TEST_RD1;
      end

      state[TEST_RD1]: begin
        if (read_pattern == WR_PATT_1) begin
          next <= TEST_WR2;
        end else begin
          next <= ERROR;
        end
      end

      state[TEST_WR2]: begin
        next <= TEST_RD2;
      end

      state[TEST_RD2]: begin
        if (read_pattern == WR_PATT_1) begin
          next <= BIST;
        end else begin
          next <= ERROR;
        end
      end

      state[ERROR]: begin
        next <= ERROR;
      end

      state[IDLE]: begin
        if  (read_en == 1'b1) begin
          next <= READ;
        end else if (write_en = 1'b1) begin
          next <= WRITE;
        end else begin
          next <= IDLE;
      end

      state[READ]: begin
        next <= IDLE;
      end

      state[WRITE]: begin
        next <= IDLE;
      end

      default: begin
      end

    endcase // case (1'b1)
  end

  // Instantiate a 64k x 8 BRAM

endmodule // memc

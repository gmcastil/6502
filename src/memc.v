module memc
  #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 16
    )
  (
   input memc_clk,
   input memc_reset,
   input memc_read_enable,
   input memc_write_enable,
   input [DATA_WIDTH-1:0] memc_read_data,
   input [DATA_WIDTH-1:0] memc_write_data,
   input [ADDR_WIDTH-1:0] memc_addr,

   output memc_busy,
   output bram_clk,
   output bram_reset,
   output bram_read_enable,
   output bran_write_enable,
   output [DATA_WIDTH-1:0] bram_read_data,
   output [DATA_WIDTH-1:0] bram_write_data,
   output [ADDR_WIDTH-1:0] bram_addr
   );

`ifdef SIM
  // define some signals in here for simulation
`endif

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
      state        <= 10'b0;
      state[RESET] <= 1'b1;
    end else begin
      state <= next;
    end
  end

  always @(*) begin

    next = 10'b0;

    case (1'b1)

      state[RESET]: begin
        if (reset = 1'b0) begin:
          next <= RESET;
        end else begin
          next <= BIST;
        end
      end

      state[BIST]: begin
        if (reset = 1'b0) begin:
          next <= RESET;
        end else begin
          if (bist_done == 1'b0) begin
            next <= TEST_WR1;
          end else begin
             next <= IDLE;
          end
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
        if (read_pattern == WR_PATT_2) begin
          next <= BIST;
        end else begin
          next <= ERROR;
        end
      end

      state[ERROR]: begin
        if (reset = 1'b0) begin
          next <= RESET;
        end else begin
          next <= ERROR;
        end
      end

      state[IDLE]: begin
        if  (memc_read_enable == 1'b1) begin
          next <= READ;
        end else if (memc_write_enable = 1'b1) begin
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

  always @(posedge clk) begin

    case (1'b1)

      state[RESET_ID]: begin
        bram_read_enable = 1'b0;
        bram_write_enable = 1'b0;
        memc_busy = 1'b1;
      end

      state[BIST_ID]: begin
        bram_read_enable = 1'b0;
        bram_write_enable = 1'b0;
        memc_busy = 1'b1;
      end

      state[TEST_WR1_ID]: begin
        bram_read_enable = 1'b0;
        bram_write_enable = 1'b1;
        memc_busy = 1'b1;
      end

      state[TEST_RD1_ID]: begin
        bram_read_enable = 1'b1;
        bram_write_enable = 1'b0;
        memc_busy = 1'b1;
      end

      state[TEST_WR2_ID]: begin
        bram_read_enable = 1'b0;
        bram_write_enable = 1'b1;
        memc_busy = 1'b1;
      end

      state[TEST_RD2_ID]: begin
        bram_read_enable = 1'b1;
        bram_write_enable = 1'b0;
        memc_busy = 1'b1;
      end

      state[ERROR_ID]: begin
        bram_read_enable = 1'b0;
        bram_write_enable = 1'b0;
        memc_busy = 1'b1;
      end

      state[IDLE_ID]: begin
        bram_read_enable = 1'b0;
        bram_write_enable = 1'b0;
        memc_busy = 1'b0;
      end

      state[READ_ID]: begin
        bram_read_enable = memc_read_enable;
        bram_write_enable = memc_write_enable;
        addr = memc_addr;
        memc_busy = 1'b0;
      end

      state[WRITE_ID]: begin
        bram_read_enable = memc_read_enable;
        bram_write_enable = memc_write_enable;
        addr = memc_addr;
        memc_busy = 1'b0;
      end

      default: begin
      end

  end

  // localparam RESET      = 0;
  // localparam BIST       = 1;
  // localparam TEST_WR1   = 2;
  // localparam TEST_RD1   = 3;
  // localparam TEST_WR2   = 4;
  // localparam TEST_RD2   = 5;
  // localparam ERROR      = 6;
  // localparam IDLE       = 7;
  // localparam READ       = 8;
  // localparam WRITE      = 9;


  // Instantiate a 64k x 8 BRAM

endmodule // memc

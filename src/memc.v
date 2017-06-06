module memc
  #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 16
    )
  (
   input                       memc_clk,
   input                       memc_reset,
   output reg                  memc_busy,

   input                       memc_rd_enable,
   input                       memc_wr_enable,
   output reg [DATA_WIDTH-1:0] memc_rd_data,
   input [DATA_WIDTH-1:0]      memc_wr_data,
   input [ADDR_WIDTH-1:0]      memc_addr,

   output reg                  bram_rd_enable,
   output reg                  bram_wr_enable,
   input [DATA_WIDTH-1:0]      bram_rd_data,
   output reg [DATA_WIDTH-1:0] bram_wr_data,
   output reg [ADDR_WIDTH-1:0] bram_addr

   );

`ifdef SIM
  // define some signals in here for simulation
`endif

  // --- State machine signals
  localparam RESET      = 1;
  localparam BIST       = 2;
  localparam TEST_WR1   = 3;
  localparam TEST_RD1   = 4;
  localparam TEST_DEC1  = 5;
  localparam TEST_WR2   = 6;
  localparam TEST_RD2   = 7;
  localparam TEST_DEC2  = 8;
  localparam ERROR      = 9;
  localparam IDLE       = 10;
  localparam READ       = 11;
  localparam READ_DEC   = 12;
  localparam WRITE      = 13;
  localparam WRITE_DEC  = 14;

  reg [13:0]     state;
  reg [13:0]     next;

  // --- Signal declarations
  localparam [7:0] WR_PATT_1 = 8'b01010101;
  localparam [7:0] WR_PATT_2 = 8'b10101010;

  localparam TOP_ADDR = {ADDR_WIDTH-1{1'b1}};
  localparam BOTTOM_ADDR = {ADDR_WIDTH-1{1'b0}};

  reg [ADDR_WIDTH:0]      bist_addr;
  reg [DATA_WIDTH-1:0]    read_pattern;
  reg [DATA_WIDTH-1:0]    bist_rd_data;
  reg                     error;
  reg                     bist_done;

  always @(posedge memc_clk) begin
    if (!memc_reset) begin
      state <= 13'b0;
      state[RESET] <= 1'b1;
    end else begin
      state <= next;
    end
  end

  // -- Combinatorial State Machine Movements
  always @(*) begin

    next = 13'b0;

    case (1'b1)

      state[RESET]: begin
        if (memc_reset == 1'b0) begin
          next[RESET] = 1'b1;
        end else begin
          next[BIST] = 1'b1;
        end
      end

      state[BIST]: begin
        if (memc_reset == 1'b0) begin
          next[RESET] = 1'b1;
        end else begin
          if (bist_done == 1'b1) begin
            next[IDLE] = 1'b1;
          end else begin
             next[TEST_WR1] = 1'b1;
          end
        end
      end

      state[TEST_WR1]: begin
        next[TEST_RD1] = 1'b1;
      end

      state[TEST_RD1]: begin
        next[TEST_DEC1] = 1'b1;
      end

      state[TEST_DEC1]: begin
        if (bram_rd_data == WR_PATT_1) begin
          next[TEST_WR2] = 1'b1;
      end else begin
          next[ERROR] = 1'b1;
        end
      end

      state[TEST_WR2]: begin
        next[TEST_RD2] = 1'b1;
      end

      state[TEST_RD2]: begin
        next[TEST_DEC2] = 1'b1;
      end

      state[TEST_DEC2]: begin
        if (bram_rd_data == WR_PATT_2) begin
        next[BIST] = 1'b1;
      end else begin
        next[ERROR] = 1'b1;
        end
      end

      state[ERROR]: begin
        if (!memc_reset) begin
          next[RESET] = 1'b1;
        end else begin
          next[ERROR] = 1'b1;
        end
      end

      state[IDLE]: begin
        if  (memc_rd_enable == 1'b1) begin
          next = READ;
        end else if (memc_wr_enable == 1'b1) begin
          next = WRITE;
        end else begin
          next = IDLE;
        end
      end

      state[READ]: begin
        next = IDLE;
      end

      state[WRITE]: begin
        next = IDLE;
      end

      default: begin
      end

    endcase // case (1'b1)
  end

  always @(posedge memc_clk) begin

    case (1'b1)

      state[RESET]: begin
        bram_rd_enable <= 1'b0;
        bram_wr_enable <= 1'b0;
        bram_addr <= {ADDR_WIDTH{1'b0}};
        memc_busy <= 1'b1;
        bist_addr <= {ADDR_WIDTH{1'b0}};
      end

      state[BIST]: begin
        bram_rd_enable <= 1'b0;
        bram_wr_enable <= 1'b0;
        bram_addr <= {ADDR_WIDTH{1'b0}};
        memc_busy <= 1'b1;
        bist_addr <= bist_addr;
      end

      state[TEST_WR1]: begin
        bram_rd_enable <= 1'b0;
        bram_wr_enable <= 1'b1;
        bram_addr <= bist_addr;
        bram_wr_data <= WR_PATT_1;
        memc_busy <= 1'b1;
      end

      state[TEST_RD1]: begin
        bram_rd_enable <= 1'b1;
        bram_wr_enable <= 1'b0;
        bist_addr <= bist_addr;
        memc_busy <= 1'b1;
      end

      state[TEST_DEC1]: begin
        bram_rd_enable <= 1'b0;
        bram_wr_enable <= 1'b0;
        memc_busy <= 1'b1;
      end

      state[TEST_WR2]: begin
        bram_rd_enable <= 1'b0;
        bram_wr_enable <= 1'b1;
        memc_busy <= 1'b1;
        bist_addr <= bist_addr;
      end

      state[TEST_RD2]: begin
        bram_rd_enable <= 1'b1;
        bram_wr_enable <= 1'b0;
        bram_addr <= bist_addr;
        memc_busy <= 1'b1;
        bist_addr <= bist_addr + 1'b1;
      end

      state[TEST_DEC2]: begin
        bram_rd_enable <= 1'b0;
        bram_wr_enable <= 1'b0;
        bram_addr <= bist_addr;
        memc_busy <= 1'b1;
      end

      state[ERROR]: begin
        bram_rd_enable <= 1'b0;
        bram_wr_enable <= 1'b0;
        memc_busy <= 1'b1;
        bist_addr <= bist_addr;
      end

      state[IDLE]: begin
        bram_rd_enable <= 1'b0;
        bram_wr_enable <= 1'b0;
        bram_addr <= memc_addr;
        memc_busy <= 1'b0;
        bist_addr <= bist_addr;
      end

      state[READ]: begin
        bram_rd_enable <= memc_rd_enable;
        bram_wr_enable <= memc_wr_enable;
        bram_addr <= memc_addr;
        memc_busy <= 1'b0;
        bist_addr <= bist_addr;
      end

      state[READ_DEC]: begin
      end

      state[WRITE]: begin
        bram_rd_enable <= memc_rd_enable;
        bram_wr_enable <= memc_wr_enable;
        bram_addr <= memc_addr;
        memc_busy <= 1'b0;
        bist_addr <= bist_addr;
      end

      state[WRITE_DEC]: begin
      end

      default: begin
      end

    endcase // case (1'b1)
  end // always @ (posedge clk)

endmodule // memc

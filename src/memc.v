module memc
  #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 16
    )
  (
   input                   memc_clk,
   input                   memc_reset,
   output                  memc_busy,

   input                   memc_rd_enable,
   input                   memc_wr_enable,
   output [DATA_WIDTH-1:0] memc_rd_data,
   input [DATA_WIDTH-1:0]  memc_wr_data,
   input [ADDR_WIDTH-1:0]  memc_addr,

   output                  bram_rd_enable,
   output                  bram_wr_enable,
   input [DATA_WIDTH-1:0]  bram_rd_data,
   output [DATA_WIDTH-1:0] bram_wr_data,
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
  localparam TEST_DEC1  = 4;
  localparam TEST_WR2   = 5;
  localparam TEST_RD2   = 5;
  localparam TEST_DEC2  = 7;
  localparam ERROR      = 8;
  localparam IDLE       = 9;
  localparam READ       = 10;
  localparam READ_DEC   = 11;
  localparam WRITE      = 12;
  localparam WRITE_DEC  = 13;

  reg [9:0]     state;
  reg [9:0]     next;

  // --- Signal declarations
  localparam [7:0] WR_PATT_1 = 8'b01010101;
  localparam [7:0] WR_PATT_2 = 8'b10101010;

  reg [16:0]    bist_addr;
  reg [15:0]    top_addr;
  reg [15:0]    bottom_addr;
  reg [7:0]     read_pattern;
  reg           errors;
  reg           bist_done;

  // Some signals are always passed through to the BRAM while others
  // are only passed through once the BIST is completed
  assign bram_clk = memc_clk;
  assign bram_reset = memc_reset

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
<<<<<<< HEAD
        next = BIST;
      end

      state[BIST]: begin
        if (bist_done == 1'b0) begin
          next = TEST_WR1;
        end else begin
          next = IDLE;
=======
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
>>>>>>> 3eac316fb875b30486707e80354fd217635fd5a3
        end
      end

      state[TEST_WR1]: begin
        next = TEST_RD1;
      end

      state[TEST_RD1]: begin
<<<<<<< HEAD
        if (read_pattern == WR_PATT_1) begin
          next = TEST_WR2;
=======
        if (bram_rd_data == WR_PATT_1) begin
          next <= TEST_WR2;
>>>>>>> 3eac316fb875b30486707e80354fd217635fd5a3
        end else begin
          next = ERROR;
        end
      end

      state[TEST_DEC1]: begin
      end

      state[TEST_WR2]: begin
        next = TEST_RD2;
      end

      state[TEST_RD2]: begin
<<<<<<< HEAD
        if (read_pattern == WR_PATT_1) begin
          next = BIST;
=======
        if (bram_rd_data == WR_PATT_2) begin
          next <= BIST;
>>>>>>> 3eac316fb875b30486707e80354fd217635fd5a3
        end else begin
          next = ERROR;
        end
      end

      state[TEST_DEC2]: begin
      end

      state[ERROR]: begin
<<<<<<< HEAD
        next = ERROR;
      end

      state[IDLE]: begin
        if  (read_en == 1'b1) begin
          next = READ;
        end else if (write_en == 1'b1) begin
          next = WRITE;
=======
        if (reset = 1'b0) begin
          next <= RESET;
        end else begin
          next <= ERROR;
        end
      end

      state[IDLE]: begin
        if  (memc_rd_enable == 1'b1) begin
          next <= READ;
        end else if (memc_wr_enable = 1'b1) begin
          next <= WRITE;
>>>>>>> 3eac316fb875b30486707e80354fd217635fd5a3
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

  always @(posedge clk) begin

    case (1'b1)

      state[RESET]: begin
<<<<<<< HEAD
        write_en <= 1'b0;
        read_en <= 1'b0;
        busy <= 1'b1;
      end

      state[BIST]: begin
        write_en <= 1'b0;
        read_en <= 1'b0;
        busy <= 1'b1;
      end

      state[TEST_WR1]: begin
        write_en <= 1'b1;
        read_en <= 1'b0;
        busy <= 1'b1;
        addr <= bist_addr

  end

  // Instantiate a 64k x 8 BRAM
=======
        bram_rd_enable = 1'b0;
        bram_wr_enable = 1'b0;
        bram_addr = {ADDR_WIDTH{1'b0}};
        memc_busy = 1'b1;
        bist_addr = {ADDR_WIDTH{1'b0}}
      end

      state[BIST]: begin
        bram_rd_enable = 1'b0;
        bram_wr_enable = 1'b0;
        bram_addr = {ADDR_WIDTH{1'b0}};
        memc_busy = 1'b1;
        bist_addr = bist_addr;
      end

      state[TEST_WR1]: begin
        bram_rd_enable = 1'b0;
        bram_wr_enable = 1'b1;
        bram_addr = bist_addr;
        memc_busy = 1'b1;
        bist_addr = bist_addr;
      end

      state[TEST_RD1]: begin
        bram_rd_enable = 1'b1;
        bram_wr_enable = 1'b0;
        bram_addr = bist_addr
        memc_busy = 1'b1;
        bist_addr = bist_addr;
      end

      state[TEST_DEC1]: begin
      end

      state[TEST_WR2]: begin
        bram_rd_enable = 1'b0;
        bram_wr_enable = 1'b1;
        bram_addr = bist_addr;
        memc_busy = 1'b1;
        bist_addr = bist_addr;
      end

      state[TEST_RD2]: begin
        bram_rd_enable = 1'b1;
        bram_wr_enable = 1'b0;
        bram_addr = bist_addr;
        memc_busy = 1'b1;
        bist_addr = bist_addr + 1'b1;
      end

      state[TEST_DEC2]: begin
      end

      state[ERROR]: begin
        bram_rd_enable = 1'b0;
        bram_wr_enable = 1'b0;
        bram_addr = bist_addr;
        memc_busy = 1'b1;
        bist_addr = bist_addr;
      end

      state[IDLE]: begin
        bram_rd_enable = 1'b0;
        bram_wr_enable = 1'b0;
        bram_addr = memc_addr;
        memc_busy = 1'b0;
        bist_addr = bist_addr
      end

      state[READ]: begin
        bram_rd_enable = memc_rd_enable;
        bram_wr_enable = memc_wr_enable;
        bram_addr = memc_addr;
        memc_busy = 1'b0;
        bist_addr = bist_addr;
      end

      state[READ_DEC]: begin
      end

      state[WRITE]: begin
        bram_rd_enable = memc_rd_enable;
        bram_wr_enable = memc_wr_enable;
        bram_addr = memc_addr;
        memc_busy = 1'b0;
        bist_addr = bist_addr;
      end

      state[WRITE_DEC]: begin
      end

      default: begin
      end

  end
>>>>>>> 3eac316fb875b30486707e80354fd217635fd5a3

endmodule // memc

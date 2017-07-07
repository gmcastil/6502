module memc
  #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 12
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
  localparam RESET      = 0;  // 1
  localparam BIST       = 1;  // 2
  localparam TEST_WR1   = 2;  // 4
  localparam TEST_RD1   = 3;  // 8
  localparam TEST_DEC1  = 4;  // 16
  localparam TEST_WR2   = 5;  // 32
  localparam TEST_RD2   = 6;  // 64
  localparam TEST_DEC2  = 7;  // 128
  localparam ERROR      = 8;  // 256
  localparam IDLE       = 9;  // 512
  localparam READ       = 10; // 1024
  localparam WRITE      = 11; // 2048

  reg [11:0]     state;
  reg [11:0]     next;

     // synthesis translate_off
           reg [(8*12)-1:0] state_ascii;
           always @(*) begin
            
             case (state)
               12'b000000000001: state_ascii <= "    RESET";
               12'b000000000010: state_ascii <= "     BIST";
               12'b000000000100: state_ascii <= " TEST_WR1";
               12'b000000001000: state_ascii <= " TEST_RD1";
               12'b000000010000: state_ascii <= "TEST_DEC1";
               12'b000000100000: state_ascii <= " TEST_WR2";
               12'b000001000000: state_ascii <= " TEST_RD2";
               12'b000010000000: state_ascii <= "TEST_DEC2";
               12'b000100000000: state_ascii <= "    ERROR";
               12'b001000000000: state_ascii <= "     IDLE";
               12'b010000000000: state_ascii <= "     READ";
               12'b100000000000: state_ascii <= "    WRITE";
             endcase // case (state)
           end
           
           reg [(8*12)-1:0] next_ascii;
           always @(*) begin
            
             case (next)
             12'b000000000001: next_ascii <= "    RESET";
             12'b000000000010: next_ascii <= "     BIST";
             12'b000000000100: next_ascii <= " TEST_WR1";
             12'b000000001000: next_ascii <= " TEST_RD1";
             12'b000000010000: next_ascii <= "TEST_DEC1";
             12'b000000100000: next_ascii <= " TEST_WR2";
             12'b000001000000: next_ascii <= " TEST_RD2";
             12'b000010000000: next_ascii <= "TEST_DEC2";
             12'b000100000000: next_ascii <= "    ERROR";
             12'b001000000000: next_ascii <= "     IDLE";
             12'b010000000000: next_ascii <= "     READ";
             12'b100000000000: next_ascii <= "    WRITE";
             endcase
           end
        // synthesis translate_on

  // --- Signal declarations
  localparam [7:0] WR_PATT_1 = 8'b01010101;
  localparam [7:0] WR_PATT_2 = 8'b10101010;

  localparam TOP_ADDR = {ADDR_WIDTH{1'b1}};

  reg                     bist_done;

  always @(posedge memc_clk) begin
    if (!memc_reset) begin
      state <= 12'b0;
      state[RESET] <= 1'b1;
    end else begin
      state <= next;
    end
  end

  // -- Combinatorial State Machine Movements
  always @(*) begin

    next <= 12'b0;

    case (1'b1)

      state[RESET]: begin
        if (memc_reset == 1'b0) begin
          next[RESET] <= 1'b1;
        end else begin
          next[BIST] <= 1'b1;
        end
      end

      state[BIST]: begin
        if (memc_reset == 1'b0) begin
          next[RESET] <= 1'b1;
        end else begin
          if (bist_done == 1'b1) begin
            next[IDLE] <= 1'b1;
          end else begin
             next[TEST_WR1] <= 1'b1;
          end
        end
      end

      state[TEST_WR1]: begin
        next[TEST_RD1] <= 1'b1;
      end

      state[TEST_RD1]: begin
        next[TEST_DEC1] <= 1'b1;
      end

      state[TEST_DEC1]: begin
        if (bram_rd_data == WR_PATT_1) begin
          next[TEST_WR2] <= 1'b1;
      end else begin
          next[ERROR] <= 1'b1;
        end
      end

      state[TEST_WR2]: begin
        next[TEST_RD2] <= 1'b1;
      end

      state[TEST_RD2]: begin
        next[TEST_DEC2] <= 1'b1;
      end

      state[TEST_DEC2]: begin
        if (bram_rd_data == WR_PATT_2) begin
          next[BIST] <= 1'b1;
        end else begin
          next[ERROR] <= 1'b1;
        end
      end

      state[ERROR]: begin
        if (!memc_reset) begin
          next[RESET] <= 1'b1;
        end else begin
          next[ERROR] <= 1'b1;
        end
      end

      state[IDLE]: begin
        if  (memc_rd_enable == 1'b1) begin
          next[READ] <= 1'b1;
        end else if (memc_wr_enable == 1'b1) begin
          next[WRITE] <= 1'b1;
        end else begin
          next[IDLE] <= 1'b1;
        end
      end

      state[READ]: begin
        if (memc_wr_enable == 1'b1) begin
          next[WRITE] <= 1'b1;
        end else begin
          next[IDLE] <= 1'b1;
        end
      end

      state[WRITE]: begin
        if (memc_rd_enable == 1'b1) begin
          next[READ] <= 1'b1;
        end else begin
          next[IDLE] <= 1'b1;
        end
      end

      default: begin
      end

    endcase // case (1'b1)
  end

  always @(posedge memc_clk) begin

    case (1'b1)

      next[RESET]: begin
        bram_rd_enable <= 1'b0;
        bram_wr_enable <= 1'b0;
        bram_addr <= {ADDR_WIDTH{1'b0}};
        memc_busy <= 1'b1;
        bist_done <= 1'b0;
      end

      next[BIST]: begin
        bram_rd_enable <= 1'b0;
        bram_wr_enable <= 1'b0;
        memc_busy <= 1'b1;
      end

      next[TEST_WR1]: begin
        bram_rd_enable <= 1'b1;
        bram_wr_enable <= 1'b1;
        bram_wr_data <= WR_PATT_1;
        memc_busy <= 1'b1;
      end

      next[TEST_RD1]: begin
        bram_rd_enable <= 1'b1;
        bram_wr_enable <= 1'b0;
        memc_busy <= 1'b1;
      end

      next[TEST_DEC1]: begin
        bram_rd_enable <= 1'b0;
        bram_wr_enable <= 1'b0;
        memc_busy <= 1'b1;
      end

      next[TEST_WR2]: begin
        bram_rd_enable <= 1'b1;
        bram_wr_enable <= 1'b1;
        bram_wr_data <= WR_PATT_2;
        memc_busy <= 1'b1;
      end

      next[TEST_RD2]: begin
        bram_rd_enable <= 1'b1;
        bram_wr_enable <= 1'b0;
        memc_busy <= 1'b1;
      end

      next[TEST_DEC2]: begin
        bram_rd_enable <= 1'b0;
        bram_wr_enable <= 1'b0;
        memc_busy <= 1'b1;
        if (bram_addr == TOP_ADDR) begin
          bist_done <= 1'b1;
        end else begin
          bist_done <= 1'b0;
        end
        bram_addr <= bram_addr + 1'b1;
      end

      next[ERROR]: begin
        bram_rd_enable <= 1'b0;
        bram_wr_enable <= 1'b0;
        memc_busy <= 1'b1;
      end

      next[IDLE]: begin
        bram_rd_enable <= 1'b0;
        bram_wr_enable <= 1'b0;
        bram_addr <= memc_addr;
        memc_busy <= 1'b0;
      end

      next[READ]: begin
        bram_rd_enable <= 1'b1;
        bram_wr_enable <= 1'b0;
        memc_rd_data <= bram_rd_data;
        bram_addr <= memc_addr;
        memc_busy <= 1'b0;
      end

      next[WRITE]: begin
        bram_rd_enable <= 1'b1;
        bram_wr_enable <= 1'b1;
        bram_wr_data <= memc_wr_data;
        bram_addr <= memc_addr;
        memc_busy <= 1'b0;
      end

      default: begin
      end

    endcase // case (1'b1)
  end // always @ (posedge clk)

endmodule // memc

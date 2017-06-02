module memory_top
  #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 16
    )
  (
   input                   clk,
   input                   reset,
   input                   rd_enable,
   input                   wr_enable,
   input [DATA_WIDTH-1:0]  wr_data,
   input [ADDR_WIDTH-1:0]  addr,

   output                  busy,
   output [DATA_WIDTH-1:0] rd_data
   );

  // -- Internal connections between the memory controller and the RAM
  wire                     int_rd_enable;
  wire                     int_wr_enable;
  wire [DATA_WIDTH-1:0]    int_rd_data;
  wire [DATA_WIDTH-1:0]    int_wr_data;
  wire [ADDR_WIDTH-1:0]    int_addr;

  // -- Memory controller
  memc #(
         .DATA_WIDTH (8),
         .ADDR_WIDTH (16)
         ) u_memc (
                   .memc_clk (clk),
                   .memc_reset (reset),
                   .memc_busy (busy),

                   .memc_rd_enable (rd_enable),
                   .memc_wr_enable (wr_enable),
                   .memc_rd_data (rd_data),
                   .memc_wr_data (wr_data),
                   .memc_addr (addr),

                   .bram_rd_enable (int_rd_enable),
                   .bram_wr_enable (int_wr_enable),
                   .bram_rd_data (int_rd_data),
                   .bram_wr_data (int_wr_data),
                   .bram_addr (int_addr)
                   );

  // -- Memory wrapper
  memory_block #(
                 ) u_memory_block (
                                   .clk (clk),
                                   .reset (reset),
                                   .rd_enable (int_rd_enable),
                                   .wr_enable (int_wr_enable),
                                   .rd_data (int_wr_data),
                                   .wr_data (int_rd_data),
                                   .addr (int_addr)
                                   );
endmodule // memory_top

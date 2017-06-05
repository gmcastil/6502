module memory_block
  #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 16
    )
  (
   input clk,
   input reset,
   input rd_enable,
   input wr_enable,
   output [DATA_WIDTH-1:0] rd_data,
   input [DATA_WIDTH-1:0] wr_data,
   input [ADDR_WIDTH-1:0] addr
   );

  // For now, this will just instantiate the Xilinx primitives

  wire                    resetn;
  assign resetn = !reset;

  BRAM_SINGLE_MACRO
    #(
      .BRAM_SIZE("36Kb"),
      .DEVICE("7SERIES"),
      .DO_REG(),  // Figure this one out
      .INIT({DATA_WIDTH{1'b0}}),  // This should match the read / write width
      .INIT_FILE("NONE"),
      .WRITE_WIDTH(DATA_WIDTH),
      .READ_WIDTH(DATA_WIDTH),
      .SRVAL({DATA_WIDTH{1'b0}}),  // This should also match the read / write width
      .WRITE_MODE("WRITE_FIRST")
      ) BRAM_SINGLE_MACRO_inst (
                                .DO(rd_data),
                                .ADDR(addr),   /* For a 36Kb BRAM primitive and
                                                an 8-bit read width, this should
                                                be 12-bits  */
                                .CLK(clk),
                                .DI(),
                                .EN(),  // not sure
                                .REGCE(),  // also not sure
                                .RST(resetn),  // not sure
                                .WE(wr_enable)  // not sure
                                );

endmodule // mem_block

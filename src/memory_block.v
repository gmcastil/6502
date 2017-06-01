module mem_block
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

  // For now, this will just instantiate the Xilinx primitive

   BRAM_SINGLE_MACRO
     #(
       .BRAM_SIZE("36Kb"),
       .DEVICE("7SERIES"),
       .DO_REG(0),
       .INIT({DATA_WIDTH{1'b0}}),
       .INIT_FILE("NONE"),
       .WRITE_WIDTH(DATA_WIDTH),
       .READ_WIDTH(DATA_WIDTH),
       .SRVAL({DATA_WIDTH{1'b0}}),
       .WRITE_MODE("WRITE_FIRST")
              ) BRAM_SINGLE_MACRO_inst (
                                        .DO(rd_data),
                                        .ADDR(addr),
                                        .CLK(clk),
                                        .DI(wr_data),
                                        .DO(rd_data),
                                        .REGCE(rd_enable),
                                        .RST(reset),
                                        .WE(wr_enable)
                                        );

endmodule // mem_block

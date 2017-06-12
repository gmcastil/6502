module memory_block
  #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 12
    )
  (
   input clk,
   input reset,
   input rd_enable,
   input [3:0] wr_enable,
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
      .DO_REG(0),
      .INIT({DATA_WIDTH{1'b0}}),
      .INIT_FILE("NONE"),
      .WRITE_WIDTH(DATA_WIDTH),
      .READ_WIDTH(DATA_WIDTH),
      .SRVAL({DATA_WIDTH{1'b0}}),
      .WRITE_MODE("NO_CHANGE")
      ) BRAM_SINGLE_MACRO_inst (
                                .DO(rd_data),
                                .DI(wr_data),
                                .ADDR(addr),
                                .WE(wr_enable),
                                .EN(1'b1),
                                .RST(reset),
                                .REGCE(1'b1),
                                .CLK(clk)
                                );

endmodule // mem_block

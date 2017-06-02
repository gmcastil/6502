`timescale 1ns/10ps

module memory_top_tb
  #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 16
    )
  ();

  reg                   clk;
  reg                   reset;
  reg                   rd_enable;
  reg                   wr_enable;
  reg [DATA_WIDTH-1:0]  wr_data;
  reg [ADDR_WIDTH-1:0]  addr;
  reg                   busy;
  reg [DATA_WIDTH-1:0]  rd_data;

  localparam T=10;  // 10ns clock period

  initial begin
    clk <= 1'b1;
    forever begin
      #(T/2)
      clk = ~clk;
    end
  end

  initial begin
    // Wait 10 cycles before asserting the active low reset
    reset = 1'b1;
    #(10*T);
    reset = 1'b0;
    #(3*T);
    reset = 1'b1;

    // Should wait until the busy signal has gone to zero
  end

  memory_top #(
               ) u_memory_top (
                               .clk (clk),
                               .reset (reset),
                               .rd_enable (rd_enable),
                               .wr_enable (wr_enable),
                               .addr (addr),
                               .busy (busy),
                               .rd_data (rd_data)
                               );

endmodule // memory_top_tb

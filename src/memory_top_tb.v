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

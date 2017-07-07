`timescale 1ns/10ps

module memory_top_tb
  #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 12
    )
  ();

  reg                   clk;
  reg                   reset;
  reg                   rd_enable;
  reg                   wr_enable;
  reg [DATA_WIDTH-1:0]  wr_data;
  reg [ADDR_WIDTH-1:0]  addr;
  wire                  busy;
  wire [DATA_WIDTH-1:0] rd_data;

  localparam T=20;  // 10ns clock period

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
    
    rd_enable = 1'b0;
    wr_enable = 1'b0;
    addr = {ADDR_WIDTH{1'b0}};
    wr_data = {DATA_WIDTH{1'b0}};

    wait (busy == 1'b0) begin
      #(10*T);
      $display("BIST completed...");
      wr_enable = 1'b1;
      rd_enable = 1'b0;
      wr_data = {DATA_WIDTH{1'b1}};
      addr = {ADDR_WIDTH{1'b0}};
      #(T);
      wr_enable = 1'b0;
      rd_enable = 1'b1;
      #(T);
      rd_enable = 1'b0;
      wr_enable = 1'b0;
      if (rd_data == wr_data) begin
        $display("External operation correct...");
      end else begin
        $display("Error writing to memory...");
      end

    end
  end

  memory_top #(
               .DATA_WIDTH (DATA_WIDTH),
               .ADDR_WIDTH (ADDR_WIDTH)
               ) u_memory_top (
                               .clk (clk),
                               .reset (reset),
                               .rd_enable (rd_enable),
                               .wr_enable (wr_enable),
                               .addr (addr),
                               .busy (busy),
                               .rd_data (rd_data),
                               .wr_data (wr_data)
                               );

endmodule // memory_top_tb

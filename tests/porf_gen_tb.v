`timescale 1ns / 1ps

module porf_gen_tb();

   reg  clk_100m;
   reg  async_reset;
   reg  clk_enable;
   wire sync_reset;

   initial begin
      clk_100m <= 1'b1;
      forever begin
         #5 clk_100m <= ~clk_100m;
      end
   end

   porf_gen #(
              ) u_porf_gen (
                            .async_reset(async_reset),
                            .clk(clk_100m),
                            .clk_enable(clk_enable),
                            .sync_reset(sync_reset));

   initial begin
      // Let simulator get everything going
      #10;

      // Asynchronous reset should come out synchronous
      clk_enable = 1'b1;
      async_reset = 1'b0;
      #23;
      async_reset = 1'b1;
      #54;
      async_reset = 1'b0;
      #53;

      // Asynchronous reset should not appear
      clk_enable = 1'b0;
      async_reset = 1'b0;
      #23;
      async_reset = 1'b1;
      #54;
      async_reset = 1'b0;
      #53;
   end

endmodule

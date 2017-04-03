`timescale 1ns / 1ps

module porf_gen_tb();

  reg  clk_100m;
  reg  reset_in;
  wire reset_out;

  initial begin
    clk_100m <= 1'b1;
      forever begin
        #5 clk_100m <= ~clk_100m;
      end
    end  


  porf_gen #(
    ) u_porf_gen (
                  .reset_in(reset_in),
                  .clk(clk_100m),
                  .reset_out(reset_out));

  initial begin
    #100
    reset_in = 1'b0;
    #23;
    reset_in = 1'b1;
    #54;
    reset_in = 1'b0;
    #53;
  end

endmodule

// ----------------------------------------------------------------------------
// Module:  memory_tb.sv
// Project: MOS 6502 Processor
// Author:  George Castillo <gmcastil@gmail.com>
// Date:    23 April 2018
//
// Description:
// ----------------------------------------------------------------------------
`timescale 1ns / 1ps

module memory_tb ();

  parameter DEPTH = 2 ** 16;
  parameter WIDTH = 8;
  parameter ASYNC_DELAY = 10;
  parameter DATA_FILE = "data.mif";

  logic clk;
  logic resetn;
  logic enable;
  logic [$clog2(DEPTH)-1:0] address;
  logic [WIDTH-1:0] wr_data;
  logic [WIDTH-1:0] rd_data;

  initial begin
    clk = 1'b1;
    forever begin
      clk = ~clk;
    end
  end

  initial begin
    #100ns;
    $finish();
  end


  memory #(

        .DEPTH (DEPTH),
        .WIDTH (WIDTH),
        .ASYNC_DELAY (ASYNC_DELAY),
        .DATA_FILE (DATA_FILE)

        ) memory_inst (

                    .clk (clk),
                    .resetn (resetn),
                    .enable (enable),
                    .address (address),
                    .wr_data (wr_data),
                    .rd_data (rd_data)

                    );

endmodule // ram_tb

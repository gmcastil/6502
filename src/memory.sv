// ----------------------------------------------------------------------------
// Module:  ram.sv
// Project: MOS 6502 Processor
// Author:  George Castillo <gmcastil@gmail.com>
// Date:    23 April 2018
//
// Description: Behavioral model for a 64kB asynchronous memory. The module
// reads a text file into a large array and then either reads or writes to the
// array in a clocked process with a programmable delay.
// ----------------------------------------------------------------------------
`timescale 1ns / 1ps

module ram
  #(
    parameter DEPTH = 2 ** 16,
    parameter WIDTH = 8,
    parameter ASYNC_DELAY = 10,
    parameter DATA_FILE = "data.mif"
    ) (
       input  clk,
       input  resetn,
       input  enable,
       input  [$clog2(DEPTH)-1:0] address,
       input  [WIDTH-1:0] wr_data,
       output [WIDTH-1:0] rd_data
       );

  int file;

  initial begin
    #100ns;
    $finish();
  end

  always @(posedge clk) begin
    #(ASYNC_DELAY);
  end
  // logic [WIDTH-1:0] memory [DEPTH-1:0];
  // initial begin
  //   file = $fopen(DATA_FILE, "r");
  //   if ( !file ) begin
  //     $display("Could not open %s for reading.", DATA_FILE);
  //   end else begin
  //     $display("Opening %s for reading.", DATA_FILE);
  //     $fclose(DATA_FILE);
  //   $finish();
  //   end
  // end

endmodule // ram

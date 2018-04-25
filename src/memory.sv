// ----------------------------------------------------------------------------
// Module:  memory.sv
// Project: MOS 6502 Processor
// Author:  George Castillo <gmcastil@gmail.com>
// Date:    23 April 2018
//
// Description: Behavioral model for a 64kB asynchronous memory. The module
// reads a text file into a large array and then either reads or writes to the
// array in a clocked process with a programmable delay.
// ----------------------------------------------------------------------------
`timescale 1ns / 1ps

module memory
  #(
    parameter DEPTH = 16,
    parameter WIDTH = 8,
    parameter ASYNC_DELAY = 1,
    parameter DATA_FILE = "data.mif"
    ) (
       input                  clk,
       input                  resetn,
       input                  enable,
       input [DEPTH-1:0]      address,
       input                  wr_enable,
       input [WIDTH-1:0]      wr_data,
       output reg [WIDTH-1:0] rd_data
       );

  logic [WIDTH-1:0] mem_array [0:(2**DEPTH)-1];
  initial $readmemb(DATA_FILE, mem_array);

  always @(posedge clk) begin
    #ASYNC_DELAY;
    if ( wr_enable && enable ) begin
      mem_array[address] <= wr_data;
    end else if ( enable ) begin
      rd_data <= mem_array[address];
    end
  end

endmodule // memory

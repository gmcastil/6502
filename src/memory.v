// ----------------------------------------------------------------------------
// Module:  memory.v
// Project: MOS 6502 Processor
// Author:  George Castillo <gmcastil@gmail.com>
// Date:    23 April 2018
//
// Description: Behavioral model for a 64kB asynchronous memory. The module
// reads a text file into a large array and then either reads or writes to the
// array in a clocked process with a programmable delay.  A reset immediately
// reloads the contents of the data file provided during compilation.
//
// This is not truly an asynchronous memory - if it were, it would respond to
// things other than just the rising edge of the clock.  For that matter, if
// it were truly asynchronous, it would not have a clock at all.  The purpose
// of this module is to model a memory which accepts an address on the rising
// edge of a clock and provides the data a configurable amount of time later,
// like an asynchronous RAM would.  This model was designed to be used with a
// simulated clock frequency of 100MHz.  Higher speeds could be done, but it
// would require modifying the timescale directive and some parameters.
//
// Read:
// - The `enable' net should be driven high and `wr_enable' driven low
// - An address is expected to be provided on the rising edge of `clk'
// - Some time after that clock edge, determined by ASYNC_DELAY, data will
//   arrive on the data lines and will be available by the next clock cycle
//
// Write:
// - The `enable' and `wr_enable' nets should both be driven high
// - An address is expected to be provided on the rising edge of `clk'
// - Data is expected to be provided on the rising edge of `clk'
// - Some time after that clock edge, determined by ASYNC_DELAY, the data
//   will be stored in memory
//
// A reset operation, which is active low, will reload the contents of the
// DATA_FILE into the memory array.
//
// If neither `enable' or `wr_enable' are driven high, the memory will drive
// the data lines to high impedance
// ----------------------------------------------------------------------------

`timescale 1ns / 1ps

module memory
  #(

    // Used to determine how deep to make the memory array. The number of
    // addresses provided is 2 raised to the power of DEPTH
    parameter DEPTH = 16,
    // Number of bits to store at each address
    parameter WIDTH = 8,
    // The amount of simulation time to wait after an address is clocked in on
    // the address line before providing the data at the data line (read) or
    // writing the data to the memory (write)
    parameter ASYNC_DELAY = 1,
    // File containing binary data (ASCII).  These are expected to be .mif files
    // from a Xilinx memory core generator or an output of the oddball
    // assembler
    parameter DATA_FILE = "data.mif"

    ) (
       input wire               clk,
       input wire               resetn,
       input wire               enable,
       input wire [(DEPTH-1):0] address,
       input wire               wr_enable,
       input wire [(WIDTH-1):0] wr_data,
       output reg [(WIDTH-1):0] rd_data
       );

  // High Z the memory if not reading or writing
  localparam DISABLED = 8'hzz;

  reg [(WIDTH-1):0]           mem_array [0:(2**DEPTH-1)];
  initial begin
    $readmemb(DATA_FILE, mem_array);
  end

  // -- Reset logic
  always @(posedge clk) begin
    if ( resetn == 1'b0 ) begin
      $readmemb(DATA_FILE, mem_array);
    end
  end

  // -- Memory model
  always @(posedge clk) begin
    #ASYNC_DELAY;
    if ( wr_enable && enable ) begin
      mem_array[address] <= wr_data;
    end else if ( enable ) begin
      rd_data <= mem_array[address];
    end else begin
      rd_data <= DISABLED;
    end
  end

endmodule // memory

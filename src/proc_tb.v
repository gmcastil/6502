// ----------------------------------------------------------------------------
// Module:  proc_tb.v
// Project: MOS 6502 Processor
// Author:  George Castillo <gmcastil@gmail.com>
// Date:    09 July 2017
//
// Description: Testbench for the MOS 6502 processor core.  Currently requires a
// 64KB memory block to be generated (scripts to do this are in the project's
// scripts directory) with desired machine instructions manually placed within
// the memory array.  The processor simulation scripts can then be used to
// verify functionality as it is implemented.
// ----------------------------------------------------------------------------

`timescale 1ns / 1ps

module proc_top_tb ();

  localparam T = 10;
  localparam P = 100;

  reg          clk_sys;       // Memory will be clocked 10X relative to processor
  reg          clk;
  reg          resetn;
  reg          enable;
  reg          wr_enable;
  wire [15:0]  address;
  wire [7:0]   rd_data;
  reg [7:0]    wr_data;

  wire [2:0]    alu_ctrl;
  wire [7:0]    alu_AI;
  wire [7:0]    alu_BI;
  wire          alu_carry;
  wire          alu_DAA;

  wire [7:0]    alu_flags;
  wire [7:0]    alu_Y;

  // Create the 100MHz clock that the memory will run at
  initial begin
    clk_sys = 1'b1;
    forever begin
      #(T/2);
      clk_sys = ~clk_sys;
    end
  end

  // Create the 10MHz clock that the processor will run at
  initial begin
    clk = 1'b1;
    forever begin
      #(P/2);
      clk = ~clk;
    end
  end

  // Set some parameters to remain constant throughout (at least for now)
  initial begin
    enable = 1'b1;
    wr_enable = 1'b0;
  end

  // Initiate the global reset (for now, synchronize both edges to both
  // clocks, but later this will be performed by the porf block)
  initial begin
    resetn = 1'b1;
    #(P*2)
    resetn = 1'b0;
    #(P*4)
    resetn = 1'b1;
    #(P*100);
  end

  // Instantiate the memory block using the example from the generated
  memory_block
    #(
      ) inst_memory_block (
                           .clka  (clk_sys),
                           .ena   (enable),
                           .wea   (wr_enable),
                           .addra (address),
                           .dina  (wr_data),
                           .douta (rd_data)
                           );

  proc
    #(
      ) inst_proc (
                   .clk           (clk),
                   .resetn        (resetn),
                   .rd_data       (rd_data),
                   .address       (address),

                   .alu_flags     (alu_flags),
                   .alu_Y         (alu_Y),
                   .alu_ctrl      (alu_ctrl),
                   .alu_AI        (alu_AI),
                   .alu_BI        (alu_BI),
                   .alu_carry     (alu_carry),
                   .alu_DAA       (alu_DAA)
                   );

  alu
    #(
      ) inst_alu (
                  .alu_ctrl       (alu_ctrl),
                  .alu_AI         (alu_AI),
                  .alu_BI         (alu_BI),
                  .alu_carry      (alu_carry),
                  .alu_DAA        (alu_DAA),
                  .alu_flags      (alu_flags),
                  .alu_Y          (alu_Y)
                  );

endmodule // proc_top_tb

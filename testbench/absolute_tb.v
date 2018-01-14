// ----------------------------------------------------------------------------
// Module:  absolute_tb.v
// Project:
// Author:  George Castillo <gmcastil@gmail.com>
// Date:    15 October 2017
//
// Description: Testbench for implementation of the MOS 6502 processor core.
// Requires a .mif file containing memory contents from the abs.asm program in
// the /roms directory.
// ----------------------------------------------------------------------------

`timescale 1ns / 1ps

module absolute_tb ();

  localparam T = 10;
  localparam P = 100;

  reg          clk_sys;       // Memory will be clocked 10X relative to processor
  reg          clk;
  reg          resetn;
  reg          enable;
  wire         wr_enable;
  wire [15:0]  address;
  wire [7:0]   rd_data;
  wire [7:0]   wr_data;

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

  // Bring processor status register bits up to the top and break them out
  // into individual signals to aide in simulation
  wire sim_proc_carry;
  wire sim_proc_zero;
  wire sim_proc_irq;
  wire sim_proc_decimal;
  wire sim_proc_break_inst;
  wire sim_proc_overflow;
  wire sim_proc_negative;

  assign sim_proc_carry      = inst_proc.P[0];
  assign sim_proc_zero       = inst_proc.P[1];
  assign sim_proc_irq        = inst_proc.P[2];
  assign sim_proc_decimal    = inst_proc.P[3];
  assign sim_proc_break_inst = inst_proc.P[4];
  assign sim_proc_overflow   = inst_proc.P[6];
  assign sim_proc_negative   = inst_proc.P[7];

  wire [15:0] sim_proc_PC;

  assign sim_proc_PC         = inst_proc.PC;

  // -- Testing Cycle Accuracy
  integer cycle_counter = 0;

  localparam RESET_CYCLE = 6;  // cycles until end of reset
  localparam PROGRAM_START = 16'h8000;

  initial begin
    cycle_counter = 0;
    forever begin
      #P
      cycle_counter = cycle_counter + 1;
    end
  end

  initial begin
    #(P*(RESET_CYCLE + 3));  // Fetch of first instruction
    if (sim_proc_PC == PROGRAM_START) begin
      $display("Found program starting address of %h...OK", PROGRAM_START);
    end else begin
      $display("Program not found...FAIL");
    end

    #(P*4)
    if (sim_proc_PC == PROGRAM_START + 16'h0003) begin
      $display("LDA instruction took three cycles...OK");
    end else begin
      $display("LDA instruction took three cycles...FAIL");
    end
  end

  // -- Instantiations
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
                   .wr_data       (wr_data),
                   .wr_enable     (wr_enable)
                   );

endmodule // proc_top_tb

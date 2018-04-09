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

module proc_tb ();

`include "opcodes.vh"
`include "params.vh"

  localparam T = 10;

  logic         clk;
  logic         resetn;
  logic [7:0]   rd_data;
  logic [15:0]  address;
  logic [7:0]   wr_data;
  logic         wr_enable;

  logic [15:0] RESET_MSB = 16'hfffc;
  logic [15:0] RESET_LSB = 16'hfffd;

  logic [15:0] PROG_START = 16'h8000;

  logic [7:0] accumulator;
  logic [15:0] PC;

  integer      opcode_passed = 0;
  integer      opcode_failed = 0;
  integer      reset_passed = 0;
  integer      reset_failed = 0;
  integer      pc_passed = 0;
  integer      pc_failed = 0;
  integer      rd_passed = 0;
  integer      rd_failed = 0;

  // Create the processor clock
  initial begin
    clk = 1'b1;
    forever begin
      #10ns;
      clk = ~clk;
    end
  end

  // Initiate the global reset (for now, synchronize both edges to both
  // clocks, but later this will be performed by the porf block)
  initial begin
    resetn = 1'b1;
    #10ns;
    resetn = 1'b0;
    #30ns;
    resetn = 1'b1;
  end

  initial begin

    // Wait for the processor to emerge from reset
    #40ns;

    // --- Test reset vector
    assert (address == RESET_LSB) begin
      reset_passed++;
    end else begin
      reset_failed++;
    end
    rd_data = PROG_START[7:0];

    #10ns;
    assert (address == RESET_MSB) begin
      reset_passed++;
    end else begin
      reset_failed++;
    end
    rd_data = PROG_START[15:8];

    #10ns;
    // --- Begin testing program execution
    assert (address == PROG_START) begin
      pc_passed++;
    end else begin
      pc_failed++;
    end

    // -- Add With Carry (ADC)
    rd_data = ADC_abs;
    PC = PROG_START;
    #10ns;
    assert (address == PC + 16'h0001) begin
      opcode_passed++;
    end else begin
      opcode_failed++;
    end

    rd_data = 8'h00;
    #10ns;
    rd_data = 8'h90;
    #10ns;
    assert (address == 16'h9000) begin
      rd_passed++;
    end else begin
      rd_failed++;
    end

    rd_data = 8'h00;
    #10ns;
    assert (accumulator == 8'h00 &&
            carry == 1'b0 &&
            zero == 1'b1 &&
            overflow == 1'b0) begin
      opcode_passed++;
    end else begin
      opcode_failed++;
    end

    PC = PC + 16'd3;
    assert (PC == inst_proc.PC) begin
      pc_passed++;
    end else begin
      pc_failed++;
    end

    rd_data = ADC_abs;
    #10ns;
    assert (PC == address) begin
      rd_passed++;
    end else begin
      rd_failed++;
    end

    $display("Passing:");
    $display("  Opcodes: %5d", opcode_passed);
    $display("  Reset:   %5d", reset_passed);
    $display("  PC:      %5d", pc_passed);
    $display("  Read:    %5d", rd_passed);
    $display("\n");
    $display("Failing:");
    $display("  Opcodes: %5d", opcode_failed);
    $display("  Reset:   %5d", reset_failed);
    $display("  PC:      %5d", pc_failed);
    $display("  Read:    %5d", rd_passed);

    $finish;

  end


  // Bring processor status register bits up to the top and break them out
  // into individual signals to aide in simulation
  wire carry;
  wire zero;
  wire irq;
  wire decimal;
  wire break_inst;
  wire overflow;
  wire negative;

  assign carry      = inst_proc.P[0];
  assign zero       = inst_proc.P[1];
  assign irq        = inst_proc.P[2];
  assign decimal    = inst_proc.P[3];
  assign break_inst = inst_proc.P[4];
  assign overflow   = inst_proc.P[6];
  assign negative   = inst_proc.P[7];

  // -- Instantiations
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

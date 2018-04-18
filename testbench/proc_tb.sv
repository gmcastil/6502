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

  localparam CLOCK = 10;
  localparam STEP = CLOCK / 2;

  logic         clk;
  logic         resetn;
  logic [7:0]   rd_data;
  logic [15:0]  address;
  logic [7:0]   wr_data;
  logic         wr_enable;

  logic [15:0] RESET_MSB = 16'hfffc;
  logic [15:0] RESET_LSB = 16'hfffd;

  logic [15:0] PROG_START = 16'h8000;

  // Addressing modes for instruction decoding in tasks
  string       IMM = "immediate";
  string       ACC = "accumulator";
  string       ABS = "absolute";
  string       ZP  = "zero page";
  string       ABX = "absolute x";
  string       ABY = "absolute y";
  string       ZPX = "zero page x";
  string       ZPY = "zero page y";
  string       IZX = "indirect x";
  string       IZY = "indirect y";
  string       IND = "indirect";
  string       REL = "relative";

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
      #(STEP);
      clk = ~clk;
    end
  end

  // Primary instruction testing
  initial begin

    // -- Reset the processor
    resetn <= 1'b1;
    #(CLOCK*10) proc_reset(10);

    // -- LDA
    lda("immediate", 8'h00, 16'h8000);
    #(CLOCK*100);

    $display("Passing:");
    $display("  Opcodes: %5d", opcode_passed);
    $display("  Reset:   %5d", reset_passed);
    $display("  PC:      %5d", pc_passed);
    $display("  Read:    %5d", rd_passed);
    $display("");
    $display("Failing:");
    $display("  Opcodes: %5d", opcode_failed);
    $display("  Reset:   %5d", reset_failed);
    $display("  PC:      %5d", pc_failed);
    $display("  Read:    %5d", rd_passed);
    $display("");
    $finish;

  end

  task proc_reset (input int duration);
    begin
      resetn <= 1'b0;
      #(CLOCK*duration);
      resetn <= 1'b1;
    end
  endtask // proc_reset

  task lda (
            input string     mode,
            input bit [7:0]  test_data,
            input bit [15:0] test_address
            );

    begin
      case (mode)

        IMM: begin
          address = test_address;
          rd_data = LDA_imm;
          #CLOCK;
          rd_data = test_data;
          #CLOCK;
        end

        default: $display("Addressing mode not supported for instruction.");

      endcase // case (mode)

    end
  endtask // lda

  // Bring processor status register bits up to the top and break them out
  // into individual signals to aide in simulation
  wire carry;
  wire zero;
  wire irq;
  wire decimal;
  wire break_inst;
  wire overflow;
  wire negative;

  wire A;
  wire X;
  wire Y;
  wire S;
  wire PC;
  wire IR;
  wire P;

  // Break out individual processor status bits
  assign carry      = inst_proc.P[0];
  assign zero       = inst_proc.P[1];
  assign irq        = inst_proc.P[2];
  assign decimal    = inst_proc.P[3];
  assign break_inst = inst_proc.P[4];
  assign overflow   = inst_proc.P[6];
  assign negative   = inst_proc.P[7];

  // Bring critical internal signals up and give them meaningful names
  assign A  = inst_proc.A;
  assign X  = inst_proc.X;
  assign Y  = inst_proc.Y;
  assign S  = inst_proc.S;
  assign PC = inst_proc.PC;
  assign IR = inst_proc.IR;
  assign P  = inst_proc.P;

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

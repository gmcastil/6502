// ----------------------------------------------------------------------------
// Module:  alu_tb.v
// Project: MOS 6502 Processor
// Author:  George Castillo <gmcastil@gmail.com>
// Date:    09 July 2017
//
// Description: Testbench for the MOS 6502 ALU.  Does not really attempt to do
// much more than instantiate teh ALU and add a couple of numbers together.
// ----------------------------------------------------------------------------

`timescale 10ns / 1ps;

module alu_tb ();

  reg [3:0] alu_control;
  reg [7:0] alu_AI;
  reg [7:0] alu_BI;
  reg       alu_carry_in;

  reg [7:0] alu_Y;
  reg       alu_carry_out;
  reg       alu_overflow;

`include "./includes/params.vh"

  alu #(
        ) dut (
               .ctrl (ctrl),
               .AI   (AI),
               .BI   (BI),
               .CI   (CI),
               .D    (D),

               .N    (N),
               .V    (V),
               .Z    (Z),
               .CO   (CO),
               .HC   (HC),

               .out  (out)
               );

  initial begin
    // Let the simulator get caught up before starting
    #10ns;

    alu_AI = 8'hff;
    alu_BI = 8'hff;
    alu_carry_in = 1'b1;
    alu_control = 4'
    #10ns;
    alu_AI = 8'hff;
    alu_BI = 8'hff;
    alu_carry_in = 1'b0;
    alu_control = 4'b0000;
    #10ns;
  end

endmodule // alu_tb

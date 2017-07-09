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

  logic [3:0] ctrl;
  logic [7:0] AI;
  logic [7:0] BI;
  logic       CI;
  logic       D;

  logic       N;
  logic       V;
  logic       Z;
  logic       CO;
  logic       HC;

  logic [7:0] out;

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
    // Let the simulator get caught up before starting to add
    #10ns;
    AI = 8'hFF;
    BI = 8'hFF;
    CI = 1'b1;
    D = 1'b0;
    ctrl = 4'b0000;
    #10ns;
    AI = 8'hFF;
    BI = 8'hFF;
    CI = 1'b0;
    D = 1'b0;
    ctrl = 4'b0000;
    #10ns;
  end

endmodule // alu_tb

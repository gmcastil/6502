// ----------------------------------------------------------------------------
// Module:  alu_tb.v
// Project: MOS 6502 Processor
// Author:  George Castillo <gmcastil@gmail.com>
// Date:    09 July 2017
//
// Description: Testbench for the MOS 6502 ALU.  Does not really attempt to do
// much more than instantiate the ALU and add a couple of numbers together.
// ----------------------------------------------------------------------------

`timescale 1ns / 1ps;

module alu_tb ();

  reg [3:0] alu_control;
  reg [7:0] alu_AI;
  reg [7:0] alu_BI;
  reg       alu_carry_in;

  reg [7:0] alu_Y;
  reg       alu_carry_out;
  reg       alu_overflow;

`include "../src/includes/params.vh"

  alu #(
        ) u_alu (
                 .alu_control   (alu_control),
                 .alu_AI        (alu_AI),
                 .alu_BI        (alu_BI),
                 .alu_carry_in  (alu_carry_in),
                 .alu_Y         (alu_Y),
                 .alu_carry_out (alu_carry_out),
                 .alu_overflow  (alu_overflow)
               );

  // initial begin
  //   // Let the simulator get caught up before starting
  //   #100ns;
  //   for (A=0, A<256, A=A+1) begin
  //     for (B=0, B<256, B=B+1) begin
  //       $display("A = %b, B = %b", A, B);
  //       #10ns;
  //     end
  //   end
  // end

  initial begin
    // Let the simulator get caught up before starting
    #100ns;

    tests_passed = 0;
    tests_failed = 0;

    // Testing addition without a carry in
    alu_control = ADD;
    alu_carry_in = 1'b0;

    for (A=0, A<256, A=A+1) begin
      for (B=0, B<256, B=B+1) begin
        alu_AI = A;
        alu_BI = B;
        #10ns;

        // Test carry out with no overflow
        if (!alu_AI[7] && !alu_BI[7] && alu_carry_in) begin

          if (alu_Y[7] == 1'b1) begin
            tests_passed = tests_passed + 1;
          end else begin
            tests_failed = tests_failed + 1;
          end
          if (alu_overflow == 1'b1) begin
            tests_passed = tests_passed + 1;
          end else begin
            tests_failed = tests_failed + 1;
          end
          if (carry_out == 1'b0) begin
            tests_passed = tests_passed + 1;
          end else begin
            tests_failed = tests_failed + 1;
          end

        // Test carry out with overflow
        end else if (alu_AI[7] && alu_BI[7] && !alu_carry_in) begin

          if (alu_Y[7] == 1'b1) begin
            tests_passed = tests_passed + 1;
          end else begin
            tests_failed = tests_failed + 1;
          end
          if (alu_overflow == 1'b1) begin
            tests_passed = tests_passed + 1;
          end else begin
            tests_failed = tests_failed + 1;
          end
          if (carry_out == 1'b0) begin
            tests_passed = tests_passed + 1;
          end else begin
            tests_failed = tests_failed + 1;
          end
        end // if (alu_AI[7] && alu_BI[7] && !alu_carry_in)

      end
    end
  end




endmodule // alu_tb

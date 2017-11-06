// ----------------------------------------------------------------------------
// Module:  alu_tb.v
// Project: MOS 6502 Processor
// Author:  George Castillo <gmcastil@gmail.com>
// Date:    09 July 2017
//
// Description: Testbench for the MOS 6502 ALU.  Intended to be fairly
// exhaustive with good coverage.
// ----------------------------------------------------------------------------

`timescale 1ns / 1ps

module alu_tb ();

  reg [2:0]  alu_control;
  reg [7:0]  alu_AI;
  reg [7:0]  alu_BI;
  reg        alu_carry_in;

  wire [7:0] alu_Y;
  wire       alu_carry_out;
  wire       alu_overflow;

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

  integer   tests_failed;
  integer   tests_passed;
  integer   result;
  integer   A;
  integer   B;

  reg       carry_out;

  initial begin
    // Let the simulator get caught up before starting
    #100;

    // -- Test Addition Operation
    // Testing addition without a carry in
    tests_failed = 0;
    tests_passed = 0;

    alu_control = ADD;
    alu_carry_in = 1'b0;

    for (A=0; A<256; A=A+1'd1) begin
      for (B=0; A<256; B=B+1'd1) begin
        alu_AI = A;
        alu_BI = B;
        #10;

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
          if (alu_carry_out == 1'b0) begin
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
          if (alu_carry_out == 1'b0) begin
            tests_passed = tests_passed + 1;
          end else begin
            tests_failed = tests_failed + 1;
          end

        // Test just overflow
        end else begin // if (alu_AI[7] && alu_BI[7] && !alu_carry_in)
          if (alu_overflow == 1'b0) begin
            tests_passed = tests_passed + 1;
          end else begin
            tests_failed = tests_failed + 1;
          end
        end // else: !if(alu_AI[7] && alu_BI[7] && !alu_carry_in)

        // Test the actual addition operation
        result = A + B;
        if (alu_Y == result[7:0]) begin
          tests_passed = tests_passed + 1;
        end else begin
          tests_failed = tests_failed + 1;
        end

        // Test carry out
        if (A + B > 255) begin
          if (alu_carry_out == 1'b1) begin
            tests_passed = tests_passed + 1;
          end else begin
            tests_failed = tests_failed + 1;
          end
        end else begin
          if (alu_carry_out == 1'b0) begin
            tests_passed = tests_passed + 1;
          end else begin
            tests_failed = tests_failed + 1;
          end
        end // else: !if(A + B > 255)

      end // for (B=0, B<256, B=B+1)
    end // for (A=0, A<256, A=A+1)

    // -- Addition Summary
    if (tests_failed == 0) begin
      $display("Addition...OK");
    end else begin
      $display("Addition...%d passing and %d failures.", tests_passed, tests_failed);
    end

    #100;

    // -- Testing Right Shift Operation
    tests_failed = 0;
    tests_passed = 0;

    for (A=0; A<256; A=A+1) begin
      alu_AI = A;
      alu_control = SR;
      alu_carry_in = 1'b0;
      if (A % 2 == 1) begin
        result = (A - 1) / 2;
        carry_out = 1'b1;
      end else begin
        result = A / 2;
        carry_out = 1'b1;
      end
      #10;

      if (alu_Y == result && carry_out == alu_carry_out) begin
        tests_passed = tests_passed + 1;
      end else begin
        tests_failed = tests_failed + 1;
      end

      alu_carry_in = 1'b1;
      #10;
      if (alu_Y == result + 128 && carry_out == alu_carry_out) begin
        tests_passed = tests_passed + 1;
      end else begin
        tests_failed = tests_failed + 1;
      end

    end

    $finish;
  end

endmodule // alu_tb

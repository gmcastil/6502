// ----------------------------------------------------------------------------
// Module:  alu_tb.sv
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

  integer    tests_failed;
  integer    tests_passed;
  integer    ovf_tests_failed;
  integer    ovf_tests_passed;
  integer    result;

  reg        carry_out;

  initial begin
    // Let the simulator get caught up before starting
    #100;

    // -- Results header
    $display("Results:\n");
    $display("|--------------+---------------------+-----------------------+-------------------|");
    $display("|              |      Overflow       |        Carry Out      |      Result       |");
    $display("|--------------+----------+----------+------------+----------+---------+---------|");
    $display("| Operation    |  Passes  |   Fails  |   Passes   |  Fails   | Passes  | Fails   |");
    $display("|--------------+----------+----------+------------+----------+---------+---------|");

    // -- Test Addition Operation
    $display("| Addition     |          |          |            |          |         |         |");
    $display("|   With Carry |          |          |            |          |         |         |");
    $display("|   No Carry   |          |          |            |          |         |         |");

    test_addition(1'b0, tests_passed, tests_failed,
                  ovf_tests_passed, ovf_tests_failed);
    $display("| Addition    |  No   | %6d |   %6d | %6d | %6d |",
             tests_passed, tests_failed, ovf_tests_passed, ovf_tests_failed);
    test_addition(1'b1, tests_passed, tests_failed,
                  ovf_tests_passed, ovf_tests_failed);
    $display("| Addition    |  Yes  | %6d |   %6d | %6d | %6d |",
             tests_passed, tests_failed, ovf_tests_passed, ovf_tests_failed);
    #100;

    // // -- Testing Right Shift Operation
    $display("| Right Shift  |          |       |           |        |         |         |");
    $display("|   With Carry |          |       |           |        |         |         |");
    $display("|   No Carry   |          |       |           |        |         |         |");

    // test_right_shift(1'b0, tests_passed, tests_failed);
    // $display("| Shift Right |  No   | %6d |   %6d |", tests_passed, tests_failed);
    // test_right_shift(1'b1, tests_passed, tests_failed);
    // $display("| Shift Right |  Yes  | %6d |   %6d |", tests_passed, tests_failed);
    // #100;

    // -- Testing AND Operation
    tests_failed = 0;
    tests_passed = 0;
    alu_control = AND;

    for (int A = 0; A < 256; A++) begin
      for (int B = 0; B < 256; B++) begin
        alu_AI = A[7:0];
        alu_BI = B[7:0];
        result = A & B;
        #10;
        assert (alu_Y == result[7:0]) begin
          tests_passed++;
        end else begin
          tests_failed++;
        end
      end
    end
    $display("| AND         |       | %6d |   %6d |", tests_passed, tests_failed);

    // -- Testing OR Operation
    tests_failed = 0;
    tests_passed = 0;
    alu_control = OR;

    for (int A = 0; A < 256; A++) begin
      for (int B = 0; B < 256; B++) begin
        alu_AI = A[7:0];
        alu_BI = B[7:0];
        result = A | B;
        #10;
        assert (alu_Y == result[7:0]) begin
          tests_passed++;
        end else begin
          tests_failed++;
        end
      end
    end
    $display("| OR          |       | %6d |   %6d |", tests_passed, tests_failed);

    // -- Testing XOR Operation
    tests_failed = 0;
    tests_passed = 0;
    alu_control = XOR;

    for (int A = 0; A < 256; A++) begin
      for (int B = 0; B < 256; B++) begin
        alu_AI = A[7:0];
        alu_BI = B[7:0];
        result = A ^ B;
        #10;
        assert (alu_Y == result[7:0]) begin
          tests_passed++;
        end else begin
          tests_failed++;
        end
      end
    end
    $display("| XOR         |       | %6d |   %6d |", tests_passed, tests_failed);
    $display("|-----------------------------------------|");
    $display("");

    $finish;
  end // initial begin

  // Test Addition
  task test_addition;
    input      carry_in;
    output int add_passed;
    output int add_failed;
    output int add_ovf_passed;
    output int add_ovf_failed;
    output int add_carry_passed;
    output int add_carry_failed;

    add_passed = 0;
    add_failed = 0;
    add_ovf_passed = 0;
    add_ovf_failed = 0;
    add_carry_passed = 0;
    add_carry_failed = 0;

    alu_control = ADD;
    alu_carry_in = carry_in;

    for (int A = 0; A < 256; A++) begin
      for (int B = 0; B < 256; B++) begin
        alu_AI = A[7:0];
        alu_BI = B[7:0];
        alu_carry_in = carry_in;
        #10;

        // Test the actual addition operation
        assert (alu_Y == (A[7:0] + B[7:0] + {7'd0, carry_in})) begin
          add_passed++;
        end else begin
          add_failed++;
        end

        // Test the overflow bit
        if ((!alu_AI[7] && !alu_BI[7] && alu_carry_in)
            || (alu_AI[7] && alu_BI[7] && !alu_carry_in)) begin
          assert (alu_overflow == 1'b1) begin
            add_ovf_passed++;
          end else begin
            add_ovf_failed++;
          end
        end else begin
          assert (alu_overflow == 1'b0) begin
            add_ovf_passed++;
          end else begin
            add_ovf_failed++;
          end
        end

        // Test the carry out bit
        if ((A[7:0] + B[7:0] + {7'd0, carry_in}) > 255) begin
          assert (alu_carry_out == 1'b1) begin
            add_carry_passed++;
          end else begin
            add_carry_failed++;
          end
        end else begin
          assert (alu_carry_out == 1'b0) begin
            add_carry_passed++;
          end else begin
            add_carry_failed++;
          end
        end

      end // for (int B = 0; B < 256; B++)
    end // for (int A = 0; A < 256; A++)
  endtask // test_addition

  //       // Test carry out
  //       if (A + B > 255) begin
  //         assert (alu_carry_out == 1'b1) begin
  //           add_passed++;
  //         end else begin
  //           add_failed++;
  //         end
  //       end else begin
  //         assert (alu_carry_out == 1'b0) begin
  //           add_passed++;
  //         end else begin
  //           add_failed++;
  //         end
  //       end
  //     end
  //   end
  // endtask // test_addition

  // Test right shift
  task test_right_shift;
    input carry_in;
    output int sr_passed;
    output int sr_failed;

    sr_passed = 0;
    sr_failed = 0;

    alu_control = SR;

    reg [7:0] sr_result;

    for (int A = 0; A < 256; A++) begin
      alu_AI = A[7:0];
      alu_carry_in = carry_in;

      if (A % 2 == 1) begin
        sr_result = (A - 1) / 2;
        carry_out = 1'b1;
      end else begin
        sr_result = A / 2;
        carry_out = 1'b0;
      end
      #10;

      assert (alu_Y == {carry_in, sr_result[6:0]} && carry_out == alu_carry_out) begin
        sr_passed++;
      end else begin
        sr_failed++;
      end
    end
  endtask // test_right_shift

endmodule // alu_tb

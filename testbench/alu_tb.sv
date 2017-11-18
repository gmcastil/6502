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

  integer    total_failed;
  integer    total_passed;
  integer    result_failed;
  integer    result_passed;
  integer    ovf_failed;
  integer    ovf_passed;
  integer    carry_failed;
  integer    carry_passed;

  initial begin
    // Let the simulator get caught up before starting
    #100;
    total_passed = 0;
    total_failed = 0;

    // -- Results header
    $display("Results:\n");
    $display("|--------------+-----------------+-----------------+-----------------|");
    $display("|              |    Overflow     |    Carry Out    |     Result      |");
    $display("|--------------+--------+--------+--------+--------+--------+--------|");
    $display("| Operation    | Passes |  Fails | Passes |  Fails | Passes |  Fails |");
    $display("|--------------+--------+--------+--------+--------+--------+--------|");

    // -- Addition operation
    $display("| Addition     | %6d | %6d | %6d | %6d | %6d | %6d |");

    // -- With carry
    test_addition(1'b1, ovf_passed, ovf_failed,
                  carry_passed, carry_failed,
                  result_passed, result_failed);
    $display("|   With Carry | %6d | %6d | %6d | %6d | %6d | %6d |",
             ovf_passed, ovf_failed,
             carry_passed, carry_failed,
             result_passed, result_failed);
    total_passed = ovf_passed + carry_passed + result_passed;
    total_failed = ovf_failed + carry_failed + result_failed;


    // -- Without carry
    test_addition(1'b0, ovf_passed, ovf_failed,
                  carry_passed, carry_failed,
                  result_passed, result_failed);
    $display("|   No Carry   | %6d | %6d | %6d | %6d | %6d | %6d |",
             ovf_passed, ovf_failed,
             carry_passed, carry_failed,
             result_passed, result_failed);
    total_passed = ovf_passed + carry_passed + result_passed;
    total_failed = ovf_failed + carry_failed + result_failed;

    #100;
    // -- Right shift operation
    $display("| Right Shift  |        |        |        |        |        |        |");

    // -- With carry
    test_right_shift(1'b1, ovf_passed, ovf_failed,
                     carry_passed, carry_failed,
                     result_passed, result_failed);
    $display("|   With Carry | %6d | %6d | %6d | %6d | %6d | %6d |",
             ovf_passed, ovf_failed,
             carry_passed, carry_failed,
             result_passed, result_failed);
    total_passed = ovf_passed + carry_passed + result_passed;
    total_failed = ovf_failed + carry_failed + result_failed;

    // -- Without carry
    test_right_shift(1'b0, ovf_passed, ovf_failed,
                     carry_passed, carry_failed,
                     result_passed, result_failed);
    $display("|   No Carry   | %6d | %6d | %6d | %6d | %6d | %6d |",
             ovf_passed, ovf_failed,
             carry_passed, carry_failed,
             result_passed, result_failed);
    total_passed = ovf_passed + carry_passed + result_passed;
    total_failed = ovf_failed + carry_failed + result_failed;

    #100;
    // -- AND operation
    test_and(1'bx, ovf_passed, ovf_failed,
             carry_passed, carry_failed,
             result_passed, result_failed);
    $display("| AND          | %6d | %6d | %6d | %6d | %6d | %6d |",
             ovf_passed, ovf_failed,
             carry_passed, carry_failed,
             result_passed, result_failed);
    total_passed = ovf_passed + carry_passed + result_passed;
    total_failed = ovf_failed + carry_failed + result_failed;

    #100;
    // -- OR operation
    test_or(1'bx, ovf_passed, ovf_failed,
            carry_passed, carry_failed,
            result_passed, result_failed);
    $display("| OR           | %6d | %6d | %6d | %6d | %6d | %6d |",
             ovf_passed, ovf_failed,
             carry_passed, carry_failed,
             result_passed, result_failed);
    total_passed = ovf_passed + carry_passed + result_passed;
    total_failed = ovf_failed + carry_failed + result_failed;

    #100;
    // -- XOR operation
    test_xor(1'bx, ovf_passed, ovf_failed,
             carry_passed, carry_failed,
             result_passed, result_failed);
    $display("| XOR          | %6d | %6d | %6d | %6d | %6d | %6d |",
             ovf_passed, ovf_failed,
             carry_passed, carry_failed,
             result_passed, result_failed);
    total_passed = ovf_passed + carry_passed + result_passed;
    total_failed = ovf_failed + carry_failed + result_failed;

    // -- Finish up
    $display("|--------------+-----------------+-----------------+-----------------|");
    $display("");
    $display("TOTAL PASSING TESTS...%d", total_passed);
    $display("TOTAL FAILING TESTS...%d", total_failed);
    $display("");
    $finish;

  end // initial begin

  // Addition
  task test_addition;
    input      add_carry_in;
    output int add_ovf_passed;
    output int add_ovf_failed;
    output int add_carry_passed;
    output int add_carry_failed;
    output int add_passed;
    output int add_failed;

    add_ovf_passed = 0;
    add_ovf_failed = 0;
    add_carry_passed = 0;
    add_carry_failed = 0;
    add_passed = 0;
    add_failed = 0;

    alu_control = ADD;
    alu_carry_in = carry_in;

    for (int A = 0; A < 256; A++) begin
      for (int B = 0; B < 256; B++) begin
        alu_AI = A[7:0];
        alu_BI = B[7:0];
        alu_carry_in = carry_in;
        #10;

        // Test the actual addition operation
        assert (alu_Y == (A[7:0] + B[7:0] + {7'd0, add_carry_in})) begin
          add_passed++;
        end else begin
          add_failed++;
        end

        // Test the overflow bit
        if ((!A[7] && !B[7] && carry_in) || (A[7] && B[7] && !add_carry_in)) begin
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
        if ((A[7:0] + B[7:0] + {7'd0, add_carry_in}) > 255) begin
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

  // Test right shift
  task test_right_shift;
    input      sr_carry_in;
    output int sr_ovf_passed;
    output int sr_ovf_failed;
    output int sr_carry_passed;
    output int sr_carry_failed;
    output int sr_passed;
    output int sr_failed;

    sr_ovf_passed = 0;
    sr_ovf_failed = 0;
    sr_carry_passed = 0;
    sr_carry_failed = 0;
    sr_passed = 0;
    sr_failed = 0;

    alu_control = SR;

    reg [7:0] sr_result;
    reg       sr_carry_out;

    for (int A = 0; A < 256; A++) begin
      alu_AI = A[7:0];
      alu_carry_in = sr_carry_in;

      if (A % 2 == 1) begin
        sr_result = (A - 1) / 2;
        sr_carry_out = 1'b1;
      end else begin
        sr_result = A / 2;
        sr_carry_out = 1'b0;
      end
      #10;

      // Test the shift operation
      assert (alu_Y == sr_result) begin
        sr_passed++;
      end else begin
        sr_failed++;
      end

      // Test the carry out bit
      assert (alu_carry_out == sr_carry_out) begin
        sr_carry_passed++;
      end else begin
        sr_carry_failed++;
      end

      // Test the overflow bit - should always be zero
      assert (alu_overflow == 1'b0);
        sr_ovf_passed++;
      end else begin
        sr_ovf_failed++;
      end
    end
  endtask // test_right_shift


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


endmodule // alu_tb

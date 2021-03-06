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
    $display("| Addition     |        |        |        |        |        |        |");

    // -- With carry
    test_addition(1'b1, ovf_passed, ovf_failed,
                  carry_passed, carry_failed,
                  result_passed, result_failed);
    $display("|   With Carry | %6d | %6d | %6d | %6d | %6d | %6d |",
             ovf_passed, ovf_failed,
             carry_passed, carry_failed,
             result_passed, result_failed);
    total_passed += ovf_passed + carry_passed + result_passed;
    total_failed += ovf_failed + carry_failed + result_failed;


    // -- Without carry
    test_addition(1'b0, ovf_passed, ovf_failed,
                  carry_passed, carry_failed,
                  result_passed, result_failed);
    $display("|   No Carry   | %6d | %6d | %6d | %6d | %6d | %6d |",
             ovf_passed, ovf_failed,
             carry_passed, carry_failed,
             result_passed, result_failed);
    $display("|              |        |        |        |        |        |        |");
    total_passed += ovf_passed + carry_passed + result_passed;
    total_failed += ovf_failed + carry_failed + result_failed;

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
    total_passed += ovf_passed + carry_passed + result_passed;
    total_failed += ovf_failed + carry_failed + result_failed;

    // -- Without carry
    test_right_shift(1'b0, ovf_passed, ovf_failed,
                     carry_passed, carry_failed,
                     result_passed, result_failed);
    $display("|   No Carry   | %6d | %6d | %6d | %6d | %6d | %6d |",
             ovf_passed, ovf_failed,
             carry_passed, carry_failed,
             result_passed, result_failed);
    $display("|              |        |        |        |        |        |        |");
    total_passed += ovf_passed + carry_passed + result_passed;
    total_failed += ovf_failed + carry_failed + result_failed;

    #100;
    // -- AND operation
    test_and(ovf_passed, ovf_failed,
             result_passed, result_failed);
    $display("| AND          | %6d | %6d |        |        | %6d | %6d |",
             ovf_passed, ovf_failed,
             result_passed, result_failed);
    total_passed += ovf_passed + result_passed;
    total_failed += ovf_failed + result_failed;

    #100;
    // -- OR operation
    test_or(ovf_passed, ovf_failed,
            result_passed, result_failed);
    $display("| OR           | %6d | %6d |        |        | %6d | %6d |",
             ovf_passed, ovf_failed,
             result_passed, result_failed);
    total_passed += ovf_passed + result_passed;
    total_failed += ovf_failed + result_failed;

    #100;
    // -- XOR operation
    test_xor(ovf_passed, ovf_failed,
             result_passed, result_failed);
    $display("| XOR          | %6d | %6d |        |        | %6d | %6d |",
             ovf_passed, ovf_failed,
             result_passed, result_failed);
    total_passed += ovf_passed + result_passed;
    total_failed += ovf_failed + result_failed;

    // -- Finish up
    $display("|--------------+-----------------+-----------------+-----------------|");
    $display("");
    $display("TOTAL PASSING TESTS...%7d", total_passed);
    $display("TOTAL FAILING TESTS...%7d", total_failed);
    $display("");
    $finish;

  end // initial begin

  // Addition task definition
  task test_addition;
    input bit add_carry_in;
    output integer add_ovf_passed;
    output integer add_ovf_failed;
    output integer add_carry_passed;
    output integer add_carry_failed;
    output integer add_passed;
    output integer add_failed;

    add_ovf_passed = 0;
    add_ovf_failed = 0;
    add_carry_passed = 0;
    add_carry_failed = 0;
    add_passed = 0;
    add_failed = 0;

    alu_control = ADD;
    for (integer A = 0; A < 256; A++) begin
      for (integer B = 0; B < 256; B++) begin
        alu_AI = A[7:0];
        alu_BI = B[7:0];
        alu_carry_in = add_carry_in;
        #10;

        // Test the actual addition operation
        assert (alu_Y == (A[7:0] + B[7:0] + {7'd0, add_carry_in})) begin
          add_passed++;
        end else begin
          add_failed++;
        end

        // Test the overflow bit
        if (~(A[7] ^ B[7]) & (A[7] ^ alu_Y[7])) begin
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
        if (A + B + integer'(add_carry_in) > 255) begin
          assert (alu_carry_out == 1'b1) begin
            add_carry_passed++;
          end else begin
            add_carry_failed++;
          end
        end else begin
          // $display("A is %6d, B is %6d", A, B);
          assert (alu_carry_out == 1'b0) begin
            add_carry_passed++;
          end else begin
            add_carry_failed++;
          end
        end

      end // for (integer B = 0; B < 256; B++)
    end // for (integer A = 0; A < 256; A++)
  endtask // test_addition

  // Right shift task definition
  task test_right_shift;
    input  bit sr_carry_in;
    output integer sr_ovf_passed;
    output integer sr_ovf_failed;
    output integer sr_carry_passed;
    output integer sr_carry_failed;
    output integer sr_passed;
    output integer sr_failed;

    sr_ovf_passed = 0;
    sr_ovf_failed = 0;
    sr_carry_passed = 0;
    sr_carry_failed = 0;
    sr_passed = 0;
    sr_failed = 0;

    alu_control = SR;
    for (integer A = 0; A < 256; A++) begin
      alu_AI = A[7:0];
      alu_carry_in = sr_carry_in;
      #10;

      // Test shift result
      assert (alu_Y == {sr_carry_in, A[7:1]}) begin
        sr_passed++;
      end else begin
        sr_failed++;
      end

      // Test carry bit
      if (A % 2 == 1) begin
        assert (alu_carry_out == 1'b1) begin
          sr_carry_passed++;
        end else begin
          sr_carry_failed++;
        end
      end else begin
        assert (alu_carry_out == 1'b0) begin
          sr_carry_passed++;
        end else begin
          sr_carry_failed++;
        end
      end

      // Test the overflow bit - should always be zero
      assert (alu_overflow == 1'b0) begin
        sr_ovf_passed++;
      end else begin
        sr_ovf_failed++;
      end
    end
  endtask // test_right_shift

  // AND task definition
  task test_and;
    output integer and_ovf_passed;
    output integer and_ovf_failed;
    output integer and_passed;
    output integer and_failed;

    and_ovf_passed = 0;
    and_ovf_failed = 0;
    and_passed = 0;
    and_failed = 0;

    alu_control = AND;
    for (integer A = 0; A < 256; A++) begin
      for (integer B = 0; B < 256; B++) begin
        alu_AI = A[7:0];
        alu_BI = B[7:0];
        #10;

        assert (alu_Y == (A[7:0] & B[7:0])) begin
          and_passed++;
        end else begin
          and_failed++;
        end
        assert (alu_overflow == 1'b0) begin
          and_ovf_passed++;
        end else begin
          and_ovf_failed++;
        end
      end
    end
  endtask // test_and

  // OR task definition
  task test_or;
    output integer or_ovf_passed;
    output integer or_ovf_failed;
    output integer or_passed;
    output integer or_failed;

    or_ovf_passed = 0;
    or_ovf_failed = 0;
    or_passed = 0;
    or_failed = 0;

    alu_control = OR;
    for (integer A = 0; A < 256; A++) begin
      for (integer B = 0; B < 256; B++) begin
        alu_AI = A[7:0];
        alu_BI = B[7:0];
        #10;

        assert (alu_Y == (A[7:0] | B[7:0])) begin
          or_passed++;
        end else begin
          or_failed++;
        end
        assert (alu_overflow == 1'b0) begin
          or_ovf_passed++;
        end else begin
          or_ovf_failed++;
        end
      end
    end
  endtask

  // XOR task definition
  task test_xor;
    output integer xor_ovf_passed;
    output integer xor_ovf_failed;
    output integer xor_passed;
    output integer xor_failed;

    xor_ovf_passed = 0;
    xor_ovf_failed = 0;
    xor_passed = 0;
    xor_failed = 0;

    alu_control = XOR;
    for (integer A = 0; A < 256; A++) begin
      for (integer B = 0; B < 256; B++) begin
        alu_AI = A[7:0];
        alu_BI = B[7:0];
        #10;

        assert (alu_Y == (A[7:0] ^ B[7:0])) begin
          xor_passed++;
        end else begin
          xor_failed++;
        end
        assert (alu_overflow == 1'b0) begin
          xor_ovf_passed++;
        end else begin
          xor_ovf_failed++;
        end
      end
    end
  endtask

endmodule // alu_tb

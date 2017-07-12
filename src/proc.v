// ----------------------------------------------------------------------------
// Module:  proc.v
// Project: MOS 6502 Processor
// Author:  George Castillo <gmcastil@gmail.com>
// Date:    09 July 2017
//
// Description: Main module for the MOS 6502 processor core.
// ----------------------------------------------------------------------------

module proc
  #(
    // parameters
    )
  (
   input         clk,
   input         resetn,
   input [7:0]   rd_data,

   output [15:0] address
   );

  localparam RESET     = 0;
  localparam VECTOR_1  = 1;
  localparam VECTOR_2  = 2;
  localparam VECTOR_3  = 3;
  localparam FETCH_1   = 4;
  localparam EXECUTE_2 = 5;
  localparam DECODE    = 6;
  localparam OPER_A1   = 7;
  localparam OPER_B1   = 8;
  localparam EXECUTE   = 9;
  localparam OPER_A2   = 10;

  localparam EMPTY     = 11'b0;  // Zero out the state vector more explicitly

  localparam RESET_LSB = 8'bFFFC;
  localparam RESET_MSB = 8'bFFFD;

  reg [10:0]     next;
  reg [10:0]     present;

  reg [15:0]     new_PC;

  reg [15:0]     PC;  // program counter
  reg [7:0]      IR;  // instruction register

  always @(posedge clk) begin
    if (!resetn == 1'b1) begin
      next <= EMPTY;
      next[RESET] <= 1'b1;
    end else begin
      next <= present;
    end
  end

  // --- State Machine Definition
  always @(*) begin:

    next = EMPTY;

    case (1'b1);

      present[VECTOR_1]: begin
        next[VECTOR_2] = 1'b1;
      end

      present[VECTOR_2]: begin
        next[VECTOR_3] = 1'b1;
      end

      present[VECTOR_3]: begin
        next[FETCH_1] = 1'b1;
      end

      present[FETCH_1]: begin
        next[FETCH_] = 1'b1;
      end

      present[FETCH_2]: begin
        next[DECODE] = 1'b1;
      end

      present[DECODE]: begin
        // This state machine transition is a little different than the other,
        // since the next state is dependent upon the decoded value of the
        // IR which was read from during the FETCH cycles
        next = dec_opcode;
      end

      present[OPER_A1]: begin
        next[OPER_A2] = 1'b1;
      end

      present[OPER_B1]: begin
        next[EXECUTE] = 1'b1;
      end

      present[OPER_A2]: begin
        next[EXECUTE] = 1'b1;
      end

      present[EXECUTE]: begin
        next[FETCH_1] = 1'b1;
      end

      default: begin end
    endcase // case (1'b1)
  end

  // --- Signals with State Machine Interactions
  always @(posedge clk) begin: INSTRUCTION_CYCLE

    case (1'b1);

      present[VECTOR_1]: begin
        address <= RESET_LSB;
      end

      present[VECTOR_2]: begin
        address <= RESET_MSB;
        PC[7:0] <= rd_data;
      end

      present[VECTOR_3]: begin
        PC[15:0] <= rd_data;
      end

      present[FETCH_1]: begin
        address <= PC;
      end

      present[FETCH_2]: begin
        IR <= rd_data;
      end

      present[DECODE]: begin
        PC <= PC + 16'b1;
        address <= PC + 16'b1;
      end

      present[OPER_A1]: begin
        PC_next <= PC + 16'b1;
        address <= PC + 16'b1;
        oper_LSB <= rd_data;
      end

      present[OPER_B1]: begin
        PC_next <= PC + 16'b1;
        oper_MSB <= rd_data;
      end

      present[EXECUTE]: begin

        case (IR):

          NOP: begin
          end

          JMP: begin
            PC <= {oper_MSB, oper_LSB};
          end
        endcase // case (opcode)
      end

      present[OPER_A2]: begin
        new_PC <= PC + 16'h0002;
      end

      default: begin end
    endcase // case (1'b1)

  end // block: INSTRUCTION_CYCLE

  // --- Opcode Definitions
  localparam NOP = 8'bEA;
  localparam JMP = 8'b4C;

  // The contents of the instruction register are decoded to determine the next
  // state that the state machine will transition to, which in turn determines
  // the number of additional oeprands that will need to be read from memory.
  always @(*): begin: OPCODE_DECODER

    case (IR):

      NOP: begin
        dec_opcode = EXECUTE;
      end

      JMP: begin
        dec_opcode = OPER_A1;
      end
    endcase // case (IR)

  end // block: OPCODE_DECODER

endmodule // proc

// ----------------------------------------------------------------------------
// Module:  proc.v
// Project: MOS 6502 Processor
// Author:  George Castillo <gmcastil@gmail.com>
// Date:    09 July 2017
//
// Description: Main module for the MOS 6502 processor core.
//
// References:
//
// [1] D. Eyes and R. Lichty, Programming the 65816: Including the 6502, 65C02
//     and 65802. New York, NY: Prentice Hall, 1986.
// ----------------------------------------------------------------------------

`include "opcodes.vh"

module proc
  (
   input         clk,
   input         resetn,
   input [7:0]   rd_data,

   output reg [15:0] address
   );

  // --- State Machine Indices and Signals
  localparam RESET    = 0;
  localparam VECTOR_1 = 1;
  localparam VECTOR_2 = 2;
  localparam VECTOR_3 = 3;
  localparam FETCH    = 4;
  localparam EXECUTE  = 5;
  localparam DECODE   = 6;

  reg [6:0]     next;
  reg [6:0]     state;

  //
  // --- Processor Registers
  reg [7:0]     A;   // accumulator
  reg [7:0]     X;   // X index register
  reg [7:0]     Y;   // Y index register
  reg [15:0]    S;   // stack pointer
  reg [15:0]    PC;  // program counter
  reg [7:0]     IR;  // instruction register

  // --- Status Registers
  reg           n;   // negative
  reg           z;   // zero
  reg           v;   // overflow
  reg           c;   // carry
  reg           b;   // break
  reg           d;   // decimal
  reg           i;   // interrupt

  reg [7:0]     oper_LSB;  // first operand
  wire          msb_rd_data;
  localparam RESET_LSB = 16'hFFFC;
  localparam RESET_MSB = 16'hFFFD;

  localparam ZERO      = 8'b0;
  localparam EMPTY     = 7'b0;  // Zero out the state vector more explicitly

  reg [6:0]     dec_opcode;

  assign msb_rd_data = rd_data[7];

  // synthesis translate_off
  reg [(8*8)-1:0] state_ascii;
  always @(*) begin

    case (state)
      7'b0000001: state_ascii <= "  RESET ";
      7'b0000010: state_ascii <= "VECTOR_1";
      7'b0000100: state_ascii <= "VECTOR_2";
      7'b0001000: state_ascii <= "VECTOR_3";
      7'b0010000: state_ascii <= "  FETCH ";
      7'b0100000: state_ascii <= " EXECUTE";
      7'b1000000: state_ascii <= " DECODE ";
    endcase

  end
  // synthesis translate_on

  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      state <= EMPTY;
      state[RESET] <= 1'b1;
    end else begin
      state <= next;
    end
  end

  // --- State Machine Definition
  always @(*) begin

    next = EMPTY;

    case (1'b1)

      state[RESET]: begin
        next[VECTOR_1] = 1'b1;
      end

      state[VECTOR_1]: begin
        next[VECTOR_2] = 1'b1;
      end

      state[VECTOR_2]: begin
        next[VECTOR_3] = 1'b1;
      end

      state[VECTOR_3]: begin
        next[FETCH] = 1'b1;
      end

      state[FETCH]: begin
        next[DECODE] = 1'b1;
      end

      state[DECODE]: begin
        // This state machine transition is a little different than the others,
        // since the next state is dependent upon the decoded value of the
        // IR which was read from during the FETCH cycles
        next = dec_opcode;
      end

      state[EXECUTE]: begin
        next[FETCH] = 1'b1;
      end

      default: begin end
    endcase // case (1'b1)
  end

  // --- Signals with State Machine Interactions
  always @(posedge clk) begin: INSTRUCTION_CYCLE

    case (1'b1)

      state[VECTOR_1]: begin
        address <= RESET_LSB;
      end

      state[VECTOR_2]: begin
        address <= RESET_MSB;
        PC[7:0] <= rd_data;
      end

      state[VECTOR_3]: begin
        address  <= { rd_data, PC[7:0] };
        PC[15:8] <= rd_data;
      end

      state[FETCH]: begin
        address <= PC + 16'b1;
        IR <= rd_data;
      end

      state[DECODE]: begin
        oper_LSB <= rd_data;

        case (IR)

          NOP: begin
            PC <= PC + 16'b1;
            address <= PC + 16'b1;
          end

          JMP: begin
            address <= PC + 16'b1 + 16'b1;
          end

          LDA: begin
            PC      <= PC + 16'b1 + 16'b1;
            address <= PC + 16'b1 + 16'b1;
            A       <= rd_data;
            n       <= msb_rd_data;
            if (rd_data == ZERO) begin
              z <= 1'b1;
            end else begin
              z <= 1'b0;
            end
          end

          default: begin end
        endcase

      end

      state[EXECUTE]: begin

        case (IR)

         JMP: begin
            address <= { rd_data, oper_LSB };
            PC <= { rd_data, oper_LSB };
          end

          default: begin
            address <= 16'hFFFF;
            PC <= 16'hFFFF;
          end
        endcase // case (IR)
      end

      default: begin end
    endcase // case (1'b1)

  end // block: INSTRUCTION_CYCLE

  // The contents of the instruction register are decoded to determine the next
  // state that the state machine will transition to, which in turn determines
  // the number of additional operands that will need to be read from memory.
  always @(*) begin: OPCODE_DECODER

    dec_opcode = EMPTY;

    case (IR)

      NOP: begin
        dec_opcode[FETCH] = 1'b1;
      end

      JMP: begin
        dec_opcode[EXECUTE] = 1'b1;
      end

      LDA: begin
        dec_opcode[FETCH] = 1'b1;
      end

    endcase // case (IR)

  end // block: OPCODE_DECODER

endmodule // proc
// ----------------------------------------------------------------------------
// Module:  proc.v
// Project: MOS 6502 Processor
// Author:  George Castillo <gmcastil@gmail.com>
// Date:    09 July 2017
//
// Description: Main module for the MOS 6502 processor core.
// ----------------------------------------------------------------------------

`include "./include/opcodes.vh"

module proc
  (
   input             clk,
   input             resetn,
   input [7:0]       rd_data,

   output reg [15:0] address,

   // ALU connections
   input [7:0]       alu_Y,
   input [7:0]       alu_flags,

   output reg [2:0]  alu_ctrl,
   output reg [7:0]  alu_AI,
   output reg [7:0]  alu_BI,
   output reg        alu_carry,
   output reg        alu_DAA
   );

  // --- State Machine Indices and Signals
  localparam RESET    = 0;
  localparam VECTOR_1 = 1;
  localparam VECTOR_2 = 2;
  localparam VECTOR_3 = 3;
  localparam FETCH    = 4;
  localparam EXECUTE  = 5;
  localparam DECODE   = 6;

  reg [6:0]          next;
  reg [6:0]          state;

  // This allows zeroing out the state vector explicitly
  localparam EMPTY    = 7'b0;

  // --- Processor Registers
  reg [7:0]     A;   // accumulator
  reg [7:0]     X;   // X index register
  reg [7:0]     Y;   // Y index register
  reg [15:0]    S;   // stack pointer
  reg [15:0]    PC;  // program counter
  reg [7:0]     IR;  // instruction register
  reg [7:0]     P;   // processor status register

  // --- Indices Into Processor Status Register (shared with ALU)
  localparam NEG    = 7;  // negative result
  localparam OVF    = 6;  // overflow
  localparam UNUSED = 5;
  localparam BREAK  = 4;
  localparam BCD    = 3;  // mode for add and subtract
  localparam IRQ    = 2;  // enable or disable IRQ line
  localparam ZERO   = 1;
  localparam CARRY  = 0;

  // --- Opcodes and Addressing Modes
  localparam ADC     = 8'h69;
  localparam NOP     = 8'hEA; //
  localparam JMP     = 8'h4C; //
  localparam LDA     = 8'hA9; //

  reg [7:0]     oper_LSB;  // first operand
  wire          msb_rd_data;

  // --- Reset and IRQ Vectors
  localparam RESET_LSB = 16'hFFFC;
  localparam RESET_MSB = 16'hFFFD;

  reg [6:0]     dec_opcode;

  // --- ALU Control and Mux Signals
  parameter SUM = 3'b000;
  parameter OR  = 3'b001;
  parameter XOR = 3'b010;
  parameter AND = 3'b011;
  parameter SR  = 3'b100;

  reg update_accumulator;

  // --- Other Miscellaneous Signals
  assign msb_rd_data = rd_data[7];

  // synthesis translate_off
  reg [(8*8)-1:0] state_ascii;
  always @(*) begin

    case ( state )
      7'b0000001: state_ascii <= "   RESET";
      7'b0000010: state_ascii <= "VECTOR_1";
      7'b0000100: state_ascii <= "VECTOR_2";
      7'b0001000: state_ascii <= "VECTOR_3";
      7'b0010000: state_ascii <= "   FETCH";
      7'b0100000: state_ascii <= " EXECUTE";
      7'b1000000: state_ascii <= "  DECODE";
    endcase

  end
  // synthesis translate_on

  // --- Reset Logic
  always @(posedge clk) begin
    if ( resetn == 1'b0 ) begin
      state <= EMPTY;
      state[RESET] <= 1'b1;

      update_accumulator <= 1'b0;
    end else begin
      state <= next;
    end
  end

  // --- State Machine Definition
  always @(*) begin: STATE_MACHINE

    next = EMPTY;

    case ( 1'b1 )

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

  end // block: STATE_MACHINE

  // --- Signals with State Machine Interactions
  always @(posedge clk) begin: INSTRUCTION_CYCLE

    case ( 1'b1 )

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
        if (update_accumulator == 1'b1) begin
          // May make more sense to have a case statement here to properly infer a mux
          A <= alu_Y;
          update_accumulator <= 1'b0;
        end
      end

      state[DECODE]: begin
        oper_LSB <= rd_data;

        case ( IR )

          ADC: begin
            PC <= PC + 16'b1 + 16'b1;
            address <= PC + 16'b1 + 16'b1;

            alu_ctrl <= SUM;
            alu_AI <= A;
            alu_BI <= rd_data;
            alu_carry <= P[CARRY];
            alu_DAA <= P[BCD];

            update_accumulator <= 1'b1;
          end

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
            P[NEG]  <= msb_rd_data;

            if ( rd_data == 8'b0 ) begin
              P[ZERO] <= 1'b1;
            end else begin
              P[ZERO] <= 1'b0;
            end
          end

          default: begin end
        endcase // ( IR )

      end

      state[EXECUTE]: begin

        case ( IR )

         JMP: begin
            address <= { rd_data, oper_LSB };
            PC <= { rd_data, oper_LSB };
          end

          default: begin
            address <= 16'hFFFF;
            PC <= 16'hFFFF;
          end
        endcase // case ( IR )
      end

      default: begin end
    endcase // case ( 1'b1 )

  end // block: INSTRUCTION_CYCLE

  always @(*) begin: OPCODE_DECODER
  // The contents of the instruction register are decoded to determine the next
  // state that the state machine will transition to, which in turn determines
  // the number of additional operands that will need to be read from memory.

    dec_opcode = EMPTY;

    case ( IR )

      ADC: begin
        dec_opcode[FETCH] = 1'b1;
      end

      NOP: begin
        dec_opcode[FETCH] = 1'b1;
      end

      JMP: begin
        dec_opcode[EXECUTE] = 1'b1;
      end

      LDA: begin
        dec_opcode[FETCH] = 1'b1;
      end

      default: begin
        dec_opcode = EMPTY;  // Obvious indicator of failure to decode
      end
    endcase // case ( IR )

  end // block: OPCODE_DECODER

endmodule // proc

  // always @(*) begin: ALU_INPUT_MUX_A

  //   case ( alu_input_select_A )

  //     select_X: begin
  //       alu_AI = X;
  //     end

  //     select_Y: begin
  //       alu_AI = Y;
  //     end

  //     select_A: begin
  //       alu_AI = A;
  //     end

  //     default: begin end
  //   endcase // case ( alu_input_select_A )
  // end

  // always @(*) begin: ALU_INPUT_MUX_B

  //   case ( alu_input_select_B )

  //     select_X: begin
  //       alu_BI = X;
  //     end

  //     select_Y: begin
  //       alu_BI = Y;
  //     end

  //     select_A: begin
  //       alu_BI = A;
  //     end

  //     default: begin end
  //   endcase // case ( alu_input_select_B )
  // end

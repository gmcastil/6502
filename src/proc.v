// ----------------------------------------------------------------------------
// Module:  proc.v
// Project: MOS 6502 Processor
// Author:  George Castillo <gmcastil@gmail.com>
// Date:    09 July 2017
//
// Description: Main module for the MOS 6502 processor core.
// ----------------------------------------------------------------------------

module proc
  (
   input         clk,
   input         resetn,
   input [7:0]   rd_data,

   output reg [15:0] address
   );

  localparam RESET     = 0;
  localparam VECTOR_1  = 1;
  localparam VECTOR_2  = 2;
  localparam VECTOR_3  = 3;
  localparam FETCH_1   = 4;
  localparam FETCH_2   = 5;
  localparam EXECUTE   = 6;
  localparam DECODE    = 7;
  localparam OPER_A1   = 8;
  localparam OPER_B1   = 9;
  localparam OPER_A2   = 10;

  localparam EMPTY     = 11'b0;  // Zero out the state vector more explicitly

  localparam RESET_LSB = 16'hFFFC;
  localparam RESET_MSB = 16'hFFFD;

  reg [10:0]     next;
  reg [10:0]     state;
  reg [10:0]     dec_opcode;

  reg [15:0]     PC;  // program counter
  reg [7:0]      IR;  // instruction register

  reg [7:0]      oper_LSB;  // first operand
  reg [7:0]      oper_MSB;  // second operand

  // --- Opcode Definitions
  localparam NOP = 8'hEA;
  localparam JMP = 8'h4C;

// synthesis translate_off
    reg [(8*11)-1:0] state_ascii;
    always @(*) begin
     
      case (state)
        11'b000000000001: state_ascii <= "   RESET";
        11'b000000000010: state_ascii <= "VECTOR_1";
        11'b000000000100: state_ascii <= "VECTOR_2";
        11'b000000001000: state_ascii <= "VECTOR_3";
        11'b000000010000: state_ascii <= " FETCH_1";
        11'b000000100000: state_ascii <= " FETCH_2";
        11'b000001000000: state_ascii <= " EXECUTE";
        11'b000010000000: state_ascii <= "  DECODE";
        11'b000100000000: state_ascii <= " OPER_A1";
        11'b001000000000: state_ascii <= " OPER_B1";
        11'b010000000000: state_ascii <= " OPER_A2";
      endcase
    end
  
  // synthesis translate_on

  always @(posedge clk) begin
    if (!resetn == 1'b1) begin
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
        next[FETCH_1] = 1'b1;
      end

      state[FETCH_1]: begin
        next[FETCH_2] = 1'b1;
      end

      state[FETCH_2]: begin
        next[DECODE] = 1'b1;
      end

      state[DECODE]: begin
        // This state machine transition is a little different than the others,
        // since the next state is dependent upon the decoded value of the
        // IR which was read from during the FETCH cycles
        next = dec_opcode;
      end

      state[OPER_A1]: begin
        next[OPER_A2] = 1'b1;
      end

      state[OPER_B1]: begin
        next[EXECUTE] = 1'b1;
      end

      state[OPER_A2]: begin
        next[EXECUTE] = 1'b1;
      end

      state[EXECUTE]: begin
        next[FETCH_1] = 1'b1;
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
        PC[15:8] <= rd_data;
      end

      state[FETCH_1]: begin
        address <= PC;
      end

      state[FETCH_2]: begin
        IR <= rd_data;
      end

      state[DECODE]: begin
        // Pipeline the read of the first operand - if the decoded opcode does
        // not require additional operands, the value will be ignored
        address <= PC + 16'b1;
      end

      state[OPER_A1]: begin
        address <= PC + 16'b1 + 16'b1;
        oper_LSB <= rd_data;
      end

      state[OPER_A2]: begin
        oper_MSB <= rd_data;
      end

      state[OPER_B1]: begin
        oper_LSB <= rd_data;
      end

      state[EXECUTE]: begin

        case (IR)

          NOP: begin
            PC <= PC + 16'b1;
          end

          JMP: begin
            PC <= {oper_MSB, oper_LSB};
          end
        endcase // case (IR)
      end

      default: begin end
    endcase // case (1'b1)

  end // block: INSTRUCTION_CYCLE


  // The contents of the instruction register are decoded to determine the next
  // state that the state machine will transition to, which in turn determines
  // the number of additional oeprands that will need to be read from memory.
  always @(*) begin: OPCODE_DECODER

    dec_opcode = EMPTY;

    case (IR)

      NOP: begin
        dec_opcode[EXECUTE] = 1'b1;
      end

      JMP: begin
        dec_opcode[OPER_A1] = 1'b1;
      end

    endcase // case (IR)

  end // block: OPCODE_DECODER

endmodule // proc

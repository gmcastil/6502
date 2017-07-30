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
   output reg        alu_BCD
   );

  // --- Processor Registers
  reg [7:0]          A;   // accumulator
  reg [7:0]          X;   // X index register
  reg [7:0]          Y;   // Y index register
  reg [8:0]          S;   // stack pointer
  reg [15:0]         PC;  // program counter
  reg [7:0]          IR;  // instruction register
  reg [7:0]          P;   // processor status register

  // --- Indices Into Processor Status Register (shared with ALU)
  localparam NEG       = 7;
  localparam OVF       = 6;
  localparam UNUSED    = 5;
  localparam BREAK     = 4;
  localparam BCD       = 3;
  localparam IRQ       = 2;
  localparam ZERO      = 1;
  localparam CARRY     = 0;

  // --- ALU Control and Mux Signals
  localparam SUM = 3'b000;
  localparam OR  = 3'b001;
  localparam XOR = 3'b010;
  localparam AND = 3'b011;
  localparam SR  = 3'b100;
  localparam SL  = 3'b101;

  // --- Reset and IRQ Vectors
  localparam RESET_LSB = 16'hFFFC;
  localparam RESET_MSB = 16'hFFFD;

  // --- State Machine Indices
  localparam RESET     = 0;
  localparam VECTOR_1  = 1;
  localparam VECTOR_2  = 2;
  localparam FETCH     = 3;
  localparam DECODE    = 4;

  // Absolute addressing mode
  localparam ABS_1     = 5;
  localparam ABS_2     = 6;
  localparam ABS_3     = 7;
  localparam ABS_4     = 8;
  // More to come...

  localparam EMPTY = 256'b0;

  // State register definition - for now, we'll make this big
  reg [255:0]        state;
  reg [255:0]        next;

  // --- Miscellaneous Signals

  // This is used to identify which values need to be updated with the result
  // from the ALU after execution of an instruction:
  //
  // Format:  11 - A
  //          10 - X
  //           9 - Y
  //           8 - S
  //         7-0 - P
  //
  // Initialized to zero and a 1 indicates an update needs to be made to that
  // particular register or status flag.
  //
  reg [11:0]         update_flags;

  // Also create some masks for each instruction to avoid a need to manually
  // encode them for each opcode
  localparam ADC_MASK = 12'b1000_1100_0011;
  localparam ORA_MASK = 12'b0000_1000_0010;
  localparam AND_MASK = 12'b0000_1000_0010;
  localparam ASL_MASK = 12'b1000_1000_0011;

  reg [7:0]          operand_LSB;
  reg [7:0]          operand_MSB;

  // --- Reset and Initialization
  always @(posedge clk) begin
    if ( resetn == 1'b0 ) begin
      state <= EMPTY;
      state[RESET] <= 1'b1;

      // Initialize index and status registers
      X <= 8'b0;
      Y <= 8'b0;
      P <= 8'b0;
      P[UNUSED] <= 1'b1;
      // Initialize the stack pointer in case the programmer forgets
      S <= { 1'b1, 8'hFF };

      // Initialize the flag register used to determine what to update
      // after an instruction has been executed
      update_flags <= 12'b0;

      // Finally, pipeline the reset vector
      address <= RESET_LSB;

    end else begin
      state <= next;
    end
  end

  // --- State Machine Definition
  always @(*) begin: STATE_MACHINE

    // Each of the various addressing modes has a different path through the
    // state machine.  The ADDR_MODE_DECODER is used to determine which branch
    // to take in the DECODE state and additional checks are made in the
    // following states depending upon the instruction being executed.

    next = EMPTY;

    case ( state )

      state[RESET]: begin
        next[VECTOR_1] = 1'b1;
      end

      state[VECTOR_1]: begin
        next[VECTOR_2] = 1'b1;
      end

      state[VECTOR_2]: begin
        next[FETCH] = 1'b1;
      end

      state[FETCH]: begin
        next[DECODE] = 1'b1;
      end

      state[DECODE]: begin
        next[decoded_state] = 1'b1;
      end

      state[ABS_1]: begin
        // 3 cycle instructions
        if ( IR == JMP ) begin
          next[FETCH] = 1'b1;
        end else begin
          next[ABS_2] = 1'b1;
        end
      end

      state[ABS_2]: begin
        if ( IR == ASL_abs ) begin
          next[ABS_3] = 1'b1;
        // 4 cycle instructions
        end else begin
          next[FETCH] = 1'b1;
        end
      end

      state[ABS_3]: begin
        next[ABS_4] = 1'b1;
      end

      state[ABS_4]: begin
        // 6 cycle instructions
        next[FETCH] = 1'b1;
      end

      default: begin end
    endcase // case ( state )

  end // block: STATE_MACHINE

  always @(posedge clk) begin: INSTRUCTION_CYCLE

    case ( 1'b1 )

      state[VECTOR_1]: begin
        address <= RESET_MSB;
        PC[7:0] <= rd_data;
      end

      state[VECTOR_2]: begin
        address <= { rd_data, PC[7:0] };
        PC[15:8] <= rd_data;
      end

      state[FETCH]: begin
        address <= PC + 16'd1;
        IR <= rd_data;
        if (update_flags != 12'd0) begin
          // Update appropriate values from the ALU
        end
      end

      state[DECODE]: begin

        operand_LSB <= rd_data;  // Read PC + 1

        case ( IR )

          ADC_abs,
          AND_abs,
          ASL_abs,
          BIT_abs,
          ORA_abs: begin
            address <= PC + 16'd2;
          end

          default: begin end
        endcase // case ( IR )

      end

      // Absolute addressing mode transitions
      state[ABS_1]: begin

        operand_MSB <= rd_data;  // Read PC + 2

        case ( IR )

          ADC_abs,
          AND_abs,
          ASL_abs,
          BIT_abs,
          ORA_abs: begin
            address <= { rd_data, operand_LSB };
          end

          default: begin end
        endcase // case ( IR )

      end

      state[ABS_2]: begin

        case ( IR )

          ADC_abs: begin
            PC <= PC + 16'd2;
            address <= PC + 16'd2;

            alu_AI <= A;
            alu_BI <= rd_data;
            alu_ctrl <= SUM;
            alu_carry <= P[CARRY];

            update_flags <= ADC_UPDATE_MASK;
          end

          AND_abs: begin
            PC <= PC + 16'd2;
            address <= PC + 16'd2;

            alu_AI <= A;
            alu_BI <= rd_data;
            alu_ctrl <= AND;

            update_flags <= AND_UPDDATE_MASK;
          end

          ASL_abs: begin
            // For some reason, left and right shifts require six clock cycles
            // rather than four, so stall a couple clocks before muxing the
            // output of the ALU
            alu_AI <= rd_data;
          end


          // BIT sets the Z flag as though the value in the address tested were
          // ANDed with the accumulator. The S and V flags are set to match bits
          // 7 and 6 respectively in the value stored at the tested address.
          BIT_abs: begin
            PC <= PC + 16'd2;
            address <= PC + 16'd2;

            alu_AI <= A;
            alu_BI <= rd_data;
            alu_ctrl <= AND;

          end

          ORA_abs: begin
            PC <= PC + 16'd2;
            address <= PC + 16'd2;

            alu_AI <= A;
            alu_BI <= rd_data;
            alu_ctrl <= OR;

            update_flags <= ORA_UPDATE_MASK;
          end

          default: begin end
        endcase // case ( IR )

      end

      state[ABS_3]: begin
      end

      state[ABS_4]: begin

        case ( IR )

          ASL_abs: begin
            PC <= PC + 16'd2;
            address <= PC + 16'd2;

            alu_ctrl <= SL;
            update_flags <= ASL_UPDATE_MASK;
          end

          default: begin end
        endcase // case ( IR )

      end

  end // block: INSTRUCTION_CYCLE




  always @(*) begin: ADDR_MODE_DECODER

    // The contents of the instruction register are decoded to determine the
    // path through the state machine, which in turn determines the number of
    // additional operands that need to be read from memory

    case ( IR )

      ADC_abs,  // X
      AND_abs,  // X
      ASL_abs,  // X
      BIT_abs,
      CMP_abs,
      CPX_abs,
      CPY_abs,
      DEC_abs,
      EOR_abs,
      INC_abs,
      JMP_abs,
      JSR_abs,
      LDA_abs,
      LDX_abs,
      LDY_abs,
      LSR_abs,
      ORA_abs,  // X
      ROL_abs,
      ROR_abs,
      SBC_abs,
      STA_abs,
      STX_abs,
      STY_abs,
      STZ_abs,
      TRB_abs,
      TSB_abs: begin
        decoded_state = ABS_1;
      end

      default: begin end
    endcase // case ( IR )

  end // block: ADDR_MODE_DECODER

endmodule // proc




  /* Commenting all of this out while we revamp everything, but I want to keep it
     around for easy reference

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
  reg [8:0]     S;   // stack pointer
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
  localparam AND     = 8'h29; //

  reg [7:0]     oper_LSB;  // first operand
  wire          msb_rd_data;

  // --- Reset and IRQ Vectors
  localparam RESET_LSB = 16'hFFFC;
  localparam RESET_MSB = 16'hFFFD;

  reg [6:0]     dec_opcode;

  // --- ALU Control and Mux Signals
  localparam SUM = 3'b000;
  localparam OR  = 3'b001;
  localparam XOR = 3'b010;
  localparam AND = 3'b011;
  localparam SR  = 3'b100;

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

  reg [(8*3)-1:0] IR_ascii;
  always @(*) begin

    case ( IR )
      8'h29: IR_ascii <= "AND";
      8'h69: IR_ascii <= "ADC";
      8'hEA: IR_ascii <= "NOP";
      8'h4C: IR_ascii <= "JMP";
      8'hA9: IR_ascii <= "LDA";
    endcase

  end
  // synthesis translate_on

  // --- Reset Logic
  always @(posedge clk) begin
    if ( resetn == 1'b0 ) begin
      state <= EMPTY;
      state[RESET] <= 1'b1;

      update_accumulator <= 1'b0;

      X <= 8'b0;
      Y <= 8'b0;
      P <= 8'b0;
      S <= { 1'b1, 8'hFF };

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

          ADC_imm: begin
            PC <= PC + 16'd2;
            address <= PC + 16'd2;

            alu_ctrl <= ALU_SUM;
            alu_AI <= A;
            alu_BI <= rd_data;
            alu_carry <= P[CARRY];
            alu_BCD <= P[BCD];

            update_accumulator <= 1'b1;
          end

          ADC_abs: begin
            PC <= PC + 16'd

          AND: begin
            PC <= PC + 16'd2;
            address <= PC + 16'd2;

            alu_ctrl <= AND;
            alu_AI <= A;
            alu_BI <= rd_data;

            update_accumulator <= 1'b1;
          end

          NOP: begin
            PC <= PC + 16'd1;
            address <= PC + 16'd1;
          end

          JMP: begin
            address <= PC + 16'd2;
          end

          LDA: begin
            PC      <= PC + 16'd2;
            address <= PC + 16'd2;
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

      ADC_imm: begin
        dec_opcode[FETCH] = 1'b1;
      end

      AND: begin
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

      ORA_imm: begin
        dec_opcode[FETCH] = 1'b1;
      end

      default: begin
        dec_opcode = EMPTY;  // Obvious indicator of failure to decode
      end
    endcase // case ( IR )

  end // block: OPCODE_DECODER

endmodule // proc

   */

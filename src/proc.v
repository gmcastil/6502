// ----------------------------------------------------------------------------
// Module:  proc.v
// Project: MOS 6502 Processor
// Author:  George Castillo <gmcastil@gmail.com>
// Date:    09 July 2017
//
// Description: Main module for the MOS 6502 processor core.
// ----------------------------------------------------------------------------

`include "./includes/opcodes.vh"
`include "./includes/params.vh"

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

  // There are some special instructions involving the ALU that use the results
  // from the ALU in an abnormal way.  When these signals are true, the setting
  // of the processor status flags will need to be micromanaged a bit, using the
  // signals from the ALU.  Such is the price of pipelining.
  reg                update_bit;
  reg                update_compare;

  // Also create some masks for each instruction to avoid a need to manually
  // encode them for each opcode
  localparam ADC_UPDATE_MASK = 12'b1000_1100_0011;
  localparam ORA_UPDATE_MASK = 12'b0000_1000_0010;
  localparam AND_UPDATE_MASK = 12'b0000_1000_0010;
  localparam ASL_UPDATE_MASK = 12'b1000_1000_0011;
  localparam EOR_UPDATE_MASK = 12'b1000_1000_0010;

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
      // This one should be perpetually stuck high
      P[UNUSED] <= 1'b1;
      // Initialize the stack pointer in case the programmer forgets
      S <= { 1'b1, 8'hFF };

      // Initialize the flag register used to determine what to update
      // after an instruction has been executed
      update_flags <= 12'b0;
      // Also, clear these special bits too
      update_bit <= 1'b0;
      update_compare <= 1'b0;

      // Finally, pipeline the reset vector - no point in waiting
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
        if ( condition ) begin
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
          // Update appropriate values from the ALU and other weirdness from
          // special instructions that modify the P status flags in odd ways

          // Also, don't forget to clear all these out after doing their
          // business
        end
      end

      state[DECODE]: begin

        operand_LSB <= rd_data;  // Read PC + 1

        case ( IR )

          ADC_abs,
          AND_abs,
          ASL_abs,
          BIT_abs,
          CMP_abs,
          DEC_abs,
          EOR_abs,
          ORA_abs: begin
            address <= PC + 16'd2;
          end

          default: begin end
        endcase // case ( IR )

      end

      // Absolute addressing mode transitions
      state[ABS_1]: begin

        operand_MSB <= rd_data;

        case ( IR )

          ADC_abs,
          AND_abs,
          ASL_abs,
          BIT_abs,
          CMP_abs,
          DEC_abs,
          EOR_abs,
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
            alu_ctrl <= ADD;
            alu_carry <= P[CARRY];

            update_flags <= ADC_UPDATE_MASK;
          end

          AND_abs: begin
            PC <= PC + 16'd2;
            address <= PC + 16'd2;

            alu_AI <= A;
            alu_BI <= rd_data;
            alu_ctrl <= AND;

            update_flags <= AND_UPDATE_MASK;
          end

          ASL_abs: begin
            alu_AI <= rd_data;
            alu_ctrl <= SL;
          end

          BIT_abs: begin
            PC <= PC + 16'd2;
            address <= PC + 16'd2;

            alu_AI <= A;
            alu_BI <= rd_data;
            alu_ctrl <= AND;

            update_bit <= 1'b1;
          end

          CMP_abs: begin
            PC <= PC + 16'd2;
            address <= PC + 16'd2;

            alu_AI <= A;
            alu_BI <= rd_data;
            alu_ctrl <= SUB;

            update_compare <= 1'b1;
          end

          DEC_abs: begin
            PC <= PC + 16'd2;
            address <= PC + 16'd2;
            // This opcode is not working yet
          end

          EOR_abs: begin
            PC <= PC + 16'd2;
            address <= PC + 16'd2;

            alu_AI <= A;
            alu_BI <= rd_data;
            alu_ctrl <= XOR;

            update_flags = XOR_UPDATE_MASK;
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

        case ( IR )

          ASL_abs: begin
            wr_data <= alu_Y;
            wr_enable <= 1'b1;

            // Address to store it to on the next clock cycle
            address <= { operand_MSB, operand_LSB };
            update_flags = ASL_UPDATE_MASK;
          end

          default: begin end
        endcase // case ( IR )

      end

      state[ABS_4]: begin

        case ( IR )

          ASL_abs: begin
            PC <= PC + 16'd2;
            address <= PC + 16'd2;
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
      EOR_abs,  // X
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

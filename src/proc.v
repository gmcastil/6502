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
   input             clk,
   input             resetn,
   input [7:0]       rd_data,

   output reg [15:0] address,
   output reg [7:0]  wr_data,
   output reg        wr_enable
   );

`include "./includes/opcodes.vh"
`include "./includes/params.vh"

   // --- ALU Connections
  reg [2:0]          alu_control;
  reg [7:0]          alu_AI;
  reg [7:0]          alu_BI;
  reg                alu_carry_in;
  reg [7:0]          alu_Y;
  reg                alu_carry_out;
  reg                alu_overflow;

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

  localparam ERROR     = 31;

  // More to come...

  localparam EMPTY     = 32'd0;
  localparam MSB       = 7;
  localparam LSB       = 0;

  // State register definition - for now, we'll make this big
  reg [31:0]        state;
  reg [31:0]        next;

 `include "./includes/ascii.vh"

  // --- Other Signals
  reg [7:0]          operand_LSB;
  reg [7:0]          operand_MSB;

  // Accumulator and processor status updates
  reg                update_accumulator_flag;
  reg [7:0]          updated_status;
  reg [7:0]          updated_accumulator;

  // Opcodes get decoded and the appropriate next state index selected during
  // the DECODE state
  reg [31:0]         decoded_state;

  // --- Reset and Initialization
  always @(posedge clk) begin
    if ( resetn == 1'b0 ) begin
      state <= EMPTY;
      state[RESET] <= 1'b1;

      // Initialize index and status registers
      X <= 8'b0;
      Y <= 8'b0;

      // Initialize processor status flags
      P <= 8'b0;
      // This one should be perpetually stuck high
      P[UNUSED] <= 1'b1;

      // Initialize the stack pointer in case the programmer forgets
      S <= { 1'b1, 8'hFF };

      // Also, clear these special control bits too
      update_accumulator_flag <= 1'b0;
      updated_status <= 8'b0
      decoded_state <= 0;

      // Finally, pipeline the reset vector - no point in waiting
      address <= RESET_LSB;
    end else begin
      state <= next;
    end // else: !if( resetn == 1'b0 )
  end // always @ (posedge clk)

  // --- State Machine Definition
  always @(*) begin: STATE_MACHINE

    // Each of the various addressing modes has a different path through the
    // state machine.  The ADDR_MODE_DECODER is used to determine which branch
    // to take in the DECODE state and additional checks are made in the
    // following states depending upon the instruction being executed.

    next = EMPTY;

    case ( 1'b1 )

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

      // --- Absolute Addressing Mode
      state[ABS_1]: begin
        // 3-cycle instructions return
        if ( IR == JMP_abs ) begin
          next[FETCH] = 1'b1;
        // 4 and 6-cycle instructions continue
        end else begin
          next[ABS_2] = 1'b1;
        end
      end

      state[ABS_2]: begin

        case ( IR )

          // 6-cycle instructions continue
          ASL_abs,
          DEC_abs,
          INC_abs,
          LSR_abs,
          ROL_abs,
          ROR_abs: begin
            next[ABS_3] = 1'b1;
          end

          // 4-cycle instructions return - not sure this is right
          default: begin
            next[FETCH] = 1'b1;
          end
        endcase
      end

      state[ABS_3]: begin
        next[ABS_4] = 1'b1;
      end

      state[ABS_4]: begin
        // 6 cycle instructions return
        next[FETCH] = 1'b1;
      end

      state[ERROR]: begin
        next[ERROR] = 1'b1;
      end

      default: begin end
    endcase // case ( state )

  end // block: STATE_MACHINE

  // --- Instruction Cycle Description
  always @(posedge clk) begin: INSTRUCTION_CYCLE

    // Defines instruction execution, interaction with address and data bus,
    // manipulation of the program counter, and all other processor operations.
    // Note that other than manipulation of the program counter and address
    // values, arithmetic operations are all routed through the ALU.

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

        // Processor status register is updated after every instruction but
        // determined using a combinational logic block
        P <= updated_status;

        // With some instructions, the accumulator is updated directly.  In
        // other instances it is updated from another logic block
        if (update_accumulator_flag == 1'b1) begin
          A <= updated_accumulator;
          update_accumulator_flag <= 1'b0;
        end
      end

      state[DECODE]: begin

        // Always read the next byte from memory and then decide what to do with
        // it in the next state (this can include doing nothing with it)
        operand_LSB <= rd_data;

        case ( IR )

          // absolute addressing mode
          ADC_abs,
          AND_abs,
          ASL_abs,
          BIT_abs,
          CMP_abs,
          CPX_abs,
          CPY_abs,
          DEC_abs,
          EOR_abs,
          INC_abs,
          LDA_abs,
          LDX_abs,
          LDY_abs,
          LSR_abs,
          ORA_abs,
          ROL_abs,
          ROR_abs,
          SBC_abs,
          STA_abs,
          STX_abs,
          STY_abs: begin
            address <= PC + 16'd2;
          end

          // 3 cycle absolute addressing mode
          JMP_abs: begin
            address <= PC + 16'd2;
          end

          // 2-cycle implied addressing mode
          CLC_imp,
          CLV_imp,
          NOP_imp,
          SEC_imp: begin
            address <= PC + 16'd1;
            PC <= PC + 16'd1;
          end

          // -- Immediate Addressing Mode (2-cycle)
          LDA_imm: begin
            address <= PC + 16'd2;
            PC <= PC + 16'd2;
            A <= rd_data;
          end

          LDX_imm: begin
            address <= PC + 16'd2;
            PC <= PC + 16'd2;
            X <= rd_data;
          end

          LDY_imm: begin
            address <= PC + 16'd2;
            PC <= PC + 16'd2;
            Y <= rd_data;
          end

          // -- Accumulator Addressing Mode
          ASL_acc: begin
            address <= PC + 16'd1;
            PC <= PC + 16'd1;
            alu_AI <= A;
            alu_BI <= A;
            alu_carry_in <= P[CARRY];
            alu_control <= ADD;
            update_accumulator_flag <= 1'b1;
          end

          LSR_acc: begin
            address <= PC + 16'd1;
            PC <= PC + 16'd1;
            alu_AI <= A;
            alu_carry_in <= 1'b0;
            alu_control <= SR
            update_accumulator_flag <= 1'b1;
          end

          ROL_acc: begin
            address <= PC + 16'd1;
            PC <= PC + 16'd1;
            alu_AI <= A;
            alu_BI <= A;
            alu_carry_in <= P[CARRY];
            alu_control <= ADD;
            update_accumulator_flag <= 1'b1;
          end

          ROR_acc: begin
            address <= PC + 16'd1;
            PC <= PC + 16'd1;
            alu_AI <= A;
            alu_carry_in <= P[CARRY];
            alu_control <= SR;
            update_accumulator_flag <= 1'b1;
          end

          default: begin end
        endcase // case ( IR )

      end // case: state[DECODE]

      // -- Absolute Addressing Mode
      state[ABS_1]: begin

        operand_MSB <= rd_data;

        case ( IR )

          ADC_abs,
          AND_abs,
          ASL_abs,
          BIT_abs,
          CMP_abs,
          CPX_abs,
          CPY_abs,
          DEC_abs,
          EOR_abs,
          INC_abs,
          LDA_abs,
          LDX_abs,
          LDY_abs,
          LSR_abs,
          ORA_abs,
          ROL_abs,
          ROR_abs,
          SBC_abs: begin
            address <= { rd_data, operand_LSB };
<          end // case: ADC_abs,...

          STA_abs: begin
            address <= { rd_data, operand_LSB };
            wr_data <= A;
            wr_enable <= 1'b1;
          end

          STX_abs: begin
            address <= { rd_data, operand_LSB };
            wr_data <= X;
            wr_enable <= 1'b1;
          end

          STY_abs: begin
            address <= { rd_data, operand_LSB };
            wr_data <= Y;
            wr_enable <= 1'b1;
          end

          JMP_abs: begin
            address <= { rd_data, operand_LSB };
            PC <= { rd_data, operand_LSB };
          end

          default: begin end
        endcase // case ( IR )

      end // case: state[ABS_1]

      state[ABS_2]: begin

        case ( IR )

          ADC_abs: begin
            PC <= PC + 16'd3;
            address <= PC + 16'd3;

            alu_AI <= A;
            alu_BI <= rd_data;
            alu_control <= ADD;
            alu_carry <= P[CARRY];

            update_accumulator_flag <= 1'b1;
          end

          AND_abs: begin
            PC <= PC + 16'd3;
            address <= PC + 16'd3;

            alu_AI <= A;
            alu_BI <= rd_data;
            alu_control <= AND;

            update_accumulator_flag <= 1'b1;
          end

          ASL_abs: begin
            alu_AI <= rd_data;
            alu_BI <= rd_data;
            alu_control <= ADD;
            alu_carry_in <= P[CARRY];
          end

          BIT_abs: begin
            PC <= PC + 16'd3;
            address <= PC + 16'd3;

            alu_AI <= A;
            alu_BI <= rd_data;
            alu_control <= AND;

            // BIT instruction affects only processor status register and does
            // not touch memory or the accumulator - explicitly ignore it here
            update_accumulator_flag <= 1'b0;
          end

          CMP_abs: begin
            PC <= PC + 16'd3;
            address <= PC + 16'd3;

            alu_AI <= A;
            alu_BI <= twos_complement(rd_data);
            alu_control <= ADD;

            // CMP instruction affects only processor status register and does
            // not touch memory or the accumulator - explicitly ignore it here
            update_accumulator_flag <= 1'b0;
          end

          CPX_abs: begin
            PC <= PC + 16'd3;
            address <= PC + 16'd3;

            alu_AI <= X;
            alu_BI <= twos_complement(rd_data);
            alu_control <= ADD;

            // CPX instruction affects only processor status register and does
            // not touch memory or the accumulator - explicitly ignore it here
            update_accumulator_flag <= 1'b0;
          end

          CPY_abs: begin
            PC <= PC + 16'd3;
            address <= PC + 16'd3;

            alu_AI <= Y;
            alu_BI <= twos_complement(rd_data);
            alu_control <= ADD;

            // CPY instruction affects only processor status register and does
            // not touch memory or the accumulator - explicitly ignore it here
            update_accumulator_flag <= 1'b0;
          end // case: CPY_abs

          DEC_abs: begin
            alu_AI <= rd_data;
            alu_BI <= twos_complement(8'd1);
            alu_control <= ADD;
          end

          EOR_abs: begin
            PC <= PC + 16'd3;
            address <= PC + 16'd3;

            alu_AI <= A;
            alu_BI <= rd_data;
            alu_control <= XOR;

            update_accumulator_flag <= 1'b1;
          end

          INC_abs: begin
            alu_AI <= rd_data;
            alu_BI <= 8'd1;
            alu_control <= ADD;
          end

          LDA_abs: begin
            PC <= PC + 16'd3;
            address <= PC + 16'd3;

            A <= rd_data;
          end

          LDX_abs: begin
            PC <= PC + 16'd3;
            address <= PC + 16'd3;

            X <= rd_data;
          end

          LDY_abs: begin
            PC <= PC + 16'd3;
            address <= PC + 16'd3;

            Y <= rd_data;
          end

          LSR_abs: begin
            alu_AI <= rd_data;
            alu_control <= SL;
          end

          ORA_abs: begin
            PC <= PC + 16'd3;
            address <= PC + 16'd3;

            alu_AI <= A;
            alu_BI <= rd_data;
            alu_control <= OR;

            update_accumulator_flag <= 1'b1;
          end

          ROL_abs: begin
            alu_AI <= rd_data;
            alu_control <= SL;
          end

          ROR_abs: begin
            alu_AI <= rd_data;
            alu_control <= SR;
          end

          SBC_abs: begin
            PC <= PC + 16'd3;
            address <= PC + 16'd3;

            alu_AI <= A;
            alu_BI <= twos_complement(rd_data);
            alu_control <= ADD;

            update_accumulator_flag <= 1'b1;
          end

          STA_abs: begin
            PC <= PC + 16'd3;
            address <= PC + 16'd3;

            wr_enable <= 1'b0;
          end

          default: begin end
        endcase // case ( IR )

      end // case: state[ABS_2]

      state[ABS_3]: begin

        case ( IR )

          ASL_abs: begin
            wr_data <= alu_Y;
            wr_enable <= 1'b1;

            // Address to store the result to on the next clock cycle
            address <= { operand_MSB, operand_LSB };
          end

          DEC_abs,
          INC_abs: begin
            wr_data <= alu_Y;
            wr_enable <= 1'b1;

            // Address to store the result to on the next clock cycle
            address <= { operand_MSB, operand_LSB };
          end

          LSR_abs: begin
            wr_data <= alu_Y;
            wr_enable <= 1'b1;

            // Address to store the result to on the next clock cycle
            address <= { operand_MSB, operand_LSB };
          end

          ROL_abs: begin
            wr_data <= alu_Y;
            wr_enable <= 1'b1;

            address <= { operand_MSB, operand_LSB };
          end

          ROR_abs: begin
            wr_data <= alu_Y;
            wr_enable <= 1'b1;

            address <= { operand_MSB, operand_LSB };
          end

          default: begin end
        endcase // case ( IR )

      end // case: state[ABS_3]

      state[ABS_4]: begin

        case ( IR )

          ASL_abs: begin
            PC <= PC + 16'd3;
            address <= PC + 16'd3;
            wr_enable <= 1'b0;
          end

          DEC_abs,
          INC_abs: begin
            PC <= PC + 16'd3;
            address <= PC + 16'd3;
            wr_enable <= 1'b0;
          end

          LSR_abs: begin
            PC <= PC + 16'd3;
            address <= PC + 16'd3;
            wr_enable <= 1'b0;
          end

          ROL_abs,
          ROR_abs: begin
            PC <= PC + 16'd3;
            address <= PC + 16'd3;
            wr_enable <= 1'b0;
          end

          default: begin end
        endcase // case ( IR )

      end // case: state[ABS_4]

    endcase // case ( 1'b1 )
  end // block: INSTRUCTION_CYCLE

  // --- Address Mode Decoder
  always @(*) begin: ADDR_MODE_DECODER

    // The contents of the instruction register are decoded to determine the
    // path through the state machine, which in turn determines the number of
    // additional operands that need to be read from memory

    case ( IR )

      // -- Absolute Addressing Mode
      ADC_abs,
      AND_abs,
      ASL_abs,
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
      ORA_abs,
      ROL_abs,
      ROR_abs,
      SBC_abs,
      STA_abs,
      STX_abs,
      STY_abs: begin
        decoded_state = ABS_1;
      end

      // -- Implied Addressing Mode
      CLC_imp,
      CLV_imp,
      NOP_imp,
      SEC_imp: begin
        decoded_state = FETCH;
      end

      // -- Immediate Addressing Mode
      LDA_imm,
      LDX_imm,
      LDY_imm: begin
        decoded_state = FETCH;
      end

      // -- Accumulator Addressing Mode
      ASL_acc,
      LSR_acc,
      ROL_acc,
      ROR_acc: begin
        decoded_state = FETCH;
      end

      default: begin
        decoded_state = ERROR;
      end
    endcase // case ( IR )

  end // block: ADDR_MODE_DECODER

  // --- Processor Status Update
  always @(*) begin: PROCESSOR_STATUS_UPDATE

    // Processor status register will be updated when in the FETCH state.

    updated_status = P;

    case ( IR )

      // -- Immediate Addressing mode
      LDA_imm: begin
        updated_status[NEG] = A[MSB];
        updated_status[ZERO] = ~|A;
      end

      LDX_imm: begin
        updated_status[NEG] = X[MSB];
        updated_status[ZERO] = ~|X;
      end

      LDY_imm: begin
        updated_status[NEG] = Y[MSB];
        updated_status[ZERO] = ~|Y;
      end

      // -- Absolute Addressing Mode
      ADC_abs: begin
        updated_status[NEG] = A[MSB];
        updated_status[ZERO] = ~|A;
        updated_status[OVF] = alu_overflow;
        updated_status[CARRY] = alu_carry_out;
      end

      AND_abs: begin
        updated_status[NEG] = A[MSB];
        updated_status[ZERO] = ~|A;
      end

      ASL_abs: begin
        updated_status[NEG] = alu_Y[MSB];
        updated_status[ZERO] = ~|alu_Y;
        updated_status[CARRY] = alu_carry_out;
      end

      BIT_abs: begin
        // Negative flag comes from high bit of operand provided to ALU
        updated_status[NEG] = rd_data[7];
        // Zero flag is normal, but with accumulator and memory unaffected
        updated_status[ZERO] = ~|rd_data;
        // Overflow flag comes from next highest bit of operand provided to ALU
        updated_status[OVF] = rd_data[6];
      end

      CMP_abs: begin
        updated_status[NEG] = alu_Y[MSB];
        updated_status[ZERO] = ~|alu_Y;
        if (A >= alu_Y) begin
          updated_status[CARRY] = 1'b1;
        end else begin
          updated_status[CARRY] = 1'b0;
        end
      end

      CPX_abs: begin
        updated_status[NEG] = alu_Y[MSB];
        updated_status[ZERO] = ~|alu_Y;
        updated_status[CARRY] =
        if (X >= alu_Y) begin
          updated_status[CARRY] = 1'b1;
        end else begin
          updated_status[CARRY] = 1'b0;
        end
      end

      CPY_abs: begin
        updated_status[NEG] = alu_Y[MSB];
        updated_status[ZERO] = ~|alu_Y;
        updated_status[CARRY] =
        if (Y >= alu_Y) begin
          updated_status[CARRY] = 1'b1;
        end else begin
          updated_status[CARRY] = 1'b0;
        end
      end

      DEC_abs: begin
        updated_status[NEG] = alu_Y[MSB];
        updated_status[ZERO] = ~|alu_Y;
      end

      EOR_abs: begin
        updated_status[NEG] = A[MSB];
        updated_status[ZERO] = ~|A;
      end

      INC_abs: begin
        updated_status[NEG] = alu_Y[MSB];
        updated_status[ZERO] = ~|alu_Y;
      end

      LDA_abs: begin
        updated_status[NEG] = A[MSB];
        updated_status[ZERO] = ~|A;
      end

      LDX_abs: begin
        updated_status[NEG] = X[MSB];
        updated_status[ZERO] = ~|X;
      end
      LDY_abs: begin
        updated_status[NEG] = Y[MSB];
        updated_status[ZERO] = ~|Y;
      end

      LSR_abs: begin
        updated_status[NEG] = alu_Y[MSB];
        updated_status[ZERO] = ~|alu_Y;
        updated_status[CARRY] = alu_carry_out;
      end

      ORA_abs: begin
        updated_status[NEG] = A[MSB];
        updated_status[ZERO] = ~|A;
      end

      ROL_abs: begin
        updated_status[NEG] = alu_Y[MSB];
        updated_status[ZERO] = ~|alu_Y;
        updated_status[CARRY] = alu_carry_out;
      end

      ROR_abs: begin
        updated_status[NEG] = alu_Y[MSB];
        updated_status[ZERO] = ~|alu_Y;
        updated_status[CARRY] = alu_carry_out;
      end

      // -- Implied Addressing Mode
      CLC_imp: begin
        updated_status[CARRY] = 1'b0;
      end

      CLV_imp: begin
        updated_status[OVF] = 1'b0;
      end

      SEC_imp: begin
        updated_status[CARRY] = 1'b1;
      end

      // Be explicit about which opcodes do not affect processor status
      JMP_abs,
      STA_abs,
      STX_abs,
      STY_abs,
      NOP_imp: begin
        updated_status = P;
      end

      default: begin end
    endcase // case ( IR )
  end // block: PROCESSOR_STATUS_UPDATE

  // -- Accumulator Update
  always @(*) begin: ACCUMULATOR_UPDATE

    // The acumulator will be updated when in the FETCH state, if necessary

    case ( IR )

      ASL_acc: begin
        updated_accumulator = alu_Y;
      end

      LSR_acc: begin
        updated_accumulator = alu_Y;
      end

      ROL_acc: begin
        updated_accumulator = alu_Y;
        updated_accumulator[LSB] = alu_carry_out;
      end

      ROR_acc: begin
        updated_accumulator = alu_Y;
        updated_accumulator[MSB] = alu_carry_out;
      end

      default: begin end
    endcase // case ( IR )
  end // block: ACCUMULATOR_UPDATE

  // -- ALU Instantiation
  alu
    #(
      ) inst_alu (
                  .alu_control   (alu_control),
                  .alu_AI        (alu_AI),
                  .alu_BI        (alu_BI),
                  .alu_carry_in  (alu_carry_in),
                  .alu_Y         (alu_Y),
                  .alu_carry_out (alu_carry_out),
                  .alu_overflow  (alu_overflow)
                  );

  function [7:0] twos_complement;
    // Represent negative numbers to perform subtraction
    input [7:0] value;

    begin
      twos_complement = (~value) + 1'b1;
    end
  endfunction // twos_complement

endmodule // proc

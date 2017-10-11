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
   output reg        wr_enable,

   // ALU connections
   input [7:0]       alu_Y,
   input [7:0]       alu_flags,

   output reg [2:0]  alu_ctrl,
   output reg [7:0]  alu_AI,
   output reg [7:0]  alu_BI,
   output reg        alu_carry,
   output reg        alu_BCD
   );

`include "./includes/opcodes.vh"
`include "./includes/params.vh"

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

  localparam ERROR     = 255;

  // More to come...

  localparam EMPTY = 256'b0;

  // State register definition - for now, we'll make this big
  reg [255:0]        state;
  reg [255:0]        next;

 `include "./includes/ascii.vh"

  // --- Other Signals
  reg [7:0]          operand_LSB;
  reg [7:0]          operand_MSB;

  // Accumulator and processor status updates
  reg                update_accumulator;
  reg [7:0]          updated_status;

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
      update_accumulator <= 1'b0;
      decoded_state <= 0;

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
        // 6-cycle instructions continue
        if ( IR == ASL_abs ) begin
          next[ABS_3] = 1'b1;
        // 4-cycle instructions return
        end else begin
          next[FETCH] = 1'b1;
        end
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
        if (update_accumulator == 1'b1) begin
          A <= alu_Y;
          update_accumulator <= 1'b0;
        end
      end

      state[DECODE]: begin

        // Always read the next byte from memory and then decide what to do with
        // it in the next state (this can include doing nothing with it)
        operand_LSB <= rd_data;

        case ( IR )

          // 4 cycle absolute addressing mode
          ADC_abs,
          AND_abs,
          ASL_abs,
          BIT_abs,
          CMP_abs,
          LDA_abs,
          ROL_abs,
          ROR_abs: begin
            address <= PC + 16'd2;
          end

          // 3 cycle absolute addressing mode
          JMP_abs: begin
            address <= PC + 16'd2;
          end

          // 2-cycle implied addressing mode
          CLC_imp,
          CLV_imp,
          NOP_imp: begin
            address <= PC + 16'd1;
            PC <= PC + 16'd1;
            update_accumulator <= 1'b1;
          end

          default: begin end
        endcase // case ( IR )

      end

      // -- Absolute Addressing Mode
      state[ABS_1]: begin

        operand_MSB <= rd_data;

        case ( IR )

          ADC_abs,
          AND_abs,
          ASL_abs,
          BIT_abs,
          CMP_abs,
          LDA_abs,
          LDX_abs,
          LDY_abs,
          ROL_abs,
          ROR_abs: begin
            address <= { rd_data, operand_LSB };
          end

          JMP_abs: begin
            address <= { rd_data, operand_LSB };
            PC <= { rd_data, operand_LSB };
          end

          default: begin end
        endcase // case ( IR )

      end

      state[ABS_2]: begin

        case ( IR )

          ADC_abs: begin
            PC <= PC + 16'd3;
            address <= PC + 16'd3;

            alu_AI <= A;
            alu_BI <= rd_data;
            alu_ctrl <= ADD;
            alu_carry <= P[CARRY];

            update_accumulator <= 1'b1;
          end

          AND_abs: begin
            PC <= PC + 16'd3;
            address <= PC + 16'd3;

            alu_AI <= A;
            alu_BI <= rd_data;
            alu_ctrl <= AND;

            update_accumulator <= 1'b1;
          end

          ASL_abs: begin
            alu_AI <= rd_data;
            alu_ctrl <= SL;
          end

          BIT_abs: begin
            alu_AI <= A;
            alu_BI <= rd_data;
            alu_ctrl <= AND;

            // BIT instruction affects only processor status register and does
            // not touch memory or the accumulator - explicitly ignore it here
            update_accumulator <= 1'b0;
          end

          CMP_abs: begin
            alu_AI <= A;
            alu_BI <= rd_data;
            alu_ctrl <= SUB;

            // CMP instruction affects only processor status register and does
            // not touch memory or the accumulator - explicitly ignore it here
            update_accumulator <= 1'b0;
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


          ROL_abs: begin
            ALU_AI <= rd_data;
            alu_ctrl <= SL;
          end

          ROL_abs: begin
            ALU_AI <= rd_data;
            alu_ctrl <= SR;
          end

          default: begin end
        endcase // case ( IR )

      end

      state[ABS_3]: begin

        case ( IR )

          ASL_abs: begin
            wr_data <= alu_Y;
            wr_enable <= 1'b1;

            // Address to store the result to on the next clock cycle
            address <= { operand_MSB, operand_LSB };
          end

          ROL_abs: begin
            wr_data <= alu_Y;
            wr_enable <= 1'b1;
          end

          ROL_abs: begin
            wr_data <= alu_Y;
            wr_enable <= 1'b1;
          end

          default: begin end
        endcase // case ( IR )
      end

      state[ABS_4]: begin

        case ( IR )

          ASL_abs: begin
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
      end

    endcase // case ( 1'b1 )

  end // block: INSTRUCTION_CYCLE

  // --- Address Mode Decoder
  always @(*) begin: ADDR_MODE_DECODER

    // The contents of the instruction register are decoded to determine the
    // path through the state machine, which in turn determines the number of
    // additional operands that need to be read from memory

    case ( IR )

      ADC_abs,
      AND_abs,
      ASL_abs,
      BIT_abs,
      CMP_abs,
      JMP_abs,
      LDA_abs,
      LDX_abs,
      LDY_abs,
      ROL_abs,
      ROR_abs: begin
        decoded_state = ABS_1;
      end

      CLC_imp,
      CLV_imp,
      NOP_imp: begin
        decoded_state = FETCH;
      end

      default: begin
        decoded_state = ERROR;
      end
    endcase // case ( IR )

  end // block: ADDR_MODE_DECODER

  // --- Processor Status Update
  always @(*) begin: PROCESSOR_STATUS_UPDATE

    // Processor status register will be updated upon entry into the FETCH
    // state.

    updated_status = P;

    case ( IR )

      ADC_abs: begin
        updated_status[NEG] = alu_flags[NEG];
        updated_status[ZERO] = alu_flags[ZERO];
        updated_status[OVF] = alu_flags[OVF];
        updated_status[CARRY] = alu_flags[CARRY];
      end

      AND_abs,
      LDA_abs,
      LDX_abs,
      LDY_abs: begin
        updated_status[NEG] = alu_flags[NEG];
        updated_status[ZERO] = alu_flags[ZERO];
      end

      ASL_abs,
      ROL_abs,
      ROR_abs: begin
        updated_status[NEG] = alu_flags[NEG];
        updated_status[ZERO] = alu_flags[ZERO];
        updated_status[CARRY] = alu_flags[CARRY];
      end

      BIT_abs: begin
        // Negative flag comes from high bit of operand provided to ALU
        updated_status[NEG] = rd_data[7];
        // Zero flag is normal, but with accumulator and memory unaffected
        updated_status[ZERO] = alu_flags[ZERO];
        // Overflow flag comes from next highest bit of operand provided to ALU
        updated_status[OVF] = rd_data[6];
      end

      CMP_abs: begin
        updated_status[NEG] = alu_flags[NEG];
        updated_status[ZERO] = alu_flags[ZERO];
        updated_status[CARRY] = alu_flags[CARRY];
      end

      CLC_imp: begin
        updated_status[CARRY] = 1'b0;
      end

      CLV_imp: begin
        updated_status[OVF] = 1'b0;
      end

      // Explicitly ensure these instructions do not touch processor status
      JMP_abs,
      NOP_imp: begin
        updated_status = P;
      end

      default: begin end
    endcase // case ( IR )
  end // block: PROCESSOR_STATUS_UPDATE

endmodule // proc

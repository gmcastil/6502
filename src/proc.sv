/*

 65C02 processor implemented in Verilog

 */

module proc
  (
   input         RDY, // ready (active low)
   output        PHI_1, // phase 1 clock (out)
   input         IRQ, // interrupt request (active low)
   input         NMI, // non-maskable interrupt (active low)
   output        SYNC, // synchronize signal
   output [15:0] AB, // 16-bit address bus
   input [7:0]   DB_IN, // 8-bit data bus (in)
   output [7:0]  DB_OUT, // 8-bit data bus (out)
   output        RW, // read / write
   input         PHI_0, // phase 0 clock (in)
   input         SO, // set overflow
   output        PHI_2, // phase 2 clock (out)
   input         RES            // reset (active low)
   );

   // 6502 registers from Fig 2.1 of WDC Programming Manual
   reg [7:0]     A;             // accumulator
   reg [7:0]     X;             // X index register
   reg [7:0]     Y;             // Y index register
   reg [7:0]     S;             // stack pointer
   reg [15:0]    PC;            // program counter

   reg [7:0]     IR;            // instruction register

   // processor status register from Table 2-1 of WDC Programming Manual
   reg           C;             // 1 = carry
   reg           Z;             // 1 = result zero
   reg           I;             // 1 = disable interrupt
   reg           D;             // 1 = decimal mode
   reg           B;             // 1 = break caused interrupt
   reg           V;             // 1 = overflow
   reg           N;             // 1 = negative

   // --- Combinatorial State Movemtents

   /*

    The state machine for the processor is broken into the following:

    RESET - reset logic
    IRQ_HANDLE - all interrupt handling, including non-maskable interrupts
    FETCH - obtain the next instruction
    DECODE_OP - decode opcode
    OPER_1 - fetch first operand if necessary
    OPER_2 - fetch second operatnd if necessary
    EXECUTE - execute instruction (probably be replaced as I add instructions)

    */
   typedef enum  logic [6:0]
                 {
                  IDLE        = 7'b0000001,
                  RESET       = 7'b0000010,
                  IRQ_HANDLE  = 7'b0000100,
                  FETCH       = 7'b0001000,
                  DECODE_OP   = 7'b0010000,
                  OPER_1      = 7'b0100000,
                  OPER_2      = 7'b1000000
                  EXECUTE     = } states;

   states present;
   states next;

   localparam IDLE_ID       = 0;
   localparam RESET_ID      = 1;
   localparam IRQ_HANDLE_ID = 2;
   localparam FETCH_ID      = 3;
   localparam DECODE_OP_ID  = 4;
   localparam OPER_1_ID     = 5;
   localparam OPER_2_ID     = 6;
   localparam EXECUTE_ID    = 7;

   localparam RESET_VECTOR = 16'hFFFC;
   localparam IRQ_VECTOR   = 16'hFFFE;

   always @(posedge clk) begin
      if (!RES) begin
         // fetch reset vector
         next = IDLE
      end
      else begin

      end
   end

   always @(*) begin

      case (1'b1)

        present[IDLE_ID]: begin
        end

        present[RESET_ID]: begin
        end

        present[IRQ_HANDLE_ID]: begin
        end

        present[FETCH_ID]: begin
        end

        present[DECODE_OP_ID]: begin
        end

        present[OPER_1_ID]: begin
        end

        present[OPER_2_ID]: begin
        end

        present[EXECUTE_ID]: begin
        end

        default: begin
        end

      endcase // case (1'b1)
   end

endmodule

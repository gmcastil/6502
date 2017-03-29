/*

 65C02 processor implemented in Verilog

 */

module 6502
  (
   input         RDY,           // ready (active low)
   output        PHI_1,         // phase 1 clock (out)
   input         IRQ,           // interrupt request (active low)
   input         NMI,           // non-maskable interrupt (active low)
   output        SYNC,          // synchronize signal
   output [15:0] AB,            // 16-bit address bus
   input [7:0]   DB_IN,         // 8-bit data bus (in)
   output [7:0]  DB_OUT,        // 8-bit data bus (out)
   output        RW,            // read / write
   input         PHI_0,         // phase 0 clock (in)
   input         SO,            // set overflow
   output        PHI_2,         // phase 2 clock (out)
   input         RES            // reset (active low)
   );

   // 6502 registers from Fig 2.1 of WDC Programming Manual
   reg [7:0]     A;             // accumulator
   reg [7:0]     X;             // X index register
   reg [7:0]     Y;             // Y index register
   reg [7:0]     S;             // stack pointer
   reg [15:0]    PC;            // program counter

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

    IDLE - for initial startup
    RESET - reset logic
    IRQ - all interrupt handling, including non-maskable interrupts
    FETCH - obtain the next instruction and operands
    DECODE -

    The remainder of the states in the FSM group several opcodes and
    addressing modes.

    STORAGE   - load, store, and transfer instructions
    MATH      - add, subtract, increment and decrement instructions
    BITWISE   - Boolean functions, shift, and and rotate instructions

    */
   typedef enum logic [12:0]
                {
                 IDLE        13'b0_0000_0000_0001,
                 RESET,      13'b0_0000_0000_0010,
                 IRQ,        13'b0_0000_0000_0100,
                 FETCH,      13'b0_0000_0000_1000,
                 DECODE,     13'b0_0000_0001_0000,
                 STORAGE,    13'b0_0000_0010_0000,
                 MATH,       13'b0_0000_0100_0000,
                 BITWISE,    13'b0_0000_1000_0000,
                 BRANCH,     13'b0_0001_0000_0000,
                 JUMP,       13'b0_0010_0000_0000,
                 REGISTERS,  13'b0_0100_0000_0000,
                 STACK,      13'b0_1000_0000_0000,
                 SYSTEM      13'b1_0000_0000_0000
                 } states

   states next_state;
   states present_state;

   localparam IDLE_LOW_ID   = 0;
   localparam HIGH_ID       = 1;
   localparam IDLE_HIGH_ID  = 2;
   localparam LOW_ID        = 3;


endmodule

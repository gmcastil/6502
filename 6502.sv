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

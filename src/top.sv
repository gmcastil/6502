module top ();

  logic         RDY;           // ready (active low)
  logic         PHI_1;         // phase 1 clock (out)
  logic         IRQ;           // interrupt request (active low)
  logic         NMI;           // non-maskable interrupt (active low)
  logic         SYNC;          // synchronize signal
  logic [15:0]  AB;            // 16-bit address bus
  logic [7:0]   DB_IN;         // 8-bit data bus (in)
  logic [7:0]   DB_OUT;        // 8-bit data bus (out)
  logic         RW;            // read / write
  logic         PHI_0;         // phase 0 clock (in)
  logic         SO;            // set overflow
  logic         PHI_2;         // phase 2 clock (out)
  logic         RES;           // reset (active low)

  // --- Instantiate the processor
  6502
    #(
      // parameter
      )
  dut (
       .RDY           (RDY),
       .PHI_1         (PHI_1),
       .IRQ           (IRQ),
       .NMI           (NMI),
       .SYNC          (SYNC),
       .AB            (AB),
       .DB_IN         (DB_IN),
       .DB_OUT        (DB_OUT),
       .RW            (RW),
       .PHI_0         (PHI_0),
       .SO            (SO),
       .PHI_2         (PHI_2),
       .RES           (RES)
       );

  // --- Instantiate an address space for the processor to communicate over

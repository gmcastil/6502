`timescale 1 ns / 1 ps

module proc_tb ();

  localparam T = 10;           // 10ns clock period

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

  logic         clk;

  assign PHI_0 = clk;

  // --- Instantiate the processor
  proc
    #(
      // parameter
      )
  dut_proc (
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

  // --- Instantiate an address space for the processor to communicate with
  memory_space
    #(
      //
      )
  dut_memory_space (
                    .a     (AB),
                    .spo   (DB_IN)
                    );
  
  initial begin
    clk = 1'b1;
    forever begin
      #(T/2);
      clk = ~clk;
    end     
  end
  
  initial begin
    #(T*10);
    RES = 1'b0;
    #(T*4);
    RES = 1'b1;
    #(T*50);
  end
  
endmodule

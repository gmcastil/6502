`timescale 1ns / 1ps

module proc_top_tb ();

  localparam T = 10;
  localparam P = 100;

  reg          clk_sys;       // Memory will be clocked 10X relative to processor
  reg          clk;
  reg          resetn;
  reg          enable;
  reg          write_enable;
  wire [15:0]  address;
  wire [7:0]   read_data;
  reg [7:0]    write_data;

  // Create the 100MHz clock that the memory will run at
  initial begin
    clk_sys = 1'b1;
    forever begin
      #(T/2);
      clk_sys = ~clk_sys;
    end
  end

  // Create the 10MHz clock that the processor will run at
  initial begin
    clk_sys = 1'b1;
    forever begin
      #(P/2);
      clk_sys = ~clk_sys;
    end
  end

  // Set some parameters to remain constant throughout (at least for now)
  initial begin
    enable = 1'b1;
    write_enable = 1'b0;
  end

  // Initiate the global reset (for now, synchronize both edges to both
  // clocks, but later this will be performed by the porf block)
  initial begin
    resetn = 1'b1;
    #(P*2)
    resetn = 1'b0;
    #(P*4)
    resetn = 1'b1;
    #(P*100);
  end

  // Instantiate the memory block using the example from the generated
  memory_block
    #(
      ) inst_memory_block (
                           .clka  (clk_sys),
                           .ena   (enable),
                           .wea   (write_enable),
                           .addra (address),
                           .dina  (write_data),
                           .douta (read_data)
                           );

  proc
    #(
      ) inst_proc (
                   clk           (clk),
                   resetn        (resetn),
                   read_data     (read_data),
                   address       (address),
                   debug_state   (),
                   debug_opcode  (),
                   debug_PC      (),
                   debug_operand (),
   );

endmodule // proc_top_tb

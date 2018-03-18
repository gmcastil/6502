// ----------------------------------------------------------------------------
// Module:  memory_tb.sv
// Project: MOS 6502 Processor
// Author:  George Castillo <gmcastil at gmail.com>
// Date:    08 July 2017
//
// Description: Testbench for Xilinx IP used to mock the address space of the
// processor and allow early programming during development by manually
// entering 6502 processor opcodes.
// ----------------------------------------------------------------------------

`timescale 1ns / 1ps

module memory_tb();

  localparam T = 10;

  reg clk_sys;
  reg enable;
  reg write_enable;

  reg [15:0] address;
  wire [7:0] read_data;
  reg [7:0]  write_data;

  integer    pass;
  integer    fail;

  initial begin
    clk_sys = 1'b1;
    forever begin
      #(T/2);
      clk_sys = ~clk_sys;
    end
  end

  reg [15:0] addr_count;

  initial begin

    enable = 1'b1;
    write_enable = 1'b0;
    // Verify initial loading of block RAM contents
    #(T*10);
    for (addr_count = 16'b0; addr_count < 16'hFFFF; addr_count++) begin
      address = addr_count;
      #(T*10);
      $display("Read value %u from address %u", read_data, address);
      #(T*10);
    end

    pass = 0;
    fail = 0;

    // Verify that we can read and write the memory
    #(T*10);
    for (addr_count = 16'b0; addr_count < 16'hFFFF; addr_count++) begin
      write_enable = 1'b1;
      write_data = $random;
      address = addr_count;
      #(T);

      write_enable = 1'b0;
      #(T*10);
      assert(write_data == read_data) begin
        pass++;
      end else begin
        fail++;
        $display("Expected %u but received %u at address %u", write_data, read_data, address);
      end
      #(T);
    end
    $display("%u passing tests", pass);
    $display("%u failing tests", fail);
    $finish;
  end

  memory_block
    #(
      ) inst_memory_block (
                           .clka(clk_sys),
                           .ena(enable),
                           .wea(write_enable),
                           .addra(address),
                           .dina(write_data),
                           .douta(read_data)
                           );

endmodule

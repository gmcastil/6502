// ----------------------------------------------------------------------------
// Module:  memory_tb.v
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

  wire [15:0] address;
  reg [7:0]  read_data;
  wire [7:0] write_data;

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
    write_data = 8'b0;

    address = 16'b0;
    addr_count = 16'b0;
    #(T*10);
    for (addr_count=16'b0; addr_count<=16'hFFFF; addr_count=addr_count+1'b1) begin
      address = addr_count;
      #(T);
    end
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

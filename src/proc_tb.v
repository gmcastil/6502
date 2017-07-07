`timescale 1ns / 1ps

module memory_block_tb();

  localparam T = 10;

  reg clka;
  reg ena;
  reg wea;
  reg [15:0] addra;
  reg [7:0]  dina;
  wire [7:0] douta;


  initial begin
    clka = 1'b1;
    forever begin
      #(T/2);
      clka = ~clka;
    end
  end

  reg [15:0] addr_count;

  initial begin
    ena = 1'b1;
    wea = 1'b0;
    addra = 16'b0;
    dina = 8'b0;
    addr_count = 16'b0;
    #(T*10);
    for (addr_count=16'b0; addr_count<=16'hFFFF; addr_count=addr_count+1'b1) begin
      addra = addr_count;
      #(T);
    end
  end

  memory_block
    dut_memory_block (
                      .clka(clka),    // input wire clka
                      .ena(ena),      // input wire ena
                      .wea(wea),      // input wire [0 : 0] wea
                      .addra(addra),  // input wire [15 : 0] addra
                      .dina(dina),    // input wire [7 : 0] dina
                      .douta(douta)   // output wire [7 : 0] douta
                      );

endmodule

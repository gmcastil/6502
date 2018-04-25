// ----------------------------------------------------------------------------
// Module:  memory_tb.sv
// Project: MOS 6502 Processor
// Author:  George Castillo <gmcastil@gmail.com>
// Date:    23 April 2018
//
// Description:
// ----------------------------------------------------------------------------
`timescale 1ns / 1ps

module memory_tb ();

  parameter DEPTH = 16;
  parameter WIDTH = 8;
  parameter ASYNC_DELAY = 1;
  parameter DATA_FILE = "data.mif";
  parameter CLOCK = 10;

  logic clk;
  logic resetn;
  logic enable;
  logic wr_enable;

  logic [DEPTH-1:0] address;
  logic [WIDTH-1:0] wr_data;
  logic [WIDTH-1:0] rd_data;

  // Temporary variable to read and print
  logic [WIDTH-1:0] data;
  logic [WIDTH-1:0] operand_LSB;
  logic [WIDTH-1:0] operand_MSB;
  logic [DEPTH-1:0] PC;

  initial begin
    clk = 1'b1;
    forever begin
      #(CLOCK/2);
      clk = ~clk;
    end
  end

  initial begin
    enable <= 1'b0;
    wr_enable <= 1'b0;
    #100ns;

    enable <= 1'b1;
    address <= 16'hfffc;
    #CLOCK;
    // This was read a clock cycle after address placed on the address lines
    $display("Read %h from address %4h.", rd_data, address);
    operand_LSB <= rd_data;

    address <= 16'hfffd;
    #CLOCK;
    // This was read a clock cycle after address placed on the address lines
    $display("Read %h from address %4h.", rd_data, address);
    operand_MSB <= rd_data;

    address <= { rd_data, operand_LSB };
    PC <= { rd_data, operand_LSB };
    #CLOCK;
    // This was read a clock cycle after address placed on the address lines
    $display("Program execution begins at %4h.", { operand_MSB, operand_LSB});
    $display("Found opcode of %2h at %4h", rd_data, { operand_MSB, operand_LSB});
    data <= rd_data;

    address <= PC + 16'd1;
    PC <= PC + 16'd1;
    #CLOCK;
    // This was read a clock cycle after address placed on the address lines
    $display("Found value of %2h", rd_data);
    data <= rd_data;

    address <= PC + 16'd1;
    PC <= PC + 16'd1;
    #CLOCK;
    // This was read a clock cycle after address placed on the address lines
    $display("Found value of %2h at %4h", rd_data, PC);

    // Now just roll with some writes and reads
    address <= 16'h8000;
    wr_data <= 8'hff;
    wr_enable <= 1'b1;
    #CLOCK;
    address <= 16'h8000;
    wr_enable <= 1'b0;
    $display("Wrote value of %2h at %4h", wr_data, 16'h8000);
    #CLOCK;
    $display("Read value of %2h at %4h", rd_data, 16'h8000);
    #CLOCK;
    $finish;
  end

  memory #(

        .DEPTH (DEPTH),
        .WIDTH (WIDTH),
        .ASYNC_DELAY (ASYNC_DELAY),
        .DATA_FILE (DATA_FILE)

        ) memory_inst (

                       .clk (clk),
                       .resetn (resetn),
                       .enable (enable),
                       .address (address),
                       .wr_enable (wr_enable),
                       .wr_data (wr_data),
                       .rd_data (rd_data)

                    );

endmodule // ram_tb

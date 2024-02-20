`timescale 1ns / 1ps

module cpu_top_tb //#(
//)
();

  logic           clk;
  logic           clk_en;
  logic           rstn;

  logic   [7:0]   rd_data;
  logic   [7:0]   wr_data;
  logic   [15:0]  addr;

  logic           rw_n;
  logic           nmi_n;
  logic           irq_n;

  // Stick to a 10MHz input clock frequency to run everything off of. This will
  // undoubtedly need to change when I start introducing additional clock
  // domains and a clock enable (e.g., when actually using a model for an
  // asynchronous RAM emulator).
  parameter   T   = 100ns;

  parameter         RST_ASSERT_LEN    = 10;

  integer     rst_assert_cnt;

  // Clock creation
  initial begin
    clk       <= 1'b0;
    forever begin
      #(T/2);
      clk       <= ~clk;
    end
  end

  initial begin
    // Initialize CPU control signals
    clk               <= 1'b1;
    rstn              <= 1'b1;
    nmi_n             <= 1'b1;
    irq_n             <= 1'b1;

    // Initialize simulation only variables
    rst_assert_cnt    <= 32'd0;
  end

  // Create a synchronous reset
  always @(posedge clk) begin
    if (rst_assert_cnt  != RST_ASSERT_LEN) begin
      rstn            <= 1'b0;
      rst_assert_cnt++;
    end else begin
      rstn            <= 1'b1;
    end
  end

  // Note that no standard governs VHDL to SystemVerilog generics, so use
  // only when needed
  cpu_top //#(
  //)
  cpu_top_i0 (
    .clk            (clk),        // in    std_logic
    .clk_en         (clk_en),     // in    std_logic
    .rstn           (rstn),       // in    std_logic
    .rd_data        (rd_data),    // in    std_logic_vector(7 downto 0)
    .wr_data        (wr_data),    // out   std_logic_vector(7 downto 0)
    .addr           (addr),       // out   std_logic_vector(15 downto 0)
    .rw_n           (rw_n),       // out   std_logic
    .nmi_n          (nmi_n),      // in    std_logic
    .irq_n          (irq_n)       // in    std_logic
  );

endmodule


`timescale 10n / 1ps;

module alu_tb ();

  logic [3:0] ctrl;
  logic [7:0] AI;
  logic [7:0] BI;
  logic       CI;
  logic       D;

  logic       N;
  logic       V;
  logic       Z;
  logic       CO;
  logic       HC;

  logic       out;

  alu #(
        ) dut (
               .ctrl (ctrl),
               .AI   (AI),
               .BI   (BI),
               .CI   (CI),
               .D    (D),

               .N    (N),
               .V    (V),
               .Z    (Z),
               .CO   (CO),
               .HC   (HC),

               .out  (out)
               );

  initial begin
    // Let the simulator get caught up
    #10ns;
    AI = 8'bFF;
    BI = 8'bFF;
    CI = 1'b1;
    #10ns;
  end

endmodule // alu_tb

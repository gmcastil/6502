module porf_gen
  (
   input  reset_in,
   input  clk,
   output reset_out
   );

  wire    d_1;
  wire    q_1;

  wire    d_2;
  wire    q_2;

  wire    d_3;
  wire    q_3;

  wire    d_4;
  wire    q_4;

  FDPE #(
         .INIT(1'b0)
         ) FDPE_1 (
                   .D(d_1),
                   .Q(q_1),
                   .C(clk),
                   .CE(1'b1),
                   .PRE(reset_in)
                   );

  FDPE #(
         .INIT(1'b0)
         ) FDPE_2 (
                   .D(q_1),
                   .Q(q_2),
                   .C(clk),
                   .CE(1'b1),
                   .PRE(reset_in)
                   );

  FDPE #(
         .INIT(1'b0)
         ) FDPE_3 (
                   .D(q_2),
                   .Q(q_3),
                   .C(clk),
                   .CE(1'b1),
                   .PRE(reset_in)
                   );

  FDPE #(
         .INIT(1'b0)
         ) FDPE_4 (
                   .D(q_3),
                   .Q(q_4),
                   .C(clk),
                   .CE(1'b1),
                   .PRE(reset_in)
                   );

  assign reset_out = q_4;
  assign d_1 = 1'b0;

endmodule // porf_gen

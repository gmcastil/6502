module porf_gen
  #(
    parameter N = 8
    )
   (
    input  reset_in,
    input  clk,
    input  clk_enable,
    output reset_out
    );

   wire    d_1;
   wire [N:1] q;

   assign reset_out = q[N];
   assign d_1 = 1'b0;

   // The first flop in the sequence needs D tied to ground
   FDPE #(
          .INIT(1'b0)
          ) FDPE_INITIAL (
                          .D(d_1),
                          .Q(q[1]),
                          .C(clk),
                          .CE(1'b1),
                          .PRE(reset_in)
                          );

   // All the rest of these flops have the same wiring pattern. If you wanted to
   // tap off the second to last flop, you would alter the loop to stop at N-1.
   genvar     i;
   generate
      for (i=2; i=N; i=i+1) begin
         FDPE #(
                .INIT(1'b0)
                ) u_FDPE (
                          .D(q[i-1]),
                          .Q(q[i]),
                          .C(clk),
                          .CE(clk_enable),
                          .PRE(reset_in));
      end
   endgenerate

endmodule // porf_gen

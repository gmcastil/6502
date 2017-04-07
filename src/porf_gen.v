module porf_gen
  #(
    parameter N = 4
    )
   (
    input  async_reset,
    input  clk,
    input  clk_enable,
    output sync_reset
    );

   wire     d_1;
   wire [N:1] q;

   assign sync_reset = q[N];
   assign d_1 = 1'b0;

   // The first flop in the sequence needs D tied to ground
   FDPE #(
          .INIT(1'b0)
          ) FDPE_INITIAL (
                          .D(d_1),
                          .Q(q[1]),
                          .C(clk),
                          .CE(clk_enable),
                          .PRE(async_reset)
                          );

   // All the rest of these flops have the same wiring pattern. If you wanted to
   // tap off the second to last flop, you would alter the loop to stop at N-1.
   genvar i;
   for (i=2; i<=N; i=i+1) begin: generate_flops
       FDPE #(
                .INIT(1'b0)
                ) u_FDPE (
                          .D(q[i-1]),
                          .Q(q[i]),
                          .C(clk),
                          .CE(clk_enable),
                          .PRE(async_reset)
                          );
      end

endmodule // porf_gen

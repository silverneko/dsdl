module ALU(a_in, b_in, op_in, c_out, overflow);
  input  [5:0] a_in, b_in;
  input  [1:0] op_in;
  output [11:0] c_out;
  output overflow;

  /*
  * Adder
  */
  Adder6 adder(
    .a_in(a_in),
    .b_in(b_in),
    .s_out()
  );

  /*
  * Substract (by adding with two's compliment)
  */
  TwosCompliment tc(
    .a_in(b_in),
    .a_out()
  );
  Adder6 suber(
    .a_in(a_in),
    .b_in(tc.a_out),
    .s_out()
  );

  /*
  * multiply
  */
  Multiplier muler(
    .a_in(a_in),
    .b_in(b_in),
    .c_out()
  );

  /*
  * divider
  */
  Divider diver(
    .a_in(a_in),
    .b_in(b_in),
    .c_out()
  );

  /*
  * 2-bit mux
  */
  `define OPADD 2'b00
  `define OPSUB 2'b01
  `define OPMUL 2'b10
  `define OPDIV 2'b11

  Mux2 #(12) muxResult (
    .a_in({6'b0, adder.s_out}),
    .b_in({6'b0, suber.s_out}),
    .c_in(muler.c_out),
    .d_in(diver.c_out),
    .s_in(op_in),
    .s_out()
  );

  assign c_out = muxResult.s_out;

  Mux2 #(1) muxOverflow (
    .a_in((a_in[5] & b_in[5] & ~c_out[5])
    | (~a_in[5] & ~b_in[5] & c_out[5])),
    .b_in((suber.a_in[5] & suber.b_in[5] & ~c_out[5])
    | (~suber.a_in[5] & ~suber.b_in[5] & c_out[5])),
    .c_in((a_in[5] & b_in[5] & c_out[11])
    | (a_in[5] & ~b_in[5] & ~c_out[11])
    | (~a_in[5] & b_in[5] & ~c_out[11])
    | (~a_in[5] & ~b_in[5] & c_out[11])),
    .d_in(1'b0),
    .s_in(op_in),
    .s_out()
  );

  assign overflow = muxOverflow.s_out;

endmodule

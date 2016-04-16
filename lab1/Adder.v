module Adder1(a_in, b_in, c_in, s_out, c_out);
  input   a_in, b_in, c_in;
  output  s_out, c_out;

  assign s_out = a_in ^ b_in ^ c_in;
  assign c_out = (a_in & b_in) | (b_in & c_in) | (c_in & a_in);

endmodule

module Adder6(a_in, b_in, s_out);
  input  [5:0] a_in, b_in;
  output [5:0] s_out;
  wire   [5:0] c_in;

  Adder1 add0(a_in[0], b_in[0], 1'b0, s_out[0], c_in[1]);
  Adder1 add1(a_in[1], b_in[1], c_in[1], s_out[1], c_in[2]);
  Adder1 add2(a_in[2], b_in[2], c_in[2], s_out[2], c_in[3]);
  Adder1 add3(a_in[3], b_in[3], c_in[3], s_out[3], c_in[4]);
  Adder1 add4(a_in[4], b_in[4], c_in[4], s_out[4], c_in[5]);
  Adder1 add5(a_in[5], b_in[5], c_in[5], s_out[5], /* don't care */ c_in[0]);
endmodule

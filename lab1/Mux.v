module Mux1(a_in, b_in, s_in, s_out);
  parameter WIDTH = 1;
  input  [WIDTH-1:0] a_in, b_in;
  input  s_in;
  output [WIDTH-1:0] s_out;

  assign s_out = ({WIDTH{s_in}} & b_in) | ({WIDTH{~s_in}} & a_in);

endmodule

module Mux2(a_in, b_in, c_in, d_in, s_in, s_out);
  parameter WIDTH = 1;
  input  [WIDTH-1:0] a_in, b_in, c_in, d_in;
  input  [1:0] s_in;
  output [WIDTH-1:0] s_out;

  Mux1 #(WIDTH) mux00 (
    .a_in(a_in),
    .b_in(b_in),
    .s_in(s_in[0]),
    .s_out()
  );
  Mux1 #(WIDTH) mux01 (
    .a_in(c_in),
    .b_in(d_in),
    .s_in(s_in[0]),
    .s_out()
  );

  Mux1 #(WIDTH) mux10 (
    .a_in(mux00.s_out),
    .b_in(mux01.s_out),
    .s_in(s_in[1]),
    .s_out()
  );

  assign s_out = mux10.s_out;

endmodule


module TwosCompliment(a_in, a_out);
  input  [5:0] a_in;
  output [5:0] a_out;

  Adder6 add(
    .a_in(~a_in),
    .b_in(6'b000001),
    .s_out(a_out)
  );

endmodule


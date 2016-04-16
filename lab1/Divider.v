module Divider(a_in, b_in, c_out);
  input  [5:0] a_in, b_in;
  output [11:0] c_out;

  reg [5:0] quotient, remainder;
  assign c_out = {remainder, quotient};

  reg [5:0] accum;
  integer i;

  always@(a_in, b_in) begin
    // assumes a_in and b_in are both positive
    if (a_in[5] | b_in[5] | b_in == 6'b0) begin
      remainder = 6'bx;
      quotient = 6'bx;
    end
    else begin
      if (b_in[4]) i = 0;
      else if (b_in[3]) i = 1;
      else if (b_in[2]) i = 2;
      else if (b_in[1]) i = 3;
      else if (b_in[0]) i = 4;
      accum = b_in << i;
      remainder = a_in;
      quotient = 6'b0;
      for (; i >= 0; i = i - 1) begin
        if (remainder >= accum) begin
          remainder = remainder - accum;
          quotient = quotient + (1 << i);
        end
        accum = accum >> 1;
      end
    end
  end
endmodule

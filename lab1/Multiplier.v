module Multiplier(a_in, b_in, c_out);
  input  [5:0] a_in, b_in;
  output [11:0] c_out;

  reg [5:0] t;
  reg [11:0] accum;
  reg [11:0] sum;
  integer i;

  assign c_out = sum;

  always@(a_in, b_in) begin
    if (a_in[5] == 1) begin
      // a_in is negative
      t = (~a_in) + 1;
    end
    else begin
      t = a_in;
    end
	 // signed extend
    accum = {{6{b_in[5]}}, b_in};
    sum = 0;
    for (i = 0; i < 6; i = i + 1) begin
      if (t[0] == 1) begin
        sum = sum + accum;
      end
      accum = accum << 1;
      t = t >> 1;
    end
	 if (a_in[5] == 1) begin
		sum = 1 + ~sum;
	 end
  end
endmodule

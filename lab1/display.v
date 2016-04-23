module Bin2dec(a_in , c_out);
  input [11:0] a_in;
  output [16:0] c_out; /*sign + 4 digits in dec.*/

  integer decnum;

  reg [16:0] result;
  assign c_out = result;

  always@(a_in) begin
    result = 0;
    decnum = a_in;

    if (decnum < 0) begin
    	result[16] = 1;
    	decnum = decnum * (-1);
    end
    else begin
    	result[16] = 0;
    end
    result[3:0] = decnum % 10; decnum = decnum / 10;
    result[7:4] = decnum % 10; decnum = decnum / 10;
    result[11:8] = decnum % 10; decnum = decnum / 10;
    result[15:12] = decnum % 10; decnum = decnum / 10;
  end
endmodule


module Display7seg(a_in , s_out);
  input [11:0] a_in;
  output [39:0] s_out; /*There will be 5 7-seg displays*/

  wire [16:0] c_out;

  Bin2dec bin2dec(
  	.a_in(a_in),
  	.c_out(c_out)
  );

  Seg7 seg7(
  	.c_in(c_out),
  	.s_out(s_out)
  );

endmodule
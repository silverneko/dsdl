module Bin2dec(a_in , c_out);
  input [31:0] a_in;
  output [31:0] c_out; /*8 digits in dec.*/

  reg [31:0] decnum;

  reg [31:0] result;
  reg [7:0] temp;
  assign c_out = result;

  always@(a_in) begin
    result = 32'b0;
    decnum = a_in;

    temp = decnum / 360000; decnum = decnum % 360000;
    result[31:28] = temp / 10; result[27:24] = temp % 10;

    temp = decnum / 6000; decnum = decnum % 6000;
    result[23:20] = temp / 10; result[19:16] = temp % 10;

    temp = decnum / 100; decnum = decnum % 100;
    result[15:12] = temp / 10; result[11:8] = temp % 10;

    result[7:4] = decnum / 10; result[3:0] = decnum % 10;
  end
 endmodule


module Display7seg(a_in , s_out);
  input [31:0] a_in;
  output [63:0] s_out; /*There will be 8 7-seg displays*/

  wire [31:0] c_out;

  Bin2dec bin2dec(
  	.a_in(a_in),
  	.c_out(c_out)
  );

  Seg7 seg7(
  	.c_in(c_out),
  	.s_out(s_out)
  );

endmodule

module Seg7_integer(a_in , s_out);
  input [3:0] a_in;
  output [7:0] s_out;

  reg [7:0] temp;
  assign s_out = temp;
  always @(a_in) begin
  	case (a_in)
  	                  /*segdp ~ seg a*/
  	  4'b0000: temp = 8'b00111111;
  	  4'b0001: temp = 8'b00000110;
  	  4'b0010: temp = 8'b01011011;
  	  4'b0011: temp = 8'b01001111;
  	  4'b0100: temp = 8'b01100110;
  	  4'b0101: temp = 8'b01101101;
  	  4'b0110: temp = 8'b01111101;
  	  4'b0111: temp = 8'b00100111;
  	  4'b1000: temp = 8'b01111111;
  	  4'b1001: temp = 8'b01101111;
  	  default: temp = 8'b00000000;
  	endcase
  end
endmodule

module Seg7(c_in , s_out);
  input [31:0] c_in;
  output [63:0] s_out;
  //hour
  Seg7_integer seg7_1(
  	.a_in(c_in[31:28]),
  	.s_out(s_out[63:56])
  );
  Seg7_integer seg7_2(
  	.a_in(c_in[27:24]),
  	.s_out(s_out[55:48])
  );
  //minute
  Seg7_integer seg7_3(
  	.a_in(c_in[23:20]),
  	.s_out(s_out[47:40])
  );
  Seg7_integer seg7_4(
  	.a_in(c_in[19:16]),
  	.s_out(s_out[39:32])
  );
  //second
  Seg7_integer seg7_5(
  	.a_in(c_in[15:12]),
  	.s_out(s_out[31:24])
  );
  Seg7_integer seg7_6(
    .a_in(c_in[11:8]),
    .s_out(s_out[23:16])
  );
  //centisecond
  Seg7_integer seg7_7(
    .a_in(c_in[7:4]),
    .s_out(s_out[15:8])
  );
  Seg7_integer seg7_8(
    .a_in(c_in[3:0]),
    .s_out(s_out[7:0])
  );
endmodule
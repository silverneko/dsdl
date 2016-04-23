module seg7_integer(a_in , s_out);
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
  	  4'b0101: temp = 8'b01111101;
  	  4'b0111: temp = 8'b00100111;
  	  4'b1000: temp = 8'b01111111;
  	  4'b1001: temp = 8'b01101111;
  	  default: temp = 8'b00000000;
  	endcase
  end
endmodule

module seg7_sign(a_in , s_out);
  input a_in;
  output [7:0] s_out;

  reg [7:0] temp;
  assign s_out = temp;
  always @(a_in) begin
  	if(a_in == 1) begin
  	    temp = 8'b01000000;
  	end
  	else begin
  		temp = 8'b00000000;
  	end
  end
endmodule

module Seg7(c_in , s_out);
  input [16:0] c_in;
  output [39:0] s_out;

  seg7_sign(
  	.a_in(c_in[16]),
  	.s_out(s_out[39:32])
  );
  seg7_integer(
  	.a_in(c_in[15:12]),
  	.s_out(s_out[31:24])
  );
  seg7_integer(
  	.a_in(c_in[11:8]),
  	.s_out(s_out[23:16])
  );
  seg7_integer(
  	.a_in(c_in[7:4]),
  	.s_out(s_out[15:8])
  );
  seg7_integer(
  	.a_in(c_in[3:0]),
  	.s_out(s_out[7:0])
  );
endmodule
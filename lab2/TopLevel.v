module TopLevel(key_in, s_out);
	input [3:0] key_in;
	output [63:0] s_out;

	reg clk;
	always #(1) clk = ~clk;

	wire [31:0] second;
	wire [1:0] key_press;
	reg [1:0] key_reg;
	assign key_press = key_reg;

	Timer timer(clk, key_press, second);
	Display7seg display7seg(second, s_out);

	`define NOP 2'b00
  	`define K1  2'b01
  	`define K2  2'b10
  	`define K3  2'b11

  	// I remember TA said press means 1 to 0. Need some try.
	always@(key_in) begin
	  case(key_in)
	  	4'b1110: key_reg <= `NOP;
	  	4'b1101: key_reg <= `K1;
	  	4'b1011: key_reg <= `K2;
	  	4'b0111: key_reg <= `K3;
	  endcase
	end

endmodule
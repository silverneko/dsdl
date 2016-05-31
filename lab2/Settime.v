module Settime(switch, switch_second, clk_i, second_o);
	input switch;
	input [15:0] switch_second;
	input clk_i;
	output [31:0] second_o;

	reg state;
	reg [31:0] second;
	`define SET 1'b1
	`define NOP 1'b0

	assign second_o = second;

	initial begin
		state = `NOP;
		second = 32'b0;
	end

	always@(negedge clk_i) begin
		if (state == `SET) begin
			second = {16'b0, switch_second[15:0]};
		end
		state = switch;
	end
endmodule
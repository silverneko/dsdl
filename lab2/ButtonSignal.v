module ButtonSignal(clk_i, key_i, signal_o);
  input clk_i;
  input [3:0] key_i;
  output reg [2:0] signal_o;

  `define NOP 3'b000
  `define K0  3'b100
  `define K1  3'b101
  `define K2  3'b110
  `define K3  3'b111

  reg [2:0] state;

  initial begin
    signal_o = `NOP;
    state = `NOP;
  end

  always@(negedge clk_i) begin
    if (state == `NOP) begin
      case (key_i)
        4'b1110: begin
          state <= `K0;
          signal_o <= `K0;
        end
        4'b1101: begin
          state <= `K1;
          signal_o <= `K1;
        end
        4'b1011: begin
          state <= `K2;
          signal_o <= `K2;
        end
        4'b0111: begin
          state <= `K3;
          signal_o <= `K3;
        end
      endcase
    end else begin
      signal_o <= `NOP;
      if (key_i == 4'b1111) begin
        state <= `NOP;
      end
    end
  end

endmodule

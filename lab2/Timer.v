module Timer(clk_i, signal_i, second_o);
  input clk_i;
  input [2:0] signal_i;
  output [31:0] second_o;

  reg [31:0] counter;
  reg [1:0] state;
  reg [31:0] second;

  assign second_o = second;

  `define SSTOP  2'b00
  `define SSTART 2'b01
  `define SPAUSE 2'b10

  initial begin
    state = `SSTOP;
    counter = 0;
    second = 0;
  end

  `define K0  3'b100
  `define K1  3'b101
  `define K2  3'b110
  `define K3  3'b111

  // `define CLKRATE 32'd500000
  `define CLKRATE 32'd1

  always@(negedge clk_i) begin
    case (state)
      `SSTOP: begin
        case (signal_i)
          `K3: begin
            state <= `SSTART;
          end
        endcase
      end
      `SSTART: begin
        if (counter == `CLKRATE) begin
          counter <= 1;
          second  <= second + 1;
        end else begin
          counter <= counter + 1;
        end
        case (signal_i)
          `K1: begin
            state <= `SSTOP;
            counter <= 0;
            second  <= 0;
          end
          `K3: begin
            state <= `SPAUSE;
          end
        endcase
      end
      `SPAUSE: begin
        case (signal_i)
          `K1: begin
            state <= `SSTOP;
            counter <= 0;
            second  <= 0;
          end
          `K3: begin
            state <= `SSTART;
          end
        endcase
      end
    endcase
  end

  endmodule

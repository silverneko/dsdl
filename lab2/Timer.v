module Timer(clk_i, signal_i, second_o);
  input clk_i;
  input [1:0] signal_i;
  output reg [31:0] second_o;

  reg [31:0] counter;
  reg [1:0] state;

  `define SSTOP  2'b00
  `define SSTART 2'b01
  `define SPAUSE 2'b10

  initial begin
    state = `SSTOP;
    counter = 0;
    second_o = 0;
  end

  always@(negedge clk_i) begin
    if (state == `SSTART) begin
      if (counter == 32'd1)
      //if (counter == 32'd50000000)
        begin
          counter <= 1;
          second_o <= second_o + 1;
        end
      else
        counter <= counter + 1;
    end
  end

  `define NOP 2'b00
  `define K1  2'b01
  `define K2  2'b10
  `define K3  2'b11

  always@(signal_i) begin
    case (state)
      `SSTOP: begin
        case (signal_i)
          `K3: begin
            state <= `SSTART;
          end
        endcase
      end
      `SSTART: begin
        case (signal_i)
          `K1: begin
            state <= `SSTOP;
            counter <= 0;
            second_o <= 0;
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
            second_o <= 0;
          end
          `K3: begin
            state <= `SSTART;
          end
        endcase
      end
    endcase
  end

endmodule

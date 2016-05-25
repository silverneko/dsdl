module Testbench();
  reg clk;
  reg [2:0] key_press;
  wire [31:0] second;

  always #(1) clk = ~clk;

  Timer timer(clk, key_press, second);  

  `define NOP 3'b000
  `define K0  3'b100
  `define K1  3'b101
  `define K2  3'b110
  `define K3  3'b111

  initial begin
    clk = 1;
    #200
    $fdisplay(1, "%d", second);
    key_press = `K3;
#1
    key_press = `NOP;
    #200
    $fdisplay(1, "%d", second);
    key_press = `K3;
#1
    key_press = `NOP;
    #200
    $fdisplay(1, "%d", second);
    key_press = `K3;
#1
    key_press = `NOP;
    #200
    $fdisplay(1, "%d", second);
    key_press = `K3;
#1
    key_press = `NOP;
    #200
    $fdisplay(1, "%d", second);
    key_press = `K1;
#1
    key_press = `NOP;
    #200
    $fdisplay(1, "%d", second);

    $stop;

  end

endmodule

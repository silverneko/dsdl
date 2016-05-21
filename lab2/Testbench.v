module Testbench();
  reg clk;
  reg [1:0] key_press;
  wire [31:0] second;

  always #(1) clk = ~clk;

  Timer timer(clk, key_press, second);  

  `define NOP 2'b00
  `define K1  2'b01
  `define K2  2'b10
  `define K3  2'b11

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

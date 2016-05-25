module ShowTime(second_i, data_o);
  input      [31:0] second_i;
  output reg [127:0] data_o;
  
  reg [31:0] t;
  reg [7:0] i;

  `define ZERO 8'b00110000
  `define COLON  8'b00111010
  `define QUOTE  8'b00100010
  `define SPACE 8'b00100000

  always@(second_i) begin
    t = second_i;
    // HH
    i = t / 360000;
    t = t % 360000;
    i = i % 100;
    data_o[7:0]  <= `ZERO + (i / 10);
    data_o[15:8] <= `ZERO + (i % 10);
    data_o[23:16] <= `COLON;
    // MM
    i = t / 6000;
    t = t % 6000;
    data_o[31:24] <= `ZERO + (i / 10);
    data_o[39:32] <= `ZERO + (i % 10);
    data_o[47:40] <= `COLON;
    // SS
    i = t / 100;
    t = t % 100;
    data_o[55:48] <= `ZERO + (i / 10);
    data_o[63:56] <= `ZERO + (i % 10);
    data_o[71:64] <= `QUOTE;
    // msms
    data_o[79:72] <= `ZERO + (i / 10);
    data_o[87:80] <= `ZERO + (i % 10);
    data_o[127:88] <= {5{`SPACE}};
  end

endmodule

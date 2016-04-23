module TopLevel(sw, ledr, ledg);
  input  [17:0] sw;
  output [17:0] ledr;
  output [8:0]  ledg;

  wire [5:0] a_in, b_in;
  wire [1:0] op_in;
  wire led_in;

  assign a_in = sw[17:12];
  assign b_in = sw[11: 6];
  assign op_in = sw[1:0];
  assign led_in = sw[2];

  wire [11:0] c_out;
  wire overflow_out;
  wire [39:0] seg7_out;

  assign ledg[8] = overflow_out;

  ALU alu(
    .a_in(a_in),
    .b_in(b_in),
    .c_out(c_out),
    .op_in(op_in),
    .overflow(overflow_out)
  );

  Mux1 #(12) mux(
    .a_in({a_in, b_in}),
    .b_in(c_out),
    .s_in(led_in),
    .s_out(ledr[17:6])
  );

  Display7seg display7seg(
    .a_in(c_out),
    .s_out(seg7_out)
  );

endmodule

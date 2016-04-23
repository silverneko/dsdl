module TopLevel(sw, ledr, ledg, seg7_out);
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
  output wire [39:0] seg7_out;

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

  wire [39:0] display7seg_out;
  assign  seg7_out = ~display7seg_out;
  wire [11:0] display7seg_in;
  assign display7seg_in = op_in[1] ? c_out : {{6{c_out[5]}}, c_out[5:0]};
  Display7seg display7seg(
    .a_in(display7seg_in),
    .s_out(display7seg_out)
  );

endmodule

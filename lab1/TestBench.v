module TestBench;
  reg   [5:0] a, b;
  reg   [1:0] op;
  wire  [5:0] hi, lo;
  wire  [11:0] c;
  wire  overflow;

  assign {hi, lo} = c;

  ALU alu(
    .a_in(a),
    .b_in(b),
    .c_out(c),
    .op_in(op),
    .overflow(overflow)
  );

  `define OPADD 2'b00
  `define OPSUB 2'b01
  `define OPMUL 2'b10
  `define OPDIV 2'b11

  initial begin
    a = 0;
    b = 0;
    op = `OPMUL;
#10
    a = 6'b011110;
    b = 6'b010001;
    op = `OPDIV;
#10
    a = 6'b011110;
    b = 6'b000001;
    op = `OPDIV;
  end
endmodule

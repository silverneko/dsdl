module ALU(a_in, b_in, op_in, c_out, overflow);
  input  [5:0] a_in, b_in;
  input  [1:0] op_in;
  output reg [11:0] c_out;
  output reg overflow;

  `define OPADD 2'b00
  `define OPSUB 2'b01
  `define OPMUL 2'b10
  `define OPDIV 2'b11

  /*
  * Adder
  */
  Adder6 adder(
    .a_in(a_in),
    .b_in(b_in),
    .s_out()
  );

  /*
  * Substract (by adding with two's compliment)
  */
  TwosCompliment tc(
    .a_in(b_in),
    .a_out()
  );
  Adder6 suber(
    .a_in(a_in),
    .b_in(tc.a_out),
    .s_out()
  );

  /*
  * multiply
  */
  Multiplier muler(
    .a_in(a_in),
    .b_in(b_in),
    .c_out()
  );

  /*
  * divider
  */
  Divider diver(
    .a_in(a_in),
    .b_in(b_in),
    .c_out()
  );

  initial begin
    c_out = 12'b0;
    overflow = 1'b0;
  end

  always@(a_in, b_in, op_in) #1 begin
    case (op_in)
      `OPADD: begin
        c_out = {6'b0, adder.s_out};
        overflow = (a_in[5] & b_in[5] & ~c_out[5])
                 | (~a_in[5] & ~b_in[5] & c_out[5]);
      end
      `OPSUB: begin
        c_out = {6'b0, suber.s_out};
        overflow = (suber.a_in[5] & suber.b_in[5] & ~c_out[5])
                 | (~suber.a_in[5] & ~suber.b_in[5] & c_out[5]);
      end
      `OPMUL: begin
        c_out = muler.c_out;
        overflow = (a_in[5] & b_in[5] & ~c_out[11])
                 | (~a_in[5] & ~b_in[5] & c_out[11]);
      end
      `OPDIV: begin
        c_out = diver.c_out;
        overflow = 0;
      end
    endcase
  end

endmodule

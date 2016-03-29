module TestBench;
  reg a, b, c;
  wire s_out, c_out;
  Adder1 adder(
    .a_in(a),
    .b_in(b),
    .c_in(c),
    .s_out(s_out),
    .c_out(c_out)
  );

  integer i, j, k;
  initial begin
    for (i = 0; i <= 1; i = i+1) begin
      for (j = 0; j <= 1; j = j+1) begin
        for (k = 0; k <= 1; k = k+1) begin
          a = i;
          b = j;
          c = k;
          #100;
        end
      end
    end
  end
endmodule;

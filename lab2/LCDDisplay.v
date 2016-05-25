module LCDDisplay(clk_i, func_i, data_i, func_o, data_o);
  input       clk_i;
  input [1:0] func_i;
  input [127:0] data_i; // array of 16 chars
  reg   [7:0] data_c [0:31];

  // consult LCD's datasheet about the output format
  output reg [1:0] func_o;
  output reg [7:0] data_o;

  `define IDLE 1'b0
  `define BUSY 1'b1

  integer   i;
  reg       state;
  reg [1:0] lcd_clr_state;
  integer   lcd_clr_cyc;
  reg [2:0] lcd_wrt_state;
  integer   lcd_wrt_cyc;
  reg [6:0] ddram_addr;
  integer   cursor_pos;


  initial begin
    state = `BUSY;
    for (i = 0; i < 31; i = i + 1) begin
      data_c[i] = 8'b0;
    end
    func_o = 2'b0;
    data_o = 8'b0;
    lcd_clr_state = 2'b00;
    lcd_wrt_state = 3'b000;
    state = `IDLE;
  end

  `define LCDCLEAR 2'b10
  `define LCDWRITE 2'b11

  always@(func_i) begin
    if (func_i[1] && state == `IDLE) begin
      state = `BUSY;
      case (func_i)
        `LCDCLEAR: begin
          for (i = 0; i < 31; i = i + 1) begin
            data_c[i] = 8'b0;
          end
          lcd_clr_state = 2'b01;
        end
        `LCDWRITE: begin
          for (i = 0; i < 16; i = i + 1) begin
            data_c[i + 16] = data_c[i];
          end
          data_c[0] = data_i[7:0];
          data_c[1] = data_i[15:8];
          data_c[2] = data_i[23:16];
          data_c[3] = data_i[31:24];
          data_c[4] = data_i[39:32];
          data_c[5] = data_i[47:40];
          data_c[6] = data_i[55:48];
          data_c[7] = data_i[63:56];
          data_c[8] = data_i[71:64];
          data_c[9] = data_i[79:72];
          data_c[10] = data_i[87:80];
          data_c[11] = data_i[95:88];
          data_c[12] = data_i[103:96];
          data_c[13] = data_i[111:104];
          data_c[14] = data_i[119:112];
          data_c[15] = data_i[127:120];
          cursor_pos = 0;
          ddram_addr = 7'b0000000;
          lcd_wrt_state = 3'b001;
        end
      endcase
    end
  end

  always@(negedge clk_i) begin
    case (lcd_clr_state)
      2'b00: begin
        // do nothing
      end
      2'b01: begin
        func_o <= 2'b00;
        data_o <= 8'b00000001;
        lcd_clr_state <= 2'b10;
        lcd_clr_cyc <= 80000;
      end
      2'b10: begin
        if (lcd_clr_cyc != 0) begin
          lcd_clr_cyc <= lcd_clr_cyc - 1;
        end else begin
          lcd_clr_state <= 2'b00;
          state <= `IDLE;
        end
      end
    endcase
  end

  always@(negedge clk_i) begin
    case (lcd_wrt_state)
      3'b000: begin
        // do nothing
      end
      3'b001: begin
        if (ddram_addr == 7'h50) begin
          lcd_wrt_state <= 3'b000;
          state <= `IDLE;
        end else begin
          func_o <= 2'b00;
          data_o <= {1'b1, ddram_addr};
          if (ddram_addr == 7'h0F) begin
            ddram_addr <= 7'h40;
          end else begin
            ddram_addr <= ddram_addr + 7'b1;
          end
          lcd_wrt_state <= 3'b010;
          lcd_wrt_cyc <= 2500;
        end
      end
      3'b010: begin
        if (lcd_wrt_cyc != 0) begin
          lcd_wrt_cyc <= lcd_wrt_cyc - 1;
        end else begin
          lcd_wrt_state <= 3'b011;
        end
      end
      3'b011: begin
        func_o <= 2'b10;
        data_o <= data_c[cursor_pos];
        cursor_pos <= cursor_pos + 1;
        lcd_wrt_state <= 3'b100;
        lcd_wrt_cyc <= 2500;
      end
      3'b100: begin
        if (lcd_wrt_cyc != 0) begin
          lcd_wrt_cyc <= lcd_wrt_cyc - 1;
        end else begin
          lcd_wrt_state <= 3'b001;
        end
      end
    endcase
  end

endmodule

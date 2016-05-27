module TopLevel(clk,
  key_in,
  s_out,
  LCD_ON,
  LCD_BLON,
  LCD_EN,
  LCD_RW,
  LCD_RS,
  LCD_DATA
);
	input [3:0] key_in;
        // 50Mhz clock signal
        input clk;
	output [63:0] s_out;
	wire [63:0] seg_o;
	assign s_out = ~seg_o;
        output LCD_ON, LCD_BLON, LCD_EN, LCD_RW, LCD_RS;
        output [7:0]  LCD_DATA;

        assign LCD_ON = 1;
        assign LCD_BLON = 1;

        wire [1:0] lcd_func;
        wire [7:0] lcd_data;

        assign LCD_RS = lcd_func[1];
        assign LCD_RW = lcd_func[0];
        assign LCD_DATA = lcd_data;

	wire [31:0] second;
	wire [2:0] key_press;

	Timer timer(clk, key_press, second);
	Display7seg display7seg(second, seg_o);

        wire [127:0] show_time;
        ShowTime showTime(second, show_time);
        LCDDisplay lcdDisplay(clk, key_press, show_time, LCD_EN, lcd_func, lcd_data);

  	// I remember TA said press means 1 to 0. Need some try.
        ButtonSignal buttonSignal(clk, key_in, key_press);

endmodule

module TopLevel(clk, key_in, s_out, lcd_func, lcd_data);
	input [3:0] key_in;
        // 50Mhz clock signal
        input clk;
	output [63:0] s_out;
        output [1:0] lcd_func;
        output [7:0] lcd_data;

	wire [31:0] second;
	wire [2:0] key_press;

	Timer timer(clk, key_press, second);
	Display7seg display7seg(second, s_out);

        wire [127:0] show_time;
        ShowTime showTime(second, show_time);
        LCDDisplay lcdDisplay(clk, key_press, show_time, lcd_func, lcd_data);

  	// I remember TA said press means 1 to 0. Need some try.
        ButtonSignal buttonSignal(clk, key_in, key_press);

endmodule

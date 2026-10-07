module Driver_OLED (
	input gclk,
	input [15:0] four_digit_input,
	input lap_flag,
	output reg oled_csel,
	output reg oled_mode,
	output reg oled_rset,
	output oled_sclk,
	output oled_sdin,
	output reg oled_vscr,
	output reg oled_vlog);
endmodule

////////////////////////////////////////////////////////////
//// Example of usage (with standard-named constraints) ////
////////////////////////////////////////////////////////////

// Driver_OLED driver_OLED_instance (
// 	.gclk(CLK_125M),
// 	.four_digit_input(<your 16-bit reg>),
// 	.lap_flag(<your 1-bit reg>),
// 	.oled_csel(OLED_CSEL),
// 	.oled_mode(OLED_MODE),
// 	.oled_rset(OLED_RSET),
// 	.oled_sclk(OLED_SCLK),
// 	.oled_sdin(OLED_SDIN),
// 	.oled_vscr(OLED_VSCR),
// 	.oled_vlog(OLED_VLOG)
// );

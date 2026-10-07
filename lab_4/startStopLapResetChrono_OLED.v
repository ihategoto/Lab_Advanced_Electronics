module startStopLapResetChrono_OLED	(	CLK_125M,
					SW,
					PUSH_BTN_SS, PUSH_BTN_LR,

					B_LED,
					LED,
					OLED_CSEL,
					OLED_MODE,
					OLED_RSET,
					OLED_SCLK,
					OLED_SDIN,
					OLED_VSCR,
					OLED_VLOG,);

input		CLK_125M;
input		SW;
input		PUSH_BTN_SS;
input		PUSH_BTN_LR;

output	[3:0]	B_LED;
output	[7:0]	LED;
output OLED_CSEL;
output OLED_MODE;
output OLED_RSET;
output OLED_SCLK;
output OLED_SDIN;
output OLED_VSCR;
output OLED_VLOG;

wire	[15:0]	wb_counter;
wire	[15:0]	wb_counter_toShow;

wire		w_startStop;
wire		w_lapFlag;
wire		w_reset;

Driver_OLED driver_OLED_instance (
				.gclk(CLK_125M),
				.four_digit_input(wb_counter_toShow),
				.lap_flag(w_lapFlag),
				.oled_csel(OLED_CSEL),
				.oled_mode(OLED_MODE),
				.oled_rset(OLED_RSET),
				.oled_sclk(OLED_SCLK),
				.oled_sdin(OLED_SDIN),
				.oled_vscr(OLED_VSCR),
				.oled_vlog(OLED_VLOG)
);

/****************************************/
/*** ... and hereafter what's left... ***/
/****************************************/

endmodule

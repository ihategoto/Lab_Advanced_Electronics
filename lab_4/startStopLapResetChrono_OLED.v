`define		period_1_kHz	30'd62500
`define	halfPeriod_100_Hz	30'd625000

module startStopLapResetChrono_OLED	(
	CLK_125M,
	SW,
	PUSH_BTN_SS,
	PUSH_BTN_LR,
	OLED_CSEL,
	OLED_MODE,
	OLED_RSET,
	OLED_SCLK,
	OLED_SDIN,
	OLED_VSCR,
	OLED_VLOG);

input		CLK_125M;
input		SW;
input		PUSH_BTN_SS;
input		PUSH_BTN_LR;

output OLED_CSEL;
output OLED_MODE;
output OLED_RSET;
output OLED_SCLK;
output OLED_SDIN;
output OLED_VSCR;
output OLED_VLOG;

// wires for buttons
wire 		w_btn_ss;
wire 		w_btn_lr;
// wire for reset pulse
wire		w_reset;
// 3 bit FSM state
wire [2:0] 	wb_state;

// wires for clocks
wire w_clock_100_Hz;
wire w_carry_10_Hz;
wire w_carry_1_Hz;
wire w_carry_100_mHz;

wire	[15:0]	wb_counter;
wire	[15:0]	wb_counter_toShow;

// stop button
Module_MonostableMultivibrator button_ss(
	.clk(CLK_125M),
	.duration(`period_1_kHz),
	.button(PUSH_BTN_SS),
	.flag(w_btn_ss)
);

// lap button
Module_MonostableMultivibrator button_lr(
	.clk(CLK_125M),
	.duration(`period_1_kHz),
	.button(PUSH_BTN_LR),
	.flag(w_btn_lr)
);

// 100Hz clock from the master clock
Module_FrequencyDivider clock_100_Hz_generator (
	.clk_in(CLK_125M),
	.half_period(`halfPeriod_100_Hz),
	.clk_out(w_clock_100_Hz)
);

// Stopwatch's FSM
Module_FSM_Core fsm(
	.clk(CLK_125M),
	.ss(w_btn_ss),
	.lr(w_btn_lr),
	.state(wb_state),
	.reset(w_reset)
);

Module_SyncCounter_State_8_bit counter_100_Hz(
	.master_clk(CLK_125M),
	.clk_in(w_clock_100_Hz),
	.stop(wb_state != 3'd2 && wb_state != 3'd3),
	.reset(w_reset),
	.limit(4'd10),
	.out(wb_counter[3:0]),
	.carry(w_carry_10_Hz)
);

Module_SyncCounter_State_8_bit counter_10_Hz(
	.master_clk(CLK_125M),
	.clk_in(w_carry_10_Hz),
	.stop(wb_state != 3'd2 && wb_state != 3'd3),
	.reset(w_reset),
	.limit(4'd10),
	.out(wb_counter[7:4]),
	.carry(w_carry_1_Hz)
);

Module_SyncCounter_State_8_bit counter_1_Hz(
	.master_clk(CLK_125M),
	.clk_in(w_carry_1_Hz),
	.stop(wb_state != 3'd2 && wb_state != 3'd3),
	.reset(w_reset),
	.limit(4'd10),
	.out(wb_counter[11:8]),
	.carry(w_carry_100_mHz)
);

Module_SyncCounter_State_8_bit counter_100_mHz(
	.master_clk(CLK_125M),
	.clk_in(w_carry_100_mHz),
	.stop(wb_state != 3'd2 && wb_state != 3'd3),
	.reset(w_reset),
	.limit(4'd10),
	.out(wb_counter[15:12])
);

Module_Latch_16_bit latch(
	.clk(CLK_125M),
	.in(wb_counter),
	.out(wb_counter_toShow),
	.flag(wb_state == 3'd3 || wb_state == 3'd4)
);

Driver_OLED driver_OLED_instance (
				.gclk(CLK_125M),
				.four_digit_input(wb_counter_toShow),
				.lap_flag(wb_state == 3'd3 || wb_state == 3'd4),
				.oled_csel(OLED_CSEL),
				.oled_mode(OLED_MODE),
				.oled_rset(OLED_RSET),
				.oled_sclk(OLED_SCLK),
				.oled_sdin(OLED_SDIN),
				.oled_vscr(OLED_VSCR),
				.oled_vlog(OLED_VLOG)
);

endmodule

`define		period_1_kHz	30'd62500
`define	halfPeriod_100_Hz	30'd625000

module finiteStateMachine(CLK_125M, PUSH_BTN_SS, PUSH_BTN_LR, SW, LED);

input		CLK_125M;
input		PUSH_BTN_SS;
input		PUSH_BTN_LR;
input 		SW;

output [7:0]	LED;

wire 		w_btn_ss;
wire 		w_btn_lr;
wire		w_reset;
wire [2:0] 	wb_state;

// bitstrings representing cents and secs
wire [7:0] wb_cents;
wire [7:0] wb_secs;

// wires for clocks
wire w_clock_100_Hz;
wire w_carry_10_Hz;
wire w_carry_1_Hz;
wire w_carry_100_mHz;

// latch wire
wire [7:0] wb_latch;

// 100Hz clock from the master clock
Module_FrequencyDivider clock_100_Hz_generator (
	.clk_in(CLK_125M),
	.half_period(`halfPeriod_100_Hz),
	.clk_out(w_clock_100_Hz)
);

Module_MonostableMultivibrator button_ss(
	.clk(CLK_125M),
	.duration(`period_1_kHz),
	.button(PUSH_BTN_SS),
	.flag(w_btn_ss)
);

Module_MonostableMultivibrator button_lr(
	.clk(CLK_125M),
	.duration(`period_1_kHz),
	.button(PUSH_BTN_LR),
	.flag(w_btn_lr)
);

FSM_Core fsm(
	.clk(CLK_125M),
	.ss(w_btn_ss),
	.lr(w_btn_lr),
	.state(wb_state),
	.reset(w_reset)
);

Module_SyncCounter_State_8_bit counter_100_Hz(
	.master_clk(CLK_125M),
	.clk(w_clock_100_Hz),
	.stop(wb_state != 3'd2 && wb_state != 3'd3),
	.reset(w_reset),
	.limit(4'd10),
	.out(wb_cents[3:0]),
	.carry(w_carry_10_Hz)
);

Module_SyncCounter_State_8_bit counter_10_Hz(
	.master_clk(CLK_125M),
	.clk(w_carry_10_Hz),
	.stop(wb_state != 3'd2 && wb_state != 3'd3),
	.reset(w_reset),
	.limit(4'd10),
	.out(wb_cents[7:4]),
	.carry(w_carry_1_Hz)
);

Module_SyncCounter_State_8_bit counter_1_Hz(
	.master_clk(CLK_125M),
	.clk(w_carry_1_Hz),
	.stop(wb_state != 3'd2 && wb_state != 3'd3),
	.reset(w_reset),
	.limit(4'd10),
	.out(wb_secs[3:0]),
	.carry(w_carry_100_mHz)
);

Module_SyncCounter_State_8_bit counter_100_mHz(
	.master_clk(CLK_125M),
	.clk(w_carry_100_mHz),
	.stop(wb_state != 3'd2 && wb_state != 3'd3),
	.reset(w_reset),
	.limit(4'd10),
	.out(wb_secs[7:4])
);

// output multiplexer addressed by the switch
Module_Multiplexer_16_8_bit multiplexer (
	.clk(CLK_125M),
	.addr(SW),
	.input_1(wb_secs),
	.input_2(wb_cents),
	.out(wb_latch)
);

Module_Latch_8_bit latch(
	.clk(CLK_125M),
	.in(wb_latch),
	.out(LED),
	.button(wb_state == 3'd3 || wb_state == 3'd4)
);


endmodule

// number of edges of the master clock the LED must be on for
`define duration 30'd62500
`define	halfPeriod_100_Hz	30'd625000

module FullCounter(CLK_125M, STOP, REVERSE, LAP, RESET, LED);
// master clock
input CLK_125M;
// buttons 
input STOP;
input REVERSE;
input LAP;
input RESET;

// wires for buttons
wire w_stop;
wire w_reverse;
wire w_lap;
wire w_reset;

// wires for clocks
wire w_clock_100_Hz;
wire w_carry_10_Hz;
wire w_carry_1_Hz;
wire w_carry_100_mHz;

// bitstring representing cents and secs
wire [7:0] wb_cents;
wire [7:0] wb_secs;

// output LED
output [7:0] LED;

// 100Hz clock from the master clock
Module_FrequencyDivider clock_100_Hz_generator (
	.clk_in(CLK_125M),
	.half_period(`halfPeriod_100_Hz),
	.clk_out(w_clock_100_Hz)
);

Module_MonostableMultivibrator b_stop(
	.clk(CLK_125M),
	.duration(`duration),
	.button(STOP),
	.flag(w_stop)
);

Module_MonostableMultivibrator b_reverse(
	.clk(CLK_125M),
	.duration(`duration),
	.button(REVERSE),
	.flag(w_reverse)
);

Module_MonostableMultivibrator b_lap(
	.clk(CLK_125M),
	.duration(`duration),
	.button(LAP),
	.flag(w_lap)
);

Module_MonostableMultivibrator b_reset(
	.clk(CLK_125M),
	.duration(`duration),
	.button(RESET),
	.flag(w_reset)
);

Module_SyncCounter_Advanced_8_bit counter_100_Hz(
	.master_clk(CLK_125M),
	.clk_in(w_clock_100_Hz),
	.stop(w_stop),
	.reverse(w_reverse),
	.reset(w_reset),
	.limit(4'd10),
	.out(wb_cents[3:0]),
	.carry(w_clock_10_Hz),
);

Module_SyncCounter_Advanced_8_bit counter_10_Hz(
	.master_clk(CLK_125M),
	.clk_in(w_clock_10_Hz),
	.stop(w_stop),
	.reverse(w_reverse),
	.reset(w_reset),
	.limit(4'd10),
	.out(wb_cents[7:4]),
	.carry(w_clock_1_Hz),
);

Module_SyncCounter_Advanced_8_bit counter_1_Hz(
	.master_clk(CLK_125M),
	.clk_in(w_clock_1_Hz),
	.stop(w_stop),
	.reverse(w_reverse),
	.reset(w_reset),
	.limit(4'd10),
	.out(wb_secs[3:0]),
	.carry(w_clock_100_mHz),
);

Module_SyncCounter_Advanced_8_bit counter_100_mHz(
	.master_clk(CLK_125M),
	.clk_in(w_clock_100_mHz),
	.stop(w_stop),
	.reverse(w_reverse),
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
	.out(LED)
);

endmodule

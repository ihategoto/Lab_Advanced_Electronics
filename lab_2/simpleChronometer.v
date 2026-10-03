// 125x10^6 / (1.25x10^6) = 100 (Hz) -> halfPeriod = 1.25x10^6 / 2 = 625000
`define	halfPeriod_100_Hz	30'd625000

module simpleChronometer(CLK_125M, SW, BTN_3, LED);
// master clock
input CLK_125M;
// digit switch
input SW;
// stop button
input BTN_3;

// wires for all the clocks involved
wire w_clock_100_Hz;
wire w_carry_10_Hz;
wire w_carry_1_Hz;
wire w_carry_100_mHz;

// bitstring representing cents and secs
wire [7:0] wb_cents;
wire [7:0] wb_secs;
// stop wire
wire stop;

// output LED
output	[7:0]	LED;

// 100Hz clock from the master clock
Module_FrequencyDivider clock_100_Hz_generator (
	.clk_in(CLK_125M),
	.half_period(`halfPeriod_100_Hz),
	.clk_out(w_clock_100_Hz)
);

// synchronous toggle button
Module_Toggle_Button toggle_btn (
	.clk(CLK_125M),
	.button(BTN_3),
	.flag(stop)
);

// cents counter
Module_SyncCounter_8_bit counter_100_Hz (
	.master_clk(CLK_125M),
	.stop(stop),
	.clk_in(w_clock_100_Hz),
	.limit(8'b00001010),
	.carry(w_carry_10_Hz),
	.out(wb_cents[3:0])
);

// tens of cents counter
Module_SyncCounter_8_bit counter_10_Hz (
	.master_clk(CLK_125M),
	.stop(stop),
	.clk_in(w_carry_10_Hz),
	.limit(8'b00001010),
	.carry(w_carry_1_Hz),
	.out(wb_cents[7:4])
);

// secs counter
Module_SyncCounter_8_bit counter_1_Hz (
	.master_clk(CLK_125M),
	.stop(stop),
	.clk_in(w_carry_1_Hz),
	.limit(8'b00001010),
	.carry(w_carry_100_mHz),
	.out(wb_secs[3:0])
);

// tens of secs counter
Module_SyncCounter_8_bit counter_100_mHz (
	.master_clk(CLK_125M),
	.stop(stop),
	.clk_in(w_carry_100_mHz),
	.limit(8'b00001010),
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

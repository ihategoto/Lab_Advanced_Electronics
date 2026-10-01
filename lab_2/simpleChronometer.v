`define		defaultHalfPeriod	30'd62500000
`define		halfPeriod_100_Hz	30'd625000


module simpleChronometer(CLK_125M, SW, BTN_3, LED);

input		CLK_125M;
input		SW;
input 		BTN_3;

wire w_clock_100_Hz;
wire w_carry_10_Hz;
wire w_carry_1_Hz;
wire w_carry_100_mHz;

wire [7:0] wb_cents;
wire [7:0] wb_secs;

output	[7:0]	LED;

Module_FrequencyDivider clock_100_Hz_generator (
						.clk_in(CLK_125M),
						.half_period(`halfPeriod_100_Hz),
						.clk_out(w_clock_100_Hz)
);

Module_sync_counter_8_bit counter_100_Hz (
	.master_clk(CLK_125M),
	.stop(BTN_3),
	.clk_in(w_clock_100_Hz),
	.limit(8'b00001010),
	.carry(w_carry_10_Hz),
	.out(wb_cents[3:0])
);

Module_sync_counter_8_bit counter_10_Hz (
	.master_clk(CLK_125M),
	.stop(BTN_3),
	.clk_in(w_carry_10_Hz),
	.limit(8'b00001010),
	.carry(w_carry_1_Hz),
	.out(wb_cents[7:4])
);

Module_sync_counter_8_bit counter_1_Hz (
	.master_clk(CLK_125M),
	.stop(BTN_3),
	.clk_in(w_carry_1_Hz),
	.limit(8'b00001010),
	.carry(w_carry_100_mHz),
	.out(wb_secs[3:0])
);

Module_sync_counter_8_bit counter_100_mHz (
	.master_clk(CLK_125M),
	.stop(BTN_3),
	.clk_in(w_carry_100_mHz),
	.limit(8'b00001010),
	.out(wb_secs[7:4])
);

Multiplexer_16_8_bit multiplexer (
	.clk(CLK_125M),
	.addr(SW),
	.input_1(wb_secs),
	.input_2(wb_cents),
	.out(LED)
);

endmodule

`define		duration_1_Hz	30'd125000000
module pushLightSwitch	(	CLK_125M,
				PUSHBUTTON,
				LED_1,
				LED);

input		CLK_125M;
input		PUSHBUTTON;

wire 		w_flag;
wire 		w_clock_1_Hz;

output		LED;
output LED_1;

assign LED_1 = PUSHBUTTON;

/*
Module_FrequencyDivider clock_100_Hz_generator (
						.clk_in(CLK_125M),
						.half_period(`halfPeriod_1_Hz),
						.clk_out(w_clock_1_Hz)
);
*/
/*
Toggle_button toggle (
	.clk(CLK_125M),
	.button(PUSHBUTTON),
	.flag(w_flag)
);
*/
Module_monostable_multivibrator monostable_multivibrator(
	.clk(CLK_125M),
	.duration(`duration_1_Hz),
	.button(PUSHBUTTON),
	.flag(LED)
);

/*
Multiplexer_2_1_bit multiplexer_2_1 (
	.clk(CLK_125M),
	.addr(w_flag),
	.input_1(1'b1),
	.input_2(1'b0),
	.out(LED)
);
*/
endmodule

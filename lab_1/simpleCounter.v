// like #define in C
//`define defaultHalfPeriod 30'b000011101110011010110010100000 // 62.5 10^6
// 62.5 10^5
`define defaultHalfPeriod 30'b000000010111110101111000010000

module simpleCounter (
		CLK_125M,

		LED);

input 		CLK_125M;

output [7:0]	LED;

//wire		w_clock_1_Hz;
wire		w_clock_10_Hz;
wire		w_carry;

// module_name instance_name
/*
Module_FrequencyDivider clock_1_Hz_generator (
						.clk_in(CLK_125M),
						.half_period(`defaultHalfPeriod),

						.clk_out(w_clock_1_Hz));
*/
Module_FrequencyDivider clock_10_Hz_generator (
						.clk_in(CLK_125M),
						.half_period(`defaultHalfPeriod),
						.clk_out(w_clock_10_Hz)
);

Module_Counter_8_bit counter_units (
						.clk_in(w_clock_10_Hz),
						.limit(8'b00001010),
						.out(LED[3:0]),
						.carry(w_carry)
);

Module_Counter_8_bit counter_tens (
						.clk_in(w_carry),
						.limit(8'b00001010),
						.out(LED[7:4])
);						

endmodule

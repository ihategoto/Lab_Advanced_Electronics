module ShiftRegister(CLK_125M, pushButton, SW, LED, B_LED);

input CLK_125M;
input pushButton;
input SW;

//input SW;
output [7:0] LED;
output B_LED;

wire w_write_freq;
wire w_button;

// 125 MHz / 125000000 = 1 Hz write frequency
Module_FrequencyDivider freq_generator(
	.clk_in(CLK_125M), 
	.half_period(32'd62500000),	
	.clk_out(w_write_freq)
);

Module_MonostableMultivibrator led(
    .clk_in(CLK_125M),
    .duration(32'd12500000),
    .in(w_write_freq),
    .out_state(B_LED)
);

Module_MonostableMultivibrator button(
    .clk_in(CLK_125M),
    .duration(32'd30),
    .in(pushButton),
    .out_state(w_button)
);

Module_ShiftRegister_8_bit sr(
    .clk_in(CLK_125M),
    .write_clk(w_write_freq),
    .closed_loop(SW),
    .data_sig(w_button),
    .data_out(LED)
);

endmodule
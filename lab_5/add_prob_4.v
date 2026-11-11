module PseudoRandom(
    input CLK_125M,
	output DAC_SDA1,
	output DAC_SDA2,
	output DAC_CSEL,
	output DAC_SCLK
);

wire w_write_freq;
wire signed [11:0] wb_out;
wire signed [11:0] dummy;

assign dummy = wb_out;

// 125 MHz / 125000000 = 1 Hz write frequency
Module_FrequencyDivider freq_generator(
	.clk_in(CLK_125M), 
	.half_period(32'd62500000),	
	.clk_out(w_write_freq)
);

Module_PseudoRandom_12_bit pr(
    .clk_in(CLK_125M),
    .write_clk(w_write_freq),
    .data_out(wb_out)
);

Driver_DAC driver_DAC_instance(
	.gclk(CLK_125M),
	.data_ch_1(wb_out),
	.data_ch_2(dummy),
	.mode_ch_1({2'b00}),
	.mode_ch_2({2'b00}),
	.start_write(w_write_freq),
	.dac_sda1(DAC_SDA1),
	.dac_sda2(DAC_SDA2),
	.dac_csel(DAC_CSEL),
	.dac_sclk(DAC_SCLK)
);


endmodule
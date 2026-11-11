`define k 3'd4
`define amplitude 12'b000011111111
module Differentiator_Delayer(
	input CLK_125M,
	input pushButton,
	input SW,
	output DAC_SDA1,
	output DAC_SDA2,
	output DAC_CSEL,
	output DAC_SCLK
);

wire w_sampling_trigger;
wire w_data_ready;
wire signed [23:0] wb_V1;
wire signed [11:0] wb_delayed;
wire signed [11:0] wb_differ;
wire signed [11:0] wb_V2;

// 125 MHz / 1250 = 100 kHz sampling frequency
Module_Posedge_Counter_32_bit sampling_trigger_generator(
	.clk_in(CLK_125M), 
	.limit(32'd1250),		
	.carry(w_sampling_trigger)
);

Module_HarmonicOscillator_24_bit ho(
	.clk_in(CLK_125M),
	.write_clk(w_sampling_trigger),
	.k(`k),
	.amplitude({`amplitude, 12'b0}),
	.load(pushButton),
	.out_sig(wb_V1),
    .data_ready(w_data_ready)
);

Module_Delayer_12_bit delayer(
	.clk_in(CLK_125M),
	.delay_clk(w_data_ready),
	.in_sig(wb_V1[23:12]),
	.out_sig(wb_delayed)
);

Module_Differentiator_Adv_12_bit differ(
    .clk_in(CLK_125M),
    .write_clk(w_data_ready),
    .in_sig(wb_V1[23:12]),
    .out_sig(wb_differ)
);

Module_Multiplexer_32_16_bit mux(
    .clk_in(CLK_125M),
    .addr(SW),
    .in_1(wb_delayed),
    .in_2(wb_differ),
    .out(wb_V2)
);

Driver_DAC driver_DAC_instance(
	.gclk(CLK_125M),
	.data_ch_1(wb_V1[23:12]),
	.data_ch_2(wb_V2),
	.mode_ch_1({2'b00}),
	.mode_ch_2({2'b00}),
	.start_write(w_data_ready),
	.dac_sda1(DAC_SDA1),
	.dac_sda2(DAC_SDA2),
	.dac_csel(DAC_CSEL),
	.dac_sclk(DAC_SCLK)
);

endmodule

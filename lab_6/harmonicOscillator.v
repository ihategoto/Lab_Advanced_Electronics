`define k 4'd4
`define amplitude 24'b000010100000000000000000

module harmonicOscillator(
	input			CLK_125M,
	input	[3:0]	SW,
	input			pushButton,
	output			DAC_SDA1,
	output			DAC_SDA2,
	output			DAC_CSEL,
	output			DAC_SCLK
);

wire w_sampling_trigger;
wire w_data_ready;
wire w_sign_change;
wire w_load_quadrature;

wire signed [11:0] wb_V1;
wire signed [23:0] wb_V1_undelayed;
wire signed [23:0] wb_V2;

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
	.amplitude(`amplitude),
	.load(pushButton),
	.out_sig(wb_V1_undelayed),
	.data_ready(w_data_ready),
	.sign_change(w_sign_change)
);

Module_SR_FlipFlop SR(
	.clk_in(CLK_125M),
	.data_in(w_sign_change),
	.reset(pushButton),
	.data_out(w_load_quadrature)
);

Module_HarmonicOscillator_24_bit ho_quad(
	.clk_in(CLK_125M),
	.write_clk(w_sampling_trigger),
	.k(`k),
	.amplitude(`amplitude),
	.load(w_load_quadrature),
	.out_sig(wb_V2)
);

Module_Delayer_12_bit(
	.clk_in(CLK_125M),
	.delay_clk(w_data_ready),
	.in_sig(wb_V1_undelayed[23:12]),
	.out_sig(wb_V1)
);

Driver_DAC driver_DAC_instance(
	.gclk(CLK_125M),
	.data_ch_1(wb_V1),
	.data_ch_2(wb_V2[23:12]),
	.mode_ch_1({2'b00}),
	.mode_ch_2({2'b00}),
	.start_write(w_data_ready),
	.dac_sda1(DAC_SDA1),
	.dac_sda2(DAC_SDA2),
	.dac_csel(DAC_CSEL),
	.dac_sclk(DAC_SCLK)
);

endmodule

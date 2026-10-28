module nyquist(CLK_125M,SW, ADC_SDA1, ADC_SDA2, ADC_CSEL, ADC_SCLK, DAC_SDA1, DAC_SDA2, DAC_CSEL, DAC_SCLK);

input		CLK_125M;
input		SW;
input		ADC_SDA1;
input		ADC_SDA2;

output ADC_CSEL;
output ADC_SCLK;
output DAC_SDA1;
output DAC_SDA2;
output DAC_CSEL;
output DAC_SCLK;

wire w_sampling_trigger;
wire w_data_ready;
wire w_busy;
wire signed [11:0]	wb_V1;
wire signed [11:0]	wb_V2;

Module_Counter_32_bit sampling_trigger_generator(.clk_in(CLK_125M), .limit(((SW)? 32'd101297 : 32'd12500)), .carry(w_sampling_trigger));

Driver_ADC driver_ADC_instance (
				.gclk(CLK_125M),
				.adc_sda1(ADC_SDA1),
				.adc_sda2(ADC_SDA2),
				.start_read(w_sampling_trigger),
				.adc_csel(ADC_CSEL),
				.adc_sclk(ADC_SCLK),
				.data_ch_1(wb_V1),
				//.data_ch_2(wb_V2),
				.data_ready(w_data_ready));

Module_Delayer_12_bit delayer(
	.qzt_clk(CLK_125M),
	.delay_sig(w_sampling_trigger),
	.in_sig(wb_V1),
	.out_sig(wb_V2)
);

Driver_DAC driver_DAC_instance (
				.gclk(CLK_125M),
				.data_ch_1(wb_V1),
				.data_ch_2(wb_V2),
				.mode_ch_1({2'b00}),
				.mode_ch_2({2'b00}),
				.start_write(w_data_ready),
				.dac_sda1(DAC_SDA1),
				.dac_sda2(DAC_SDA2),
				.dac_csel(DAC_CSEL),
				.dac_sclk(DAC_SCLK),
				.busy(w_busy));

endmodule

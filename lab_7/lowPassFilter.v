module lowPassFilter	(	CLK_125M,
				SW,
				ADC_SDA1,ADC_SDA2,

				ADC_CSEL,ADC_SCLK,
				DAC_SDA1,DAC_SDA2,DAC_CSEL,DAC_SCLK);

input		CLK_125M;
input	[3:0]	SW;
input		ADC_SDA1;
input		ADC_SDA2;

output 		ADC_CSEL;
output 		ADC_SCLK;
output 		DAC_SDA1;
output 		DAC_SDA2;
output 		DAC_CSEL;
output 		DAC_SCLK;

wire [11:0]	wb_V1;
wire [11:0]	wb_V2;
wire [19:0]	wb_V1_filtered;

wire 		w_sampling_trigger;
wire 		w_data_ready;

Module_Counter_32_bit	sampling_trigger_generator	(	.clk_in(CLK_125M),
								.limit(32'd1250), // 125 MHz / 1250 = 100 kHz

								.carry(w_sampling_trigger));

Driver_DAC driver_DAC_instance (
				.gclk(CLK_125M),
				.data_ch_1(wb_V1),
				.data_ch_2({~wb_V1_filtered[19], wb_V1_filtered[18:8]}),
				.mode_ch_1({2'b00}),
				.mode_ch_2({2'b00}),
				.start_write(w_sampling_trigger),
				.dac_sda1(DAC_SDA1),
				.dac_sda2(DAC_SDA2),
				.dac_csel(DAC_CSEL),
				.dac_sclk(DAC_SCLK));

Driver_ADC driver_ADC_instance (
				.gclk(CLK_125M),
				.adc_sda1(ADC_SDA1),
				.adc_sda2(ADC_SDA2),
				.start_read(w_sampling_trigger),
				.adc_csel(ADC_CSEL),
				.adc_sclk(ADC_SCLK),
				.data_ch_1(wb_V1),
				.data_ch_2(wb_V2),
				.data_ready(w_data_ready));

Module_LowPassFilter	LPF	(
				.qzt_clk(CLK_125M),
				.clk_in(w_data_ready),
				.k(SW),
				.Vin({~wb_V1[11], wb_V1[10:0], 8'd0}),

				.Vout(wb_V1_filtered));

endmodule

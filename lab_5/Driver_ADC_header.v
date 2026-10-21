module Driver_ADC (
	input gclk,
	input adc_sda1,
	input adc_sda2,
	input start_read,
	output reg [11:0] data_ch_1,
	output reg [11:0] data_ch_2,
	output reg adc_csel,
	output adc_sclk,
	output reg data_ready);
endmodule

////////////////////////////////////////////////////////////
//// Example of usage (with standard-named constraints) ////
////////////////////////////////////////////////////////////

// Driver_ADC driver_ADC_instance (
// 	.gclk(CLK_125M),
// 	.adc_sda1(ADC_SDA1),
// 	.adc_sda2(ADC_SDA2),
//	.start_read(<your 1-bit reg>),
// 	.adc_csel(ADC_CSEL),
// 	.adc_sclk(ADC_SCLK),
// 	.data_ch_1(<your 12-bit wire>),
// 	.data_ch_2(<your 12-bit wire>),
// 	.data_ready(<your 1-bit wire>)
// );

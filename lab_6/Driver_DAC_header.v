module Driver_DAC (
	input gclk,
	input [11:0] data_ch_1,
	input [11:0] data_ch_2,
	input [1:0] mode_ch_1,
	input [1:0] mode_ch_2,
	input start_write,
	output reg dac_sda1,
	output reg dac_sda2,
	output reg dac_csel,
	output dac_sclk,
	output reg busy);
endmodule

////////////////////////////////////////////////////////////
//// Example of usage (with standard-named constraints) ////
////////////////////////////////////////////////////////////

// Driver_DAC driver_DAC_instance (
// 	.gclk(CLK_125M),
// 	.data_ch_1(<your 12-bit reg>),
// 	.data_ch_2(<your 12-bit reg>),
//	.mode_ch_1(<your 2-bit reg>),
//	.mode_ch_2(<your 2-bit reg>),
// 	.start_write(<your 1-bit reg>),
// 	.dac_sda1(DAC_SDA1),
// 	.dac_sda2(DAC_SDA2),
// 	.dac_csel(DAC_CSEL),
// 	.dac_sclk(DAC_SCLK),
// 	.busy(<your 1-bit wire>)
// );

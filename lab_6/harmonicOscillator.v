`define		boundaryCondition			24'b000110000000000000000000
`define signed M 16'd4
`define signed A 16'b0000111111111111


module harmonicOscillator	(	CLK_125M,
					SW,
					pushButton, brake,

					DAC_SDA1, DAC_SDA2, DAC_CSEL, DAC_SCLK);

output		DAC_SDA1;
output		DAC_SDA2;
output		DAC_CSEL;
output		DAC_SCLK;

input		CLK_125M;
input		pushButton;
input		brake;	// also a pushButton
input	[3:0]	SW;

wire		w_sampling_trigger;

wire		w_clock_unbraked;
wire		w_clock;

wire	signed [11:0]	wb_V1;
wire	signed [11:0]	wb_V2;

/************************/
/*** CLOCK GENERATION ***/
/************************/
Module_Counter_32_bit		sampling_trigger_generator	(	.clk_in(CLK_125M),
									.limit(32'd1250),		// 125 MHz / 1250 = 100 kHz

									.carry(w_sampling_trigger));

Module_Counter_8_bit		oscillatorClockUnbraked	(	.clk_in(w_sampling_trigger),
								.limit(8'd5),				// 100/5 kHz = 20 kHz
								.carry(w_clock_unbraked));

/******************/
/*** DAC DRIVER ***/
/******************/
Driver_DAC driver_DAC_instance (
				.gclk(CLK_125M),
				.data_ch_1(wb_V1),
				.data_ch_2(wb_V2),
				.mode_ch_1({2'b00}),
				.mode_ch_2({2'b00}),
				.start_write(w_sampling_trigger),
				.dac_sda1(DAC_SDA1),
				.dac_sda2(DAC_SDA2),
				.dac_csel(DAC_CSEL),
				.dac_sclk(DAC_SCLK)); //,
				// .busy(w_busy));

/***************************************/
/*** ... AND FINALLY, THE OSCILLATOR ***/
/***************************************/
/*
Module_HarmonicOscillator	pendulumInPhase		(.clk_in(w_clock),
								.k(SW),
								.loadBoundaryCondition(pushButton),
								.boundaryCondition(`boundaryCondition),
								.wave(wb_V1));
*/
harmonic_oscillator(
	.clk(CLK_125M),
	.interval(w_clock_unbraked),
	.M(M),
	.A(A),
	.y(wb_V1)
);

assign wb_V2 = -1 * wb_V1;

endmodule

module Sawtooth_Triangular(
	input CLK_125M,
	input pushButton,
	input [3:0] SW,
	output DAC_SDA1,
	output DAC_SDA2,
	output DAC_CSEL,
	output DAC_SCLK
);

wire w_signal_freq;

wire [31:0] wb_V1;
wire [31:0] wb_V2;

wire [31:0] limit;

assign limit = 32'b0100000000000>>SW[3:1];

// 125 MHz / 12500 = 10 kHz write frequency
Module_Posedge_Counter_32_bit freq_generator(
	.clk_in(CLK_125M), 
	.limit(32'd12500),		
	.carry(w_signal_freq)
);


Module_SyncCounter_State_32_bit sawtooth(
    .clk_in(CLK_125M),
    .clk_count(w_signal_freq),
    .out(wb_V2),
    .reverse(SW[0]),
    .limit(limit)
);

Module_SyncCounter_Reverse_State_32_bit triangular(
    .clk_in(CLK_125M),
    .clk_count(w_signal_freq),
    .out(wb_V1),
    .limit(limit)
);

Driver_DAC driver_DAC_instance(
	.gclk(CLK_125M),
	//.data_ch_1(wb_V1[11:0] + ~((limit[11:0]>>1) - 1) + 1),
	//.data_ch_2(wb_V2[11:0] + ~((limit[11:0]>>1) - 1) + 1),
	.data_ch_1(wb_V1[11:0] + ~((limit[11:0] - 1)>>1) + 1),
	.data_ch_2(wb_V2[11:0] + ~((limit[11:0] - 1)>>1) + 1),
	.mode_ch_1({2'b00}),
	.mode_ch_2({2'b00}),
	.start_write(w_signal_freq),
	.dac_sda1(DAC_SDA1),
	.dac_sda2(DAC_SDA2),
	.dac_csel(DAC_CSEL),
	.dac_sclk(DAC_SCLK)
);

endmodule
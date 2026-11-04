module Module_LowPassFilter	(	qzt_clk,
					clk_in,
					k,
					Vin,

					Vout);

input		qzt_clk;
input		clk_in;
input	[3:0]	k;
input	[19:0]	Vin;

output	[19:0]	Vout;

reg	[19:0]	Vout;
reg		clk_in_old;


// Insert below the necessary reg's and lines

// ...


endmodule

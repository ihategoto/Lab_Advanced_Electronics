module	Module_Neg_Counter_8_bit	(	clk_in,
					limit,

					out,
					carry);

input		clk_in;
input	[7:0]	limit;

output	[7:0]	out;
output		carry;

reg	[7:0]	out;
reg		carry;


always @(posedge clk_in) begin
	if (out == limit) begin
		out <= 8'b11111111;
		carry <= 1;
	end else if (out == 8'b11111111) begin
		out <= 8'b11111110;
		carry <= 0;
	end else
		out <= out - 1;
end

endmodule

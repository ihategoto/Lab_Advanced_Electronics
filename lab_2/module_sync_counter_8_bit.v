module	Module_sync_counter_8_bit(master_clk, clk_in, stop, limit, out, carry);

input 		master_clk;
input		clk_in;
input	[7:0]	limit;
input 		stop;

output	[7:0]	out;
output		carry;

reg		clk_in_old;
reg	[7:0]	out;
reg		carry;

always @(posedge master_clk) 
begin
	if (!stop)
	begin
		if((!clk_in_old)&&(clk_in))
		begin
			if (out >= (limit - 8'b00000001)) 
			begin
				out <= 0;
				carry <= 1;
			end else if (out == 0) 
			begin
				out <= 1;
				carry <= 0;
			end else
			begin
				out <= out + 1;
			end
		end
		clk_in_old <= clk_in;
	end else
		out <= out;
	
end

endmodule

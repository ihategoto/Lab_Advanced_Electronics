module	Multiplexer_2_1_bit (clk, addr, input_1, input_2, out);

input clk;
input addr;
input input_1;
input input_2;

reg out;

output out;

always @(posedge clk) begin
	if (addr)  
	begin
		out <= input_1;
	end 
	else
		out <= input_2;
	end

endmodule

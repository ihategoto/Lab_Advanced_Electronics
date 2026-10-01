module	Multiplexer_16_8_bit (clk, addr, input_1, input_2, out);

input clk;
input addr;
input [7:0] input_1;
input [7:0] input_2;

reg [7:0] out;

output [7:0] out;

always @(posedge clk) begin
	if (addr)  
	begin
		out <= input_1;
	end 
	else
		out <= input_2;
	end

endmodule

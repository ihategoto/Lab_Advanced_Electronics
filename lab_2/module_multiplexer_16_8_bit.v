module	Module_Multiplexer_16_8_bit (clk, addr, input_1, input_2, out);
/*
Multiplexer of two channels of 8 bit each, one bit address is needed.
*/

// input clock
input clk;
// address bit
input addr;
// channels
input [7:0] input_1;
input [7:0] input_2;

// output channel
output reg [7:0] out;

always @(posedge clk) begin
	if (addr)  
		out <= input_1;
	else
		out <= input_2;
end

endmodule

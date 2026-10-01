module	Module_FrequencyDivider	(clk_in, half_period, clk_out);

// input declaration
input		clk_in; 
input	[29:0]	half_period; // 30 bit input

// output declaration
output		clk_out; 

// register declaration, same name of an ouput means that the register is the
// input
reg		clk_out;

reg	[29:0]	counter;

// each time there's a positive front of the clock do what is inside the
// begin-end
always @(posedge clk_in) begin
	if (counter >= (half_period - 1)) begin
		counter <= 0; // not an imperative assignment (we're telling the compiler how to build the circuit these are not imperative instructions) 
		clk_out <= ~clk_out;
	end else
		counter <= counter + 1;
end

endmodule

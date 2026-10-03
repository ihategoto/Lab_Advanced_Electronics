module	Module_FrequencyDivider	(clk_in, half_period, clk_out);
/*
Frequency divider, only even dividends are possible:
	target_freq = clk_freq / div;
	half_period = div / 2;
*/

// input clock
input	clk_in; 
input	[29:0]	half_period;

// output clock
output reg clk_out; 

// 30 bit bus used for counting the input clock positive edges
reg	[29:0]	counter;

always @(posedge clk_in) 
begin
	/*
	Example: frequency divider 4Hz -> 1Hz => half_period = 4/2 = 2

										1s
	<----------------------------------------------------------------------->

	+--------+		  +--------+        +--------+        +--------+	    +
	|		 |	      |  	   |        | 		 |        |		   |	    |
	|	     |        |		   |		|        |        |	       |        |		4Hz
	+        +--------+		   +--------+        +--------+		   +--------+
	^                 ^				    ^				  ^					^
	|				  |					|				  |					|
	counter -> 0	  counter -> 1		counter -> 0      counter -> 1		counter -> 0    
	clk_out -> 1	  clk_out -> 1		clk_out -> 0	  clk_out -> 0		clk_out -> 1

	+-----------------------------------+		  				  			+
	|		 	     		   			|						  			|    
	|	             		  			|						  			|	    1Hz
	+				 		   			+-----------------------------------+
	*/
	if (counter >= (half_period - 1)) begin
		counter <= 0;
		clk_out <= ~clk_out;
	end else
		counter <= counter + 1;
end

endmodule

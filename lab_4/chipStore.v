/*******************************/
/*** Module_FrequencyDivider ***/
/*******************************/
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

endmodule

/****************************/
/*** Module_Counter_8_bit ***/
/****************************/

module	Module_SyncCounter_8_bit(master_clk, clk_in, stop, reverse, limit, out, carry);
/*
Synchronous 8 bit reversable & stoppable counter with settable limit.
*/

// master clock
input 	master_clk;
// secondary clock giving the counter frequency
input	clk_in;
// upper limit of the counter
input [7:0]	limit;
// stop flag
input stop;
// reverse flag
input reverse;

// output counter
output reg [7:0] out;
// carry when the counter reach the limit
output reg carry;

// state variable of the secondary clock
reg	clk_in_old;

always @(posedge master_clk) 
begin
	if (!stop)
	begin
		if((!clk_in_old) && (clk_in))
		/*
		if the secondary clock was low in the previous master clock's 
		edge and it's high in the current one than count
		*/
		begin
			if (!reverse)
			begin
				if (out >= (limit - 8'b00000001)) 
				begin
					out <= 0;
					carry <= 1;
				end 
				else if (out == 0) 
				begin
					out <= 1;
					carry <= 0;
				end 
				else
					out <= out + 1;
			end
			else
			begin
				if (out == 0) 
				begin
					out <= limit - 8'b00000001;
					carry <= 1;
				end 
				else if (out == limit - 8'b00000001) 
				begin
					out <= out - 1;
					carry <= 0;
				end 
				else
					out <= out - 1;
			end
		end 
	end 
	else
		/*
		otherwise the output is unchanged
		*/
		out <= out;
	clk_in_old <= clk_in;
end

endmodule

/**************************************/
/*** Module_SynchroCounter_8_bit_SR ***/
/**************************************/

module	Module_SynchroCounter_8_bit_SR	(	qzt_clk,
						clk_in,
						reset,
						set,
						presetValue,
						limit,

						out,
						carry);

input		qzt_clk;
input		clk_in;
input		reset;
input		set;
input	[7:0]	presetValue;
input	[7:0]	limit;

output	[7:0]	out;
output		carry;

reg	[7:0]	out;
reg		carry;

reg		clk_in_old;


always @(posedge qzt_clk) begin
	if (reset) begin
		out <= 0;
		carry <= 0;
	end else if (set) begin
		out <= presetValue;
		carry <= 0;
	end else if (!clk_in_old & clk_in) begin
		if (out >= (limit - 8'b00000001)) begin
			out <= 0;
			carry <= 1;
		end else if (out == 0) begin
			out <= 1;
			carry <= 0;
		end else
			out <= out + 1;
	end

	clk_in_old <= clk_in;
end

endmodule

/*********************************************/
/*** Module_Multiplexer_2_input_8_bit_sync ***/
/*********************************************/

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

/*****************************/
/*** Module_MonostableHold ***/
/*****************************/

`define		defaultN 	28'b0000001001100010010110100000	//	2.5 x 10^6 ===> 20 ms
module Module_MonostableMultivibrator(clk, duration, button, flag);
/*
Toggle button that does not suffer from bounces.
*/

// clock
input clk;
// number of edges to mantain the flag high
input [29:0] duration;
// input button
input button;

// output flag
output reg flag;

// state of the button on the previous edge
reg old_button;
// counter of edges
reg [29:0] counter;

always @(posedge clk)
begin
    if (old_button == 0 && button == 1)
            flag <= 1;
    else if (counter == duration)
        begin
            flag <= 0;
            counter <= 0;
        end
    else if (flag) // maybe here is better to have an if instead of an else if
            counter <= counter + 1;

    old_button <= button;
end

endmodule

/***************************/
/*** Module_Latch_16_bit ***/
/***************************/

module	Module_Latch_16_bit	(	clk_in,
					holdFlag,
					twoByteInput,

					twoByteOuput);

input		clk_in;
input		holdFlag;
input	[15:0]	twoByteInput;

output	[15:0]	twoByteOuput;

reg	[15:0]	twoByteOuput;


always @(posedge clk_in) begin
	if (!holdFlag) twoByteOuput <= twoByteInput;
end

endmodule

/***********************************/
/*** Module_D_type_FF_SR_Synchro ***/
/***********************************/

module	Module_D_type_FF_SR_Synchro	(	qzt_clk,
						clk_in,
						D,
						R,
						S,

						Q);

input		qzt_clk;
input		clk_in;
input		D;
input		S;
input		R;

output		Q;

reg		Q;

reg		clk_in_old;


always @(posedge qzt_clk) begin
	if (R)
		Q <= 0;
	else if (S)
		Q <= 1;
	else if (!clk_in_old & clk_in)
		Q <= D;

	clk_in_old <= clk_in;
end

endmodule

/*****************************/
/*** Module_Counter_32_bit ***/
/*****************************/

// This module to generate ADC and DAC clocks.

module	Module_Counter_32_bit	(	clk_in,
					limit,

					out,
					carry);

input		clk_in;
input	[31:0]	limit;

output	[31:0]	out;
output		carry;

reg	[31:0]	out;
reg		carry;

always @(posedge clk_in) begin
	if (out >= (limit - 32'd1)) begin
		out <= 0;
		carry <= 1;
	end else if (out == 0) begin
		out <= 1;
		carry <= 0;
	end else
		out <= out + 1;
end

endmodule

/*******************************/
/*** Module_FrequencyDivider ***/
/*******************************/
module	Module_FrequencyDivider	(
	input clk_in, 
	input [31:0] half_period,
	output reg clk_out
);
/*
Frequency divider, only even dividends are possible:
	target_freq = clk_freq / div;
	half_period = div / 2;
*/

// 30 bit bus used for counting the input clock positive edges
reg	[31:0]	counter;
 
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
	if (counter >= (half_period - 1)) 
	begin
		counter <= 0;
		clk_out <= ~clk_out;
	end else
		counter <= counter + 1;
	end

endmodule

/************************************/
/*** Module_Posedge_Counter_8_bit ***/
/************************************/

module	Module_Posedge_Counter_8_bit(
	input clk_in,
	input [7:0] limit,
	output reg [7:0] out,
	output reg carry
);
/*
Clock 32 bit posedge counter.
*/
always @(posedge clk_in) 
begin
	if (out >= (limit - 8'd1)) 
	begin
		out <= 0;
		carry <= 1;
	end else if (out == 0) 
	begin
		out <= 1;
		carry <= 0;
	end 
	else
		out <= out + 1;
end

endmodule

/*************************************/
/*** Module_Posedge_Counter_32_bit ***/
/*************************************/

module	Module_Posedge_Counter_32_bit(
	input clk_in,
	input [31:0] limit,
	output reg [31:0] out,
	output reg carry
);
/*
Clock 32 bit posedge counter.
*/
always @(posedge clk_in) 
begin
	begin
		if (out >= (limit - 32'd1)) 
		begin
			out <= 0;
			carry <= 1;
		end else if (out == 0) 
		begin
			out <= 1;
			carry <= 0;
		end 
		else
			out <= out + 1;
	end
end

endmodule

/**************************************/
/*** Module_SyncCounter_State_8_bit ***/
/**************************************/

module	Module_SyncCounter_State_8_bit(
	input clk_in, 
	input clk_count,
	input stop, 
	input reset, 
	input reverse,
	input [7:0] limit,
	output reg [7:0] out,
	output reg carry
);
/*
Synchronous 8 bit stoppable & resettable & reversable counter with settable limit.
*/

// state variable of the secondary clock
reg	clk_count_old;
// state variable of reset button
reg reset_old;

always @(posedge clk_in) 
begin
	reset_old <= reset;
	if(!reset_old && reset)
		out <= 0;
	else if (!stop)
	begin
		if((!clk_count_old) && (clk_count))
		begin
			if(!reverse)
			begin
				if (out >= (limit - 8'd1)) 
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
					out <= limit - 8'd1;
					carry <= 1;
				end 
				else if (out == (limit - 8'b1)) 
				begin
					out <= out - 1;
					carry <= 0;
				end 
				else
					out <= out - 1;
			end
		end
	end 
	clk_count_old <= clk_count;
end

endmodule

/***************************************/
/*** Module_SyncCounter_State_32_bit ***/
/***************************************/

module	Module_SyncCounter_State_32_bit(
	input clk_in, 
	input clk_count,
	input stop, 
	input reset, 
	input reverse,
	input [31:0] limit,
	output reg [31:0] out,
	output reg carry
);
/*
Synchronous 32 bit stoppable & resettable & reversable counter with settable limit.
*/

// state variable of the secondary clock
reg	clk_count_old;
// state variable of reset button
reg reset_old;

always @(posedge clk_in) 
begin
	reset_old <= reset;
	if(!reset_old && reset)
		out <= 0;
	else if (!stop)
	begin
		if((!clk_count_old) && (clk_count))
		begin
			if(!reverse)
			begin
				if (out >= (limit - 32'd1)) 
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
					out <= (limit - 32'd1);
					carry <= 1;
				end 
				else if (out == (limit - 32'd1)) 
				begin
					out <= out - 1;
					carry <= 0;
				end 
				else
					out <= out - 1;
			end
		end
	end 
	clk_count_old <= clk_count;
end

endmodule

/***********************************************/
/*** Module_SyncCounter_Reverse_State_32_bit ***/
/***********************************************/

module	Module_SyncCounter_Reverse_State_32_bit(
	input clk_in, 
	input clk_count,
	input [31:0] limit,
	output reg [31:0] out,
	output reg carry
);
/*
Synchronous 32 bit counter with settable limit.
When it achieve the limit it reverse the counting direction.
*/

// state variable of the secondary clock
reg	clk_count_old;

// Reverse flag
reg reverse;

always @(posedge clk_in) 
begin

	if((!clk_count_old) && (clk_count))
		begin
		if(!reverse)
		begin
			if (out >= (limit - 32'd1)) 
			begin
				reverse <= 1;
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
				reverse <= 0;
				carry <= 1;
			end 
			else if (out >= (limit - 32'd1)) 
			begin
				out <= out - 1;
				carry <= 0;
			end 
			else
				out <= out - 1;
		end
	end
	clk_count_old <= clk_count;
end

endmodule

/***********************************/
/*** Module_Multiplexer_16_8_bit ***/
/***********************************/

module	Module_Multiplexer_16_8_bit(
	input clk_in,
	input addr,
	input [7:0] in_1,
	input [7:0] in_2,
	output reg [7:0] out
);
/*
Multiplexer of two channels of 8 bit each, one bit address is needed.
*/
always @(posedge clk_in) begin
	if (addr)  
		out <= in_1;
	else
		out <= in_2;
end

endmodule

/************************************/
/*** Module_Multiplexer_32_16_bit ***/
/************************************/

module	Module_Multiplexer_32_16_bit(
	input clk_in,
	input addr,
	input [15:0] in_1,
	input [15:0] in_2,
	output reg [15:0] out
);
/*
Multiplexer of two channels of 16 bit each, one bit address is needed.
*/
always @(posedge clk_in) begin
	if (addr)  
		out <= in_1;
	else
		out <= in_2;
end

endmodule

/**************************************/
/*** Module_MonostableMultivibrator ***/
/**************************************/

module Module_MonostableMultivibrator(
	input clk_in,
	input [31:0] duration,
	input in,
	output reg out_state
);
/*
Toggle button that does not suffer from bounces. 
It returns the button signal that is kept up for `duration` clock edges.
*/
// state of the button on the previous edge
reg old_in;
// counter of edges
reg [31:0] counter;

always @(posedge clk_in)
begin
    if (old_in == 0 && in == 1 && counter == 0)
            out_state <= 1;
    else if (counter == duration)
        begin
            out_state <= 0;
            counter <= 0;
        end
    else if (out_state) 
            counter <= counter + 1;

    old_in <= in;
end

endmodule

/*******************************************/
/*** Module_StateMonostableMultivibrator ***/
/*******************************************/

module Module_StateMonostableMultivibrator(
	input clk_in,
	input [31:0] duration,
	input in,
	output reg out_state
);
/*
Toggle button that does not suffer from bounces. 
It protects the button from bounces and exposes a single bit state variable that is
changed upon pressing the button. 
*/
// state of the button on the previous edge
reg old_in;
// counter of edges
reg [31:0] counter;

always @(posedge clk_in)
begin
    if (old_in == 0 && in == 1 && counter == 0)
	begin
            out_state <= ~out_state;
            counter <= 1;
	end
    else if (counter == duration)
            counter <= 0;
    else if (counter > 0) // maybe here is better to have an if instead of an else if
            counter <= counter + 1;
    old_in <= in;
end

endmodule

/**************************/
/*** Module_Latch_8_bit ***/
/**************************/

module	Module_Latch_8_bit(
	input clk_in,
	input hold,
	input [7:0] in,
	output reg [7:0] out
);
/*
8 bit latch: out follows in while hold is low, and keeps its last value while hold is high.
*/
always @(posedge clk_in)
begin
    if(!hold)
        out <= in;
end

endmodule

/***************************/
/*** Module_Latch_16_bit ***/
/***************************/

module	Module_Latch_16_bit(
	input clk_in,
	input hold,
	input [15:0] in,
	output reg [15:0] out
);
/*
16 bit latch: out follows in while hold is low, and keeps its last value while hold is high.
*/
always @(posedge clk_in)
begin
    if(!hold)
        out <= in;
end

endmodule

/****************************/
/*** Module_FSM_Stopwatch ***/
/****************************/

module Module_FSM_Stopwatch(
	input clk_in,
	input ss,
	input lr,
	output reg [2:0] state,
	output reg reset
);
/*
Implements the stopwatch FSM.
*/
reg	ss_old;
reg	lr_old;

always @(posedge clk_in) 
begin
	lr_old <= lr;
	ss_old <= ss;

	if (ss && !ss_old)
	begin
		case(state)
			3'b000:
			begin
				state <= 3'b010;
				reset <= 1'b0;
			end
			3'b001:
			begin
				state <= 3'b010;
				reset <= 1'b0;
			end
			3'b010:
			begin
				state <= 3'b001;
				reset <= 1'b0;
			end
			3'b011:
			begin
				state <= 3'b100;
				reset <= 1'b0;
			end
			3'b100:
			begin
				state <= 3'b011;
				reset <= 1'b0;
			end
		endcase
	end	else if (lr && !lr_old) begin
		case(state)
			3'b000:
			begin
				state <= 3'b000;
				reset <= 1'b0;
			end
			3'b001:
			begin
				state <= 3'b000;
				reset <= 1'b1;
			end
			3'b010:
			begin
				state <= 3'b011;
				reset <= 1'b0;
			end
			3'b011:
			begin
				state <= 3'b010;
				reset <= 1'b0;
			end
			3'b100:
			begin
				state <= 3'b001;
				reset <= 1'b0;
			end
		endcase
	end
end
endmodule

/*************************/
/*** Module_StateToLED ***/
/*************************/

module Module_StateToLED(
	input clk_in, 
	input [2:0] state,
	output reg [7:0] LED
);
/*
Translates the FSM states in LED configurations
*/
always@(posedge clk_in)
    begin
        case(state)
            3'b000:
				LED <= 8'b00000001;
			3'b001:
				LED <= 8'b00000010;
			3'b010:
				LED <= 8'b01000100;
			3'b011:
				LED <= 8'b11001000;
			3'b100:
				LED <= 8'b10010000;
        endcase
    end
endmodule

/*************************************/
/*** Module_Differentiator_12_bit ****/
/*************************************/

module Module_Differentiator_12_bit(
	input clk_in,
	input write_clk,
	input signed [11:0] in_sig,
	output reg signed [11:0] out_sig
);
/*
Simple differentiator:
	h[n] = δ[n] - δ[n-1]
*/
reg signed [11:0] old_in;
reg write_clk_old;

always @(posedge clk_in)
begin
	if(!write_clk_old && write_clk)
	begin
		out_sig <= in_sig - old_in;
		old_in <= in_sig;
	end
	write_clk_old <= write_clk;
end

endmodule

/*****************************************/
/*** Module_Differentiator_Adv_12_bit ****/
/*****************************************/

module Module_Differentiator_Adv_12_bit(
	input clk_in,
	input write_clk, 
	input signed [11:0] in_sig,
	output reg signed [11:0] out_sig
);
/*
Advanced differentiator:
	h[n] = 3/2 * δ[n] - 2 * δ[n-1] + 1/2 * δ[n-2]
*/
reg signed [11:0] old_in_1;
reg signed [11:0] old_in_2;
reg write_clk_old;

always @(posedge clk_in)
begin
	if(!write_clk_old && write_clk)
	begin
		out_sig <= (3*in_sig - 4*old_in_1 + old_in_2)>>>1;
		old_in_1 <= in_sig;
		old_in_2 <= old_in_1;
	end
	write_clk_old <= write_clk;
end

endmodule

/******************************/
/*** Module_Delayer_12_bit ****/
/******************************/

module Module_Delayer_12_bit(
	input clk_in, 
	input delay_clk,
	input signed [11:0] in_sig,
	output reg signed [11:0] out_sig
);
/*
Delays the sampled signal by one sampling period.
When it detects a posedge in ´delay_clk´ it updates the output signal.
It's assumed that in that same posedge in_sig gets updated elsewhere.
*/
reg signed old_delay_clk;

always @(posedge clk_in)
begin
	old_delay_clk <= delay_clk;
	if(!old_delay_clk && delay_clk)
	begin
		out_sig <= in_sig;
	end
end

endmodule

/****************************************/
/*** Module_HarmonicOscillator_12_bit ***/
/****************************************/

module Module_HarmonicOscillator_12_bit(
	input clk_in,
	input write_clk,
	input [2:0] k,
	input [11:0] amplitude, 
	input load,
	output reg signed [11:0] out_sig,
	output reg data_ready,
	output reg sign_change	
);
/*
Implements the sequence 
	y[n+1] = 2*y[n] - ε*y[n] - y[n-1]
	ε = 2^-k
with boundary condition:
	y[0] = amplitude - ε/2*amplitude
	y[1] = amplitude

write_clk is a secondary clock that times the sequence.
*/
reg signed [11:0] out_sig_old;
reg write_clk_old;
reg load_old;

always @(posedge clk_in)
begin
    if (!load_old && load)
    begin
        out_sig <= amplitude;
        out_sig_old <= amplitude - (amplitude>>>(k+1));
    end
    else if(!write_clk_old && write_clk)
    begin
        out_sig_old <= out_sig;
        out_sig <= (out_sig<<<1) - (out_sig>>>k) - out_sig_old;
		data_ready <= 1;
		sign_change <= out_sig_old[11] ^ out_sig[11]; 
	end
	else if(data_ready)
		data_ready <= 0;
    write_clk_old <= write_clk;
	load_old <= load;
end

endmodule

/****************************************/
/*** Module_HarmonicOscillator_24_bit ***/
/****************************************/

module Module_HarmonicOscillator_24_bit(
	input clk_in,
	input write_clk,
	input [3:0] k, 
	input [23:0] amplitude, // double the number of bits to avoid overflow
	input load,
	output reg signed [23:0] out_sig,
	output reg data_ready,
	output reg sign_change
);
/*
Implements the sequence 
	y[n+1] = 2*y[n] - ε*y[n] - y[n-1]
	ε = 2^-k
with boundary condition:
	y[0] = amplitude - ε/2*amplitude
	y[1] = amplitude

write_clk is a secondary clock that times the sequence.
*/
reg signed [23:0] out_sig_old;
reg write_clk_old;
reg load_old;

always @(posedge clk_in)
begin
    if (!load_old && load)
    begin
        out_sig <= amplitude;
        out_sig_old <= amplitude - (amplitude>>>(k+1));
    end
    else if(!write_clk_old && write_clk)
    begin
        out_sig_old <= out_sig;
        out_sig <= (out_sig<<<1) - (out_sig>>>k) - out_sig_old;
		data_ready <= 1;
		sign_change <= out_sig_old[23] ^ out_sig[23];
	end
	else if(data_ready)
		data_ready <= 0;
    write_clk_old <= write_clk;
	load_old <= load;
end

endmodule

/**********************************/
/*** Module_ShiftRegister_8_bit ***/
/**********************************/

module Module_ShiftRegister_8_bit(
	input clk_in,
	input write_clk,
	input closed_loop,
	input data_sig,
	output reg [7:0] data_out
);
/*
	Serial to parallel 8 bit shift register.
*/
initial data_out = 8'b00000000;
initial data = 0;

reg write_clk_old;
reg data_sig_old;
reg data;

always @(posedge clk_in)
begin
	write_clk_old <= write_clk;
	data_sig_old <= data_sig;
	if(!write_clk_old && write_clk)
	begin
		if(closed_loop)
		begin
			data_out <= (data_out<<1) + (~data_out[7] & data) + (data_out[7] & ~data);
		end
		else
			data_out <= (data_out<<1) + data;
		data <= 0;
	end
	else if(!data_sig_old && data_sig)
	begin
		data <= 1;
	end
end

endmodule

/**************************/
/*** Module_SR_FlipFlop ***/
/**************************/

module Module_SR_FlipFlop(
	input clk_in,
	input data_in,
	input reset,
	output reg data_out
);
initial data_out = 0;

always @(posedge clk_in)
begin
	if(reset)
		data_out <= 0;
	else
		data_out <= data_in | data_out;
end

endmodule

/**********************************/
/*** Module_PseudoRandom_12_bit ***/
/**********************************/


module Module_PseudoRandom_12_bit(
	input clk_in,
	input write_clk,
	output reg [11:0] data_out
);
/*
Pseudo-random number generator.
*/
initial data_out = 12'b011111111111;

reg write_clk_old;

always @(posedge clk_in)
begin
	write_clk_old <= write_clk;
	if(!write_clk_old && write_clk)
	begin
		data_out <= (data_out<<1) + (data_out[11] ^ data_out[9]);
	end
end

endmodule
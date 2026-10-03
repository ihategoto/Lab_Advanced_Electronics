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

module	Module_SyncCounter_State_8_bit(master_clk, clk_in, stop, reset, limit, out, carry);
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
// reset flag
input reset;

// output counter
output reg [7:0] out;
// carry when the counter reach the limit
output reg carry;

// state variable of the secondary clock
reg	clk_in_old;

reg reset_old;

always @(posedge master_clk) 
begin
	reset_old <= reset;
	if(!reset_old && reset)
		out <= 0;
	else if (!stop)
	begin
		if((!clk_in_old) && (clk_in))
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
	end 
	else
		/*
		otherwise the output is unchanged
		*/
		out <= out;
	clk_in_old <= clk_in;
end

endmodule

`define		period_1_kHz	30'd62500

module FSM_Core(clk, ss, lr, state, reset);

input		clk;
input		ss;
input		lr;

output reg	[2:0]	state;
output reg			reset;

always @(posedge clk) 
begin
	if (ss)
	begin
		case(state)
			3'b000:
				state <= 3'b010;
			3'b001:
				state <= 3'b010;
			3'b010:
				state <= 3'b001;
			3'b011:
				state <= 3'b100;
			3'b100:
				state <= 3'b011;
		endcase
	end
	else if (lr)
	begin
		case(state)
			3'b000:
				state <= 3'b000;
			3'b001:
				state <= 3'b000;
				reset <= 1;
			3'b010:
				state <= 3'b011;
			3'b011:
				state <= 3'b010;
			3'b100:
				state <= 3'001;
		endcase
	end
end



endmodule


module Module_StateToLED(clk,state,LED);

input            clk;
input    [2:0]   state;

output reg [7:0]    LED;

always@(posedge clk)
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

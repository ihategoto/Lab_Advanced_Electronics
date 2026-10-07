`define		period_1_kHz	30'd62500

module FSM_Core(CLK_125M, PUSH_BTN_SS, PUSH_BTN_LR, state, reset);

input		CLK_125M;
input		PUSH_BTN_SS;
input		PUSH_BTN_LR;

output reg	[2:0]	state;
output reg			reset;

always @(posedge CLK_125M) 
begin
	if (PUSH_BTN_SS)
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
	else if (PUSH_BTN_LR)
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
	else
		state <= state;
end



endmodule

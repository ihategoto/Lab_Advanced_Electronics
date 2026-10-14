`define		period_1_kHz	30'd62500

module FSM_Core(clk, ss, lr, state, reset);
input		clk;
input		ss;
input		lr;

output reg	[2:0]	state;
output reg			reset;

reg			ssOld;
reg			lrOld;

always @(posedge clk) 
begin
	lrOld <= lr;
	ssOld <= ss;

	if (ss && !ssOld)
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
	end	else if (lr && !lrOld) begin
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

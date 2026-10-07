`define		period_1_kHz	30'd62500

module finiteStateMachine	(	CLK_125M,
					PUSH_BTN_SS,
					PUSH_BTN_LR,

					B_LED,
					LED);

input		CLK_125M;
input		PUSH_BTN_SS;
input		PUSH_BTN_LR;

output	[3:0]	B_LED;
output	[7:0]	LED;

/****************************************/
/*** ... and hereafter what's left... ***/
/****************************************/

endmodule

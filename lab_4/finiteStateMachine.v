`define		period_1_kHz	30'd62500

module finiteStateMachine(CLK_125M, PUSH_BTN_SS, PUSH_BTN_LR, LED, B_LED);

input		CLK_125M;
input		PUSH_BTN_SS;
input		PUSH_BTN_LR;

output [7:0]	LED;
output [3:0]	B_LED;

wire 		w_btn_ss;
wire 		w_btn_lr;
wire		w_reset_in;
wire [2:0] 	wb_state;



Module_MonostableMultivibrator button_ss(
	.clk(CLK_125M),
	.duration(30'd6250000),
	.button(PUSH_BTN_SS),
	.flag(w_btn_ss)
);

Module_MonostableMultivibrator button_ss_led(
	.clk(CLK_125M),
	.duration(30'd125000000),
	.button(PUSH_BTN_SS),
	.flag(B_LED[0])
);

Module_MonostableMultivibrator button_lr(
	.clk(CLK_125M),
	.duration(30'd6250000),
	.button(PUSH_BTN_LR),
	.flag(w_btn_lr)
);

Module_MonostableMultivibrator button_lr_led(
	.clk(CLK_125M),
	.duration(30'd125000000),
	.button(PUSH_BTN_LR),
	.flag(B_LED[1])
);

Module_MonostableMultivibrator reset(
	.clk(CLK_125M),
	.duration(30'd125000000),
	.button(w_reset_in),
	.flag(B_LED[3])
);

FSM_Core fsm(
	.clk(CLK_125M),
	.ss(w_btn_ss),
	.lr(w_btn_lr),
	.state(wb_state),
	.reset(w_reset_in)
);

Module_StateToLED statetoled(
	.clk(CLK_125M),
	.state(wb_state),
	.LED(LED)
);

endmodule

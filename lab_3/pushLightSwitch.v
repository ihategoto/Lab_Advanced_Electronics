// number of edges of the master clock the LED must be on for
`define	duration_1_Hz 30'd125000000

module pushLightSwitch(CLK_125M, PUSHBUTTON, LED_1, LED);
// master clock
input CLK_125M;
// button 
input PUSHBUTTON;

// output LED
output LED;

// LED pin to be assigned to the button
output LED_1;

// assign LED_1 to the button to see it on the oscilloscope
assign LED_1 = PUSHBUTTON;

Module_MonostableMultivibrator monostable_multivibrator(
	.clk(CLK_125M),
	.duration(`duration_1_Hz),
	.button(PUSHBUTTON),
	.flag(LED)
);

endmodule

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
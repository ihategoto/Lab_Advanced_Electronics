module Module_monostable_multivibrator(clk, duration, button, flag);

input clk;
input [29:0] duration;
input button;

output reg flag;

reg old_button;
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
    else if (flag)
            counter <= counter + 1;

    old_button <= button;
end

endmodule
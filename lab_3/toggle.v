module Toggle_button (clk, button, flag);

input clk;
input button;

output reg flag;
reg old_button;

always @(posedge clk)
begin
    if (old_button == 1 && button == 0)
        begin
            flag <= ~flag;
        end
    old_button <= button;
end

endmodule


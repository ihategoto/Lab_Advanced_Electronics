module Module_Toggle_Button (clk, button, flag);
/*
Sequential toggle button, it suffers from bouncing effects 
*/

// input clock
input clk;
// button
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


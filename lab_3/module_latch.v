module Module_Latch_8_bit(clk, in, out, button);
input [7:0] in;
input button;

reg old_button;
reg flag;
output reg [7:0] out;

always @(posedge clk)
begin
    old_button <= button;
    if(!old_button && button)
        flag <= ~flag;
    else if(!flag)
        out <= in;

end
endmodule
module Module_Latch_8_bit(clk, in, out, flag);
input clk;
input [7:0] in;
input flag;

output reg [7:0] out;

always @(posedge clk)
begin
    if(!flag)
        out <= in;

end
endmodule
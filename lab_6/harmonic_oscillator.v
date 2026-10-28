module harmonic_oscillator(clk,M,A,y);
// ε=1/(2^M)
input clk;
input [15:0] M;
input [15:0] A;

output reg signed  [15:0] y;
reg signed         [15:0] y_old;

always @(posedge clk)
begin
    if (y==16'd0 && y_old==16'd0)
    begin
        y <= A;
        y_old <= A - A>>>M;
    end
    else
        y <= 2*y - y>>>(M-1) -y_old;

end

endmodule
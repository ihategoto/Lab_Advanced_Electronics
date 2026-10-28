module harmonic_oscillator(clk,interval, M,A,y);
// ε=1/(2^M)
input clk;
input interval;
input [15:0] M;
input [15:0] A;


output reg signed  [11:0] y;
reg signed         [11:0] y_old;

reg flag;
reg interval_old;

always @(posedge clk)
begin
    if (!flag)
    begin
        flag <= 1;
        y <= A;
        y_old <= A - A>>>M;
    end
    else if(!interval_old && interval)
        y <= y<<<1 - y>>>(M-1) - y_old;
    
    y_old <= y;
    interval_old <= interval;
end

endmodule
module baud_generator(input clk,input reset,output reg baud_tick);
reg [9:0] counter;

parameter clk_freq=100000000;
parameter baud_rate=9600;
parameter oversample=16;

localparam divisor=(clk_freq)/(baud_rate*oversample);

always @(posedge clk or posedge reset) begin
if(reset==1) begin
    counter<=0;
    baud_tick<=0;
    end
else begin
    if(counter!=divisor-1)  begin
        counter<=counter+1;
        baud_tick<=0;
        end
       else begin
        counter<=0;
        baud_tick<=1;
        
        end
end
end

endmodule

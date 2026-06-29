module uart_rx(input clk,input reset,input baud_tick,input rx,output reg [7:0]rx_data,output reg done,output reg parity_error,output reg stop_error);

parameter idle_state=3'b000;
parameter start_state=3'b001;
parameter data_state=3'b010;
parameter parity_state=3'b011;
parameter stop_state=3'b100;

reg [2:0]current_state;
reg [7:0]shift_register;
reg [2:0]bitcounter;
reg [3:0]oversample_counter;

always @(posedge clk or posedge reset) begin
if(reset) begin
shift_register<=0;
bitcounter<=0;
done<=0;
parity_error<=0;
stop_error<=0;
oversample_counter<=0;
current_state<=idle_state;
end

else begin
if(baud_tick) begin
case(current_state)

idle_state:begin
shift_register<=0;
bitcounter<=0;
done<=0;
parity_error<=0;
stop_error<=0;
oversample_counter<=0;

if(rx==0) begin
current_state<=start_state;
end
end

start_state:begin
oversample_counter<=oversample_counter+1;
if(oversample_counter==7)begin
if(rx==0) begin
oversample_counter<=0;
current_state<=data_state;
end
else begin
current_state<=idle_state;
end
end
end

data_state:begin
oversample_counter<=oversample_counter+1;
if(oversample_counter==15)begin
oversample_counter<=0;
shift_register<={rx,shift_register[7:1]};
bitcounter<=bitcounter+1;
if(bitcounter==7)begin
current_state<=parity_state;
end
end
end

parity_state:begin
oversample_counter<=oversample_counter+1;
if(oversample_counter==15)begin
oversample_counter<=0;
//$display("RX Data=%h Parity=%b", shift_register, rx);
if((shift_register[7]^shift_register[6]^shift_register[5]^shift_register[4]^shift_register[3]^shift_register[2]^shift_register[1]^shift_register[0]^rx)==0)begin
parity_error<=0;
current_state<=stop_state;
end
else begin
parity_error<=1;
current_state<=stop_state;
end
end
end

stop_state:begin
oversample_counter<=oversample_counter+1;
if(oversample_counter==15)begin
if(rx==1)begin
oversample_counter<=0;
rx_data<=shift_register;
done<=1;
stop_error<=0;
current_state<=idle_state;
end
else begin
oversample_counter<=0;
rx_data<=shift_register;
stop_error<=1;
done<=1;
current_state<=idle_state;
end
end
end

endcase
end
end
end
endmodule

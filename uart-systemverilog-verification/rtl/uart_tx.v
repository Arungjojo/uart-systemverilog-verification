module uart_tx(input clk,input reset,input [7:0]data,input baud_tick,input start,output reg tx,output reg busy);

parameter idle_state=3'b000;
parameter start_state=3'b001;
parameter data_state=3'b010;
parameter parity_state=3'b011;
parameter stop_state=3'b100;

reg [2:0] current_state;
reg [7:0] shift_register;
reg parity;
reg [2:0]bit_counter;
reg [3:0]oversample_counter;

always @(posedge clk or posedge reset) begin
if(reset)begin
current_state<=idle_state;
shift_register<=0;
parity<=0;
tx<=1;
busy<=0;
bit_counter<=0;
oversample_counter<=0;
end
else begin 

case(current_state)
idle_state:begin
tx<=1;
busy<=0;
bit_counter<=0;
oversample_counter<=0;
if(start)begin
shift_register<=data;
current_state<=start_state;
parity<=data[7]^data[6]^data[5]^data[4]^data[3]^data[2]^data[1]^data[0];
end
else
current_state<=idle_state;
end


start_state:begin
if (baud_tick) begin
tx<=0;
busy<=1;
oversample_counter<=oversample_counter+1;
if(oversample_counter==15)begin
bit_counter<=0;
current_state<=data_state;
oversample_counter<=0;
end
end
end

data_state:begin
if (baud_tick) begin
tx<=shift_register[0];
busy<=1;
oversample_counter<=oversample_counter+1;
if(oversample_counter==15)begin
shift_register<=shift_register>>1;
bit_counter<=bit_counter+1;
if(bit_counter==7) begin
current_state<=parity_state;
oversample_counter<=0;
end
else begin
current_state<=data_state;
oversample_counter<=0;
end
end
end
end

parity_state:begin
if (baud_tick) begin
tx<=parity;
busy<=1;
oversample_counter<=oversample_counter+1;
if(oversample_counter==15)begin
current_state<=stop_state;
oversample_counter<=0;
end
end
end

stop_state:begin
if (baud_tick) begin
tx<=1;
busy<=1;
oversample_counter<=oversample_counter+1;
if(oversample_counter==15)begin
current_state<=idle_state;
oversample_counter<=0;
end
end
end

default:
current_state<=idle_state;

endcase
end
end
endmodule
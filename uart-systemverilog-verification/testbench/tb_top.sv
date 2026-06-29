module tb_top;

uart_environment env;
uart_if vif();

uart_tx dut(.clk(vif.clk),.reset(vif.reset),.data(vif.data),.baud_tick(vif.baud_tick),.start(vif.start),.tx(vif.tx),.busy(vif.busy));
baud_generator dut1(.clk(vif.clk),.reset(vif.reset),.baud_tick(vif.baud_tick));
uart_rx dut2(.clk(vif.clk),.reset(vif.reset),.baud_tick(vif.baud_tick),.rx(vif.rx),.rx_data(vif.rx_data),.done(vif.done),.parity_error(vif.parity_error),.stop_error(vif.stop_error));

assign vif.rx=vif.tx;

initial
vif.clk=0;
always #5
vif.clk=~vif.clk;

initial begin
env=new();

env.vif=vif;
env.connect();

vif.reset=1;
#20;
vif.reset=0;

env.run();

#50000000;
$finish;

end 
endmodule 
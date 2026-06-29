class uart_driver;

uart_transaction tr;
uart_sequencer seqr;
virtual uart_if vif;

task run();
forever
begin

wait(vif.busy==0);
seqr.get_next_transaction(tr);
//$display("Driver got data=%h", tr.data);
vif.data=tr.data;
//$display("Driver asserted start at time=%0t", $time);
vif.start=1;
@(posedge vif.clk);
vif.start=0;
wait(vif.busy==1);
wait(vif.busy==0);

end
endtask

endclass
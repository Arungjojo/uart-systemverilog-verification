class uart_rx_monitor;

virtual uart_if vif;
uart_transaction tr;
uart_scoreboard sb;

task run();
forever begin

@(posedge vif.done);
tr=new();
tr.data=vif.rx_data;
tr.parity_error=vif.parity_error;
tr.stop_error=vif.stop_error;
sb.add_actual_transaction(tr);
//tr.display();

end
endtask
endclass

class uart_agent;

virtual uart_if vif;
uart_sequencer seqr;
uart_driver drv;
//uart_monitor mon;
uart_rx_monitor rx_mon;

function new();

seqr=new();
drv=new();
//mon=new();
rx_mon=new();

endfunction

function void connect();

drv.seqr=seqr;
drv.vif=vif;

//mon.vif=vif;
//mon.sb=sb;

rx_mon.vif=vif;

endfunction

task run();

fork
drv.run();
//mon.run();
rx_mon.run();
join_none

endtask

endclass
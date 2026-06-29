class uart_environment;

virtual uart_if vif;
uart_sequence seq;
uart_agent agent;
uart_scoreboard sb;

function new();

seq=new();
agent=new();
sb=new();

endfunction

function void connect();

seq.seqr=agent.seqr;
seq.sb=sb;

agent.vif=vif;
agent.connect();
agent.rx_mon.sb=sb;

endfunction

task run();

fork
seq.run();
agent.run();
sb.compare();
join_none

endtask
endclass




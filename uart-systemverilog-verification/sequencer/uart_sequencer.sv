class uart_sequencer;


uart_transaction q[$];

function void add_transaction(uart_transaction tr);
q.push_back(tr);
endfunction

task get_next_transaction(ref uart_transaction tr);
wait(q.size()>0);
tr=q.pop_front();
endtask

endclass
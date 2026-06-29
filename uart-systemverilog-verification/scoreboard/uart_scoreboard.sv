class uart_scoreboard;

uart_transaction expected_q[$];
uart_transaction actual_q[$];
   
function void add_expected_transaction(uart_transaction tr);
expected_q.push_back(tr);
endfunction

function void add_actual_transaction(uart_transaction tr);
actual_q.push_back(tr);
endfunction

task compare();

uart_transaction exp_tr;
uart_transaction act_tr;

forever begin
wait(expected_q.size()>0);
wait(actual_q.size()>0);

exp_tr=expected_q.pop_front();
act_tr=actual_q.pop_front();

$display("--------------------------------");
$display("Transmitted Data = %h", exp_tr.data);
$display("Received Data    = %h", act_tr.data);
$display("Parity Error     = %0b", act_tr.parity_error);
$display("Stop Error       = %0b", act_tr.stop_error);

if(exp_tr.data == act_tr.data)
 $display("RESULT           = PASS");
else
$display("RESULT           = FAIL");

$display("--------------------------------");

end
endtask
endclass
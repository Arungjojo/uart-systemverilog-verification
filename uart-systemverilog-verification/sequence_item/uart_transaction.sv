class uart_transaction;

rand logic [7:0] data;
bit parity_error;
bit stop_error;

function void display();
$display("data=%h parity_error=%0b stop_error=%0b",data, parity_error, stop_error);

endfunction

endclass


interface uart_if;

logic clk;
logic reset;
logic [7:0] data;
logic baud_tick;
logic start;
logic tx;
logic busy;

logic rx;
logic [7:0]rx_data;
logic done;
logic parity_error;
logic stop_error;

endinterface

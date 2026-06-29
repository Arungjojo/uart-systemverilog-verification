class uart_sequence;

uart_transaction tr;
uart_sequencer seqr;
uart_scoreboard sb;

task run();

repeat(10)
begin
tr=new();
tr.randomize();
//tr.display();

seqr.add_transaction(tr);
sb.add_expected_transaction(tr);
end
endtask

endclass
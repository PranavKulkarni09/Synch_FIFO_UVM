// Transaction class
class transaction extends uvm_sequence_item;
  `uvm_object_utils(transaction)
  
  rand bit wr, rd;
  rand bit [7:0] data_in;
  bit empty, full;
  bit [7:0] data_out;
  
  function new(string path = "transaction");
    super.new(path);
  endfunction
  
  function string convert2string();
    return $sformatf("wr=%0d rd=%0d data_in=%0d empty=%0d full=%0d data_out=%0d", 
                    wr, rd, data_in, empty, full, data_out);
  endfunction
endclass

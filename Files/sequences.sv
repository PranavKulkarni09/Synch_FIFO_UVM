// Write-then-read sequence
class write_then_read_test extends uvm_sequence#(transaction);
  `uvm_object_utils(write_then_read_test)
  
  transaction req;
  
  function new(string path = "write_then_read_test");
    super.new(path);
  endfunction
  
  virtual task body();
    req = transaction::type_id::create("req");
    assert(req.randomize());
    repeat(2) `uvm_do_with(req, {wr == 0; rd == 0;})
    // Write phase - fill FIFO
    `uvm_info("SEQ", "Starting write sequence", UVM_LOW)
      for (int i = 0; i < 16; i++) begin
      `uvm_do_with(req, {wr == 1; rd == 0; data_in == req.data_in;})
      repeat(2) `uvm_do_with(req, {wr == 0; rd == 0;}) // Delay between writes
    end

    // Add sufficient delay after writes
        repeat(9) `uvm_do_with(req, {wr == 0; rd == 0;})

    // Read phase - empty FIFO
          `uvm_info("SEQ", "Starting read sequence", UVM_LOW)
          //req.wr = 0; req.rd = 0;
          for (int i = 0; i < 17; i++) begin
      `uvm_do_with(req, {wr == 0; rd == 1;})
    end
  endtask
endclass

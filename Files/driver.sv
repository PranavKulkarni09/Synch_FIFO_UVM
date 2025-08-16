// Driver class
class driver extends uvm_driver#(transaction);
  `uvm_component_utils(driver)
  
  virtual synch_fifo_in fin;
  transaction tr;
  
  function new(string path = "driver", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual synch_fifo_in)::get(this, "", "fin", fin))
       `uvm_error("DRV", "Unable to access interface");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(tr);
      // Drive signals for the entire transaction duration
      fork
        begin
          fin.wr <= tr.wr;
          fin.rd <= tr.rd;
          fin.data_in <= tr.data_in;
          wait(tr.wr || tr.rd);  // Wait for operation to start
          @(posedge fin.clk);
          fin.wr <= 0;
          fin.rd <= 0;
        end
      join_none

      // Wait for operation to complete
      repeat(2) @(posedge fin.clk);
      seq_item_port.item_done();
    end
  endtask
endclass

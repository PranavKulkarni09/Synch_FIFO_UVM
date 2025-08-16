// Monitor class
class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  virtual synch_fifo_in fin;
  uvm_analysis_port#(transaction) send;
  transaction tr;
  
  function new(string path = "monitor", uvm_component parent = null);
    super.new(path, parent);
    send = new("send", this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual synch_fifo_in)::get(this, "", "fin", fin))
       `uvm_error("MON", "Unable to access interface");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    //@(negedge fin.clk);
    forever begin
      // Sample on negative edge to catch signals driven on positive edge
      //@(posedge fin.clk);
      @(negedge fin.clk);
      tr = transaction::type_id::create("tr");
      tr.wr = fin.wr;
      tr.rd = fin.rd;
      tr.data_in = fin.data_in;
      tr.empty = fin.empty;
      tr.full = fin.full;
      if(fin.rd && !fin.empty) begin
        @(negedge fin.clk);
      end
      tr.data_out = fin.data_out;
      send.write(tr);
    end
  endtask
endclass

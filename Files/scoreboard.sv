// Scoreboard class
class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
  uvm_analysis_imp#(transaction, scoreboard) recv;
  logic [7:0] queue[$];
  int write_count = 0;
  int read_count = 0;
  int match_count = 0;
  int mismatch_count = 0;
  
  function new(string path = "scoreboard", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv = new("recv", this);
  endfunction
  
  virtual function void write(transaction tr);
    // Handle write operations
    if(tr.wr && !tr.full) begin
      queue.push_back(tr.data_in);
      write_count++;
      `uvm_info("SCO", $sformatf("Write: Stored data=%0h, Queue size=%0d", 
                                tr.data_in, queue.size()), UVM_MEDIUM);
    end
    else if(tr.wr && tr.full) begin
      `uvm_error("SCO", $sformatf("Write attempt when FIFO is full - Trying to store: %0d", tr.data_in));
    end
    
    // Handle read operations
    if(tr.rd && !tr.empty) begin
      read_count++;
      if(queue.size() == 0) begin
        `uvm_error("SCO", "Read: Scoreboard queue is empty but FIFO is not!");
      end
      else begin
        logic [7:0] exp = queue.pop_front();
        if(exp == tr.data_out) begin
          match_count++;
          `uvm_info("SCO", $sformatf("Read MATCH: exp=%0h act=%0h | queue size = %0d", 
                                     exp, tr.data_out, queue.size()), UVM_MEDIUM);
        end
        else begin
          mismatch_count++;
          `uvm_error("SCO", $sformatf("Read MISMATCH: exp=%0h act=%0h", 
                                     exp, tr.data_out));
        end
      end
    end
    else if(tr.rd && tr.empty) begin
      `uvm_error("SCO", "Read attempt when FIFO is empty");
    end
  endfunction
  
  function void report_phase(uvm_phase phase);
    `uvm_info("SCO", $sformatf("Test Summary: Writes=%0d Reads=%0d Matches=%0d Mismatches=%0d", write_count, read_count, match_count, mismatch_count), UVM_LOW);
  endfunction
endclass

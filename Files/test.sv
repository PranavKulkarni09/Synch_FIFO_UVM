// Test class
class test extends uvm_test;
  `uvm_component_utils(test)
  
  environment env;
  
  function new(string path = "test", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = environment::type_id::create("env", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    write_then_read_test seq;
    phase.raise_objection(this);
    
    seq = write_then_read_test::type_id::create("seq");
    seq.start(env.a.seqr);
    
    #100; // Allow some time for completion
    phase.drop_objection(this);
  endtask
endclass

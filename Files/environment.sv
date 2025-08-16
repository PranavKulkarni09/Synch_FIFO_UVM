class environment extends uvm_env;
  `uvm_component_utils(environment)
  
  scoreboard sco;
  agent a;
  
  function new(string path = "environment", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sco = scoreboard::type_id::create("sco", this);
    a = agent::type_id::create("a", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    a.m.send.connect(sco.recv);
  endfunction
endclass

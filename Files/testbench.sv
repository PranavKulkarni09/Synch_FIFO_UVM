`include "uvm_macros.svh"
import uvm_pkg::*;

//Including all the UVM environment files
`include "interface.sv"
`include "transaction.sv"
`include "sequences.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "agent.sv"
`include "environment.sv"
`include "test.sv"

// Testbench module
module tb();
  synch_fifo_in fin();
  
  synch_fifo#(8, 16) DUT (.clk(fin.clk), .rst(fin.rst), .data_in(fin.data_in), .data_out(fin.data_out), .wr(fin.wr), .rd(fin.rd), .empty(fin.empty), .full(fin.full));
  
  initial begin
    uvm_config_db#(virtual synch_fifo_in)::set(null, "*", "fin", fin);
    run_test("test");
  end
  
  initial begin
    fin.clk = 0;
    fin.rst = 1;
    #20 fin.rst = 0;
  end
  
  always #5 fin.clk = ~fin.clk;
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end
endmodule

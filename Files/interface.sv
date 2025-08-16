interface synch_fifo_in();
  logic clk, rst, wr, rd, empty, full;
  logic [7:0] data_in, data_out;
  
  //Assertion checks
  property noWriteWhenFull;
    @(posedge clk) disable iff(rst)
    full |-> !wr;
  endproperty
  assert property(noWriteWhenFull)
    else $error("Write attempt when FIFO is full - Not Allowed");
    
   property noReadWhenEmpty;
    @(posedge clk) disable iff(rst)
    empty |-> !rd;
  endproperty
  assert property(noReadWhenEmpty)
    else $error("Read attempt when FIFO is empty - Not Allowed");
endinterface

module synch_fifo#(parameter DATA_WIDTH = 8, parameter FIFO_DEPTH = 16)(clk, rst, data_in, data_out, wr, rd, empty, full);
  //input - output port declaration
  input logic clk, rst, wr, rd;
  input logic [DATA_WIDTH-1:0] data_in;
  output logic empty, full;
  output logic [DATA_WIDTH-1:0] data_out;
  
  //local parameters
  localparam BITS_FOR_POINTER = $clog2(FIFO_DEPTH);
  localparam BITS_FOR_COUNTER = $clog2(FIFO_DEPTH);
  logic [DATA_WIDTH-1:0] mem[FIFO_DEPTH-1:0];
  logic [BITS_FOR_POINTER-1:0] wr_ptr, rd_ptr; //Subtracting 1 cuz $clog2(FIFO_DEPTH) in this case will return 4 and we want to point only to the last location/depth of the memory(FIFO) which is 15 cuz 0->15 = 16. Therefore 3:0 wr_ptr, rd_ptr
  logic [BITS_FOR_COUNTER:0] countr; //We want to know if we are counting more than the memory storage/depth capacity (in the case of depth 16) therefore the last location will be at count = 15 but we want to know when we have reaached the last location of depth (16 in this case) hence we need 5 bits to represent 16.
  
  //Covergroup
  covergroup  synch_fifo_cov @(posedge clk);
    //Cover write operation
    write_cp: coverpoint wr {
      bins write_on = {1};
      bins wr_off = {0};
    }
    
    //Cover read operation
    read_cp: coverpoint rd{
      bins read_on = {1};
      bins read_off = {0};
    }
    
    //Cover count Operation
    countr_cp: coverpoint countr{
      bins count_empty = {0};
      bins count_mid = {[1:15]};
      bins count_full = {16};
    }
    
    //Cover input data operation
    datain_cp: coverpoint data_in{
      bins low_corner = {[0:1]};
      bins datain_mid = {[2:243]};
      bins high_corner = {[244:245]};
    }
  endgroup
  
  synch_fifo_cov cover_inst = new();
  
  always@(posedge clk) begin
    if(rst) begin
      wr_ptr <= 0;
      rd_ptr <= 0;
      countr <= 0;
      for (int i = 0; i<FIFO_DEPTH; i = i+1) begin
        mem[i] <= 0;
      end
    end
    else if(wr && !full) begin
      mem[wr_ptr] <= data_in;
      wr_ptr <= wr_ptr + 1;
      countr <= countr + 1;
    end
    else if(rd && !empty) begin
      data_out <= mem[rd_ptr];
      rd_ptr <= rd_ptr + 1;
      countr <= countr - 1;
    end
  end
  
  //Empty and Full Logic
  assign empty = (countr == 0) ? 1'b1 : 1'b0;
  assign full = (countr == FIFO_DEPTH) ? 1'b1 : 1'b0;
endmodule

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

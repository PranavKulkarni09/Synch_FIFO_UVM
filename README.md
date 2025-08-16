# Verification of Synchronous FIFO
This project implements and verifies a synchronous FIFO coded in SystemVerilog and using UVM. It was built as part of my exploration into advanced verification workflows and timing-sensitive designs.

## Overview
### FIFO:
1. Parameterized FIFO size
2. Empty and Full Flag
3. Assertion Implementation
4. A memory array with read and write pointers
5. Counter to track and drive flag status

### Verification:
1. A layered and scalable UVM architecture for future addition of features and tests
2. Random stimulus generation for input data
3. Built-in checking in scoreboard class for matches, mismatches and error counts

### 📈 Results
1. Tested overflow and underflow conditions with assertions
2. Scoreboard outputs and confirms data for all transactions
3. 

### 📚 Why this project?
Built this project to explore and deepen my understanding of Design Verification further, this also helped me understand timing mismatches in FIFO and how important is timing control for proper capturing of data.

### 🚀 How to run
Make sure to have a simulator supporting SystemVerilog and UVM, EDA playground works just fine.
For EDA Playground use the following settings:
 - dnfkjdf

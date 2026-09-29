//==========================================================================================
// name: data_memory
// function: describes the behaviour of the memory containing data.
// It is divided in 2 parts:
// 1) Asyncronous reading (the data memory is always read)
// 2) Syncronous writing (the data memory is written on only if the write 
// enable is set)
//==========================================================================================

module data_memory import isa_pkg::*;
(
    input logic clk,
    input logic we,                     // write enable (dmem_we) 
    input logic [XLEN-1:0] address,     // dmem_address
    input logic [XLEN-1:0] wdata,       // dmem_wdata
    output logic [XLEN-1:0] rdata       // dmem_rdata
);  

logic [XLEN-1:0] memory_data [0: MEM_DEPTH-1];

    //syncronous writing (only on clk edge)
    always_ff @(posedge clk) begin
        if (we) begin
            // using 32 bit blocks (so the two LSBits aren't used)
        memory_data [address >> 2] <= wdata;

        end
    end

    // asyncronous reading
    always_comb  begin
        rdata = memory_data [address >> 2];
    end





endmodule



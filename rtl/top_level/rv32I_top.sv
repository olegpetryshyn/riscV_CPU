
//==========================================================================================
// name: top_module
// function: module connecting core, instruction 
// memory, and data memory.
//==========================================================================================

module rv32I_top import isa_pkg::*;(

    // the only external outputs needed are the clk and reset signals
    input logic clk,
    input logic rset_n

);


//-----------------------------------------------------------------
//  internal connections
//-----------------------------------------------------------------

// core connections
logic [XLEN-1:0] pc;
logic [XLEN-1:0] inst;

// memory connections
logic [XLEN-1:0] dmem_rdata;
logic [XLEN-1:0] dmem_wdata;
logic [XLEN-1:0] dmem_addr;
logic dmem_we;

//-----------------------------------------------------------------
// modules instances
//-----------------------------------------------------------------


// datapath+ control unit core instance 
rv32I_core instancecore (
    .clk (clk),
    .rset_n(rset_n),
    .pc (pc),
    .inst(inst),
    .dmem_addr(dmem_addr),
    .dmem_rdata(dmem_rdata),
    .dmem_wdata(dmem_wdata),
    .dmem_we(dmem_we)
);

// instruction memory instance
instruction_memory insranceinstmem(
    .instruction(inst),
    .address(pc)
);


// data memory instance
data_memory instancedatamem(
    .clk(clk),
    .we(dmem_we),
    .address(dmem_addr),
    .rdata(dmem_rdata),
    .wdata(dmem_wdata)
);



endmodule


//==========================================================================================
// name: rtv321_core
// function: connects all the other modules together, receiving the inputs necessary 
// from the control unit. It contains internal wires to connect each module.  
//==========================================================================================

module rv32I_core   import isa_pkg::*; 
(
    input  logic            clk,            //  external clk
    input  logic            rset_n,          //  reset
    output logic [XLEN-1:0] pc,             //  program counter
    input  logic [XLEN-1:0] inst,           //  full instruction

    input  logic [XLEN-1:0] dmem_rdata,  
    output logic [XLEN-1:0] dmem_addr,      //  write address in memory
    output logic [XLEN-1:0] dmem_wdata,     //  write data in memory
    output logic            dmem_we         //  write enable 

 );

//-----------------------------------------------------------------------------
// internal wires 
//------------------------------------------------------------------------------  
  
    // program counter
    logic [XLEN-1:0] pc_next;
    logic [XLEN-1:0] pc_4;
    logic [XLEN-1:0] pc_target;
    
    // immediate generator
    logic [XLEN-1:0]    imm_exit;

    // selectors 
    logic               alu_sel;            //second alu operand selector

    // control unit
    logic         mem_to_reg;       // Enables reading from memory 
    logic         reg_write;        // Enables writing on  registers       
    logic         branch;           // Signals a branch to the top level
    opcode_alu_e  op_alu;           // outputs the enum corresponding the ALU operation 

    // registers
    logic [XLEN-1:0] register_wdata;
    logic [XLEN-1:0] rs1_data;
    logic [XLEN-1:0] rs2_data;

    // ALU
    logic [XLEN-1:0]    alu_result;
    logic               zero_flag;
    logic [XLEN-1:0]    alu_src_b; // the second operand (immediate or from register)
    

//--------------------------------------------------------------------------------
// assignments
//--------------------------------------------------------------------------------

// adders to the program counter for each case (branch or next 32 bit instruction)
assign pc_4         =  pc + 32'd4;
assign pc_target    =  pc + imm_exit;

// multiplexer to select the correct PC (using and gate between branch and zero flag)
assign pc_next = (branch & zero_flag)? pc_target:pc_4;



// multiplexer to select the correct alu second operand
assign  alu_src_b = (alu_sel)? imm_exit: rs2_data; 


// multiplexer to enable writeback
assign  register_wdata = (mem_to_reg)? dmem_rdata:alu_result;

assign dmem_addr    =  alu_result ;
assign dmem_wdata   =  rs2_data;

//--------------------------------------------------------------------------------
// MODULE INSTANCES
//--------------------------------------------------------------------------------


    // 1) program_counter instance
    program_counter instancepc(
        .clk(clk),              
        .pc_next(pc_next),
        .rset_n(rset_n),
        .pc(pc)
    );

    // 2) control_unit instance (uses only )
    control_unit instancecu (
        .alu_sel(alu_sel),              // connected to the ALU multiplexer
        .branch(branch),                // connected to the AND gate with the zero falg
        .opcode(inst[6:0]),
        .funct3(inst[14:12]),
        .funct7(inst[31:25]),
        .mem_to_reg(mem_to_reg),    
        .mem_write(dmem_we),      // connected to the writeback multiplexer
        .op_alu(op_alu),
        .reg_write(reg_write)
    );

    //3) imm_gen instance
    imm_gen instanceimm (
        .inst(inst),
        .imm(imm_exit)
    );
    // 4) register files instance

    register_file instancerf (
        .clk(clk),
        .rset_n(rset_n),
        .rs1(inst[19:15]),
        .rs2(inst[24:20]),
        .rd(inst[11:7]),
        .reg_write(reg_write),
        .reg_data1(rs1_data),
        .reg_data2(rs2_data),
        .wdata(register_wdata)
    );

    // 5) alu instance
    ALU_32bit instanceALU (
        .a(rs1_data),
        .b(alu_src_b),
        .ALU_op(op_alu),
        .out(alu_result),
        .zero(zero_flag)
    );


endmodule


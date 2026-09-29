
// ===============================================================================================
// file name: imm_gen ==> immediate generator
// function: extracts the constant from each tipe of file based on the format described in the 
// RV321 base integer instructions
// ===============================================================================================


/*
 * ==============================================================================
 * RISC-V (RV32I) CORE INSTRUCTION FORMATS (from risk v green card)
 * ==============================================================================
 *
 *  Bit:   31           25 24     20 19     15 14    12 11          7 6          0
 *        +---------------+---------+---------+--------+-------------+------------+
 *   R    |    funct7     |   rs2   |   rs1   | funct3 |     rd      |   opcode   |
 *        +---------------+---------+---------+--------+-------------+------------+
 *   I    |          imm[11:0]      |   rs1   | funct3 |     rd      |   opcode   |
 *        +---------------+---------+---------+--------+-------------+------------+
 *   S    |   imm[11:5]   |   rs2   |   rs1   | funct3 |   imm[4:0]  |   opcode   |
 *        +---------------+---------+---------+--------+-------------+------------+
 *   SB   | imm[12|10:5]  |   rs2   |   rs1   | funct3 | imm[4:1|11] |   opcode   |
 *        +---------------+---------+---------+--------+-------------+------------+
 *   U    |                   imm[31:12]               |     rd      |   opcode   |
 *        +--------------------------------------------+-------------+------------+
 *   UJ   |              imm[20|10:1|11|19:12]         |     rd      |   opcode   |
 *        +--------------------------------------------+-------------+------------+
*/ 


// to reconstruct a sign extention to 32 bit i need to replicate the MSB a certain number of times,
// until i reach the 32 bit necessary for ALU operations


 
module imm_gen   import isa_pkg::*; 
    (
    input logic [31:0] inst,
    output logic [31:0] imm
    );


    import isa_pkg::*; 

    always_comb begin

        case (opcode_e'(inst [6:0]))  // opcode extraction from the first 7 bits (cast enum)
            
            // I type: the LSB is set to zero (in accordance to rhe 2nd point in the risk V RV321 reference data)
            
            OPCODE_OP_IMM,
            OPCODE_LOAD,
            OPCODE_JALR : imm = {{20{inst[31]}},inst[31:20]}; //20+12 =32 bits        

            // S type 
            OPCODE_STORE: imm = {{20{inst[31]}},inst[31:25],inst[11:7]}; //   20+7+5 = 32 bits
            // B type 
            OPCODE_BRANCH: imm = {{20{inst[31]}},inst[7],inst[30:25],inst [11:8],1'b0}; //20+1+6+4+1 = 32 bits
            // J type (jump in words, so LSB forced to 0)
            OPCODE_JAL: imm = {{12{inst[31]}},inst[19:12],inst[20],inst[30:21],1'b0};  //12+8+1+10+1 = 32 bits                    
            // U type (upper bits are carried, lower bits are set to 0)
            OPCODE_LUI: imm = {inst[31:12],12'b0};   // 20+12 = 32 bits    

            default: imm = '0;      // default case for other type of instructions returns 32 bit at 0
        endcase 

    end 
endmodule


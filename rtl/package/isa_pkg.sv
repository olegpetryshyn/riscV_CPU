//==========================================================================================
//  name: isa_pkg
//  function: identifies the various data types, operation and enum that will be used
//  -the instructions are based on risk V RV321 BASE INTEGER INSTRUCTIONS:
//      https://dejazzer.com/coen2710/lectures/RISC-V-Reference-Data-Green-Card.pdf
// in
//==========================================================================================

package isa_pkg;

    // local parameters
    localparam int XLEN = 32; //registers lenght
    localparam int REG_ADDR_WIDTH = 5; // lenght of the register pointer
    localparam int MEM_DEPTH = 100;

    // instruction type definitions

    typedef enum logic [6:0] {
        OPCODE_OP       = 7'b0110011, // R-Type (add, sub, and, or, slt)
        OPCODE_OP_IMM   = 7'b0010011, // I-Type aritmetic operations (addi, andi, slti)
        OPCODE_LOAD     = 7'b0000011, // I-Type load (lw)
        OPCODE_STORE    = 7'b0100011, // S-Type store (sw)
        OPCODE_BRANCH   = 7'b1100011, // B-Type branch (beq, bne, blt)
        OPCODE_JAL      = 7'b1101111, // J-Type unconditional jump
        OPCODE_JALR     = 7'b1100111, // I-Type indirect jump
        OPCODE_LUI      = 7'b0110111  // U-Type load upper immediate
    } opcode_e; 


    // ALU instruction definition

    typedef enum logic[3:0]{
        ALU_ADD = 4'b0000,      // a + b
        ALU_SUB = 4'b0001,      // a - b
        ALU_AND = 4'b0010,      // a & b
        ALU_OR  = 4'b0011,      // a | b
        ALU_XOR = 4'b0100,      // a ^ b
        ALU_SLT = 4'b0101,      // a < b
        ALU_LUI = 4'b0110       // b<<12
    }opcode_alu_e;

endpackage

 



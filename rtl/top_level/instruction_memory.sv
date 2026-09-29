//==========================================================================================
// name: data_memory
// function: describes the behaviour of the instructions contained in 
// their dedicated memory.
// using $readmem to read from the hex file (compiled from the )
//==========================================================================================

module instruction_memory import isa_pkg::*;
(
   
    input   logic [XLEN-1:0] address,        // connected with PC
    output logic [XLEN-1:0] instruction     // connected with inst  
);

logic [XLEN-1:0] memory_instruction [0: MEM_DEPTH-1];


// reading from hex file 
initial begin 
        $readmemh ("program.hex",memory_instruction);
end

// assigning the instruction only if the address 
// (not considered the 2 LSBits, since it is a word)
// is conteined in the memory. otherwise the output is NOP (0x13)
// wich means No OPeration

assign instruction =((address>>2)< MEM_DEPTH) ? memory_instruction[address>>2]: 32'h00000013;


endmodule

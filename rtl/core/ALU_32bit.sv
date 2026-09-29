//==========================================================================================
// name: ALU_32bit
// function: describes the ALU functions 
//==========================================================================================



// importing isa pakage


   // using XLEN to define the lenght of the imputs & output
module ALU_32bit import isa_pkg::*;  
   (
      input    logic    [XLEN-1:0]  a,
      input    logic    [XLEN-1:0]  b,
      input    opcode_alu_e  ALU_op, // I'm using the opcode ALU defined in the ISA
      output   logic    [XLEN-1:0]  out,
      output   logic                zero
   );



   // selecting the opreations
 always_comb begin
    case (ALU_op) 
        ALU_ADD: out = a+b;
        ALU_SUB: out = a-b;
        ALU_AND: out = a&b;
        ALU_OR:  out = a|b;
        ALU_XOR: out = a^b;
        ALU_SLT: out = ($signed(a)< $signed(b) ) ? 32'd1: 32'd0;
        ALU_LUI: out = b;
        default: out = 32'b0;
    endcase
 end
   
   // zero flag assignmet 
   assign zero = (out == 32'b0) ? 1'b1:1'b0;

endmodule



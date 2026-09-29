// ===============================================================================================
// file name: control_unit ==> control unit
// function: receives instruction from the memory and outputs the control data necessary to 
// execute it. In this implementation the control unit does not receive the zero flag (it will
// be done in the top level part)
// ===============================================================================================

 
 module control_unit import isa_pkg::*;
 (
   input   opcode_e      opcode,      //type-identifier initialised by ISA package 
   input   logic   [2:0] funct3,
   /* verilator lint_off UNUSEDSIGNAL */
   input   logic   [6:0] funct7,
   /* verilator lint_off UNUSEDSIGNAL */
   output  logic         alu_sel,     // Selects second alu operand (register or immediate)
   output  logic        mem_to_reg,        // Enables reading from memory 
   output  logic        reg_write,         // Enables writing on  registers
   output  logic        mem_write,         // Enables writing on  memory
   output  logic        branch,            // Signals a branch to the top level
    
    
   output  opcode_alu_e  op_alu       // outputs the enum corresponding the ALU operation 
 );


      // definition of local parameters (equivalent to isa_operation type)
      localparam OPC_R_TYPE = 7'b0110011;
      localparam OPC_I_TYPE = 7'b0010011;
      localparam OPC_LOAD   = 7'b0000011;
      localparam OPC_STORE  = 7'b0100011;
      localparam OPC_BRANCH = 7'b1100011;
      localparam OPC_LUI    = 7'b0110111;



      // i can't use always_ff becouse of the single cycle architectural constraints:
      // some control signals woul be set a cycle larer, wich is not acceptable in this 
      // tipe of implementation

   always_comb begin
      // before starting with the cases, it is good practice to reset all control values
      alu_sel     =  '0;  
      mem_to_reg  =  '0;
      reg_write   =  '0;
      mem_write   =  '0;
      branch      =  '0;
      op_alu      =  ALU_ADD; 

   case (opcode)
      OPC_R_TYPE:  // operation chosen
      begin
            alu_sel     =  '0;  
            reg_write   =  '1;
            case (funct3)   //using funct3 to distinguish same tipe operations
               3'b000: op_alu = (funct7[5])? ALU_SUB: ALU_ADD; // funct seven distinguishes between sub and sum
               3'b001: op_alu = ALU_SLT;
               3'b100: op_alu = ALU_XOR;
               3'b110: op_alu = ALU_OR;
               3'b111: op_alu = ALU_AND;
                default: op_alu = ALU_ADD; // in all other cases 
            endcase
         // not all cases are implemented, operation used are supported by ALU.32bit.sv
      end
      OPC_I_TYPE: 
     begin
            alu_sel     =  '1;   // second operand is an immediate
            reg_write   =  '1;
            case (funct3) 
            3'b000: op_alu = ALU_ADD; 
            3'b001: op_alu = ALU_SLT;
            3'b100: op_alu = ALU_XOR;
            3'b110: op_alu = ALU_OR;
            3'b111: op_alu = ALU_AND;
            default: op_alu = ALU_ADD;     

            endcase
      end
      OPC_LOAD: 
      begin
            alu_sel     =  '1;   // using immediate as an offset
            mem_to_reg  =  '1;
            reg_write   =  '1;
            op_alu = ALU_ADD;  // the only operation needed to load a parameter
      end
      OPC_STORE: 
      begin
            alu_sel     =  '1;  
            mem_write   =  '1;
            op_alu      =  ALU_ADD;

      end
      OPC_BRANCH: 
      begin
            alu_sel     =  '0;   //confronts rs1 and rs2 if equal
            branch      =  '1;   
            op_alu      =  ALU_SUB; // to confront if equal

      end
      OPC_LUI:
      begin
            alu_sel  ='1;
            reg_write   =  '1;
            op_alu   =ALU_LUI;
      end
      default: 
      begin
            alu_sel    = 1'b0;
            mem_to_reg = 1'b0;
            reg_write  = 1'b0;
            mem_write  = 1'b0;
            branch     = 1'b0;
            op_alu     = ALU_ADD;
      end


   endcase
   end

 endmodule


// ===============================================================================================
// file name: register_file ==> register file
// function: describes the reading & writing of the registers
// the risc v RV321 architecture dictates that there has to be always a reading 
// operation (in a clk) and, if enabled, a writing operation. 
// In case the rd,rs1,rs2 is 0, the corrisponding operation is aborted.
// ===============================================================================================

 

module register_file  import isa_pkg::*;  
(
    input   logic                               clk, 
    input   logic                               rset_n,     // negative reset          
    input   logic     [REG_ADDR_WIDTH-1:0]      rs1,        //first source address 
    input   logic     [REG_ADDR_WIDTH-1:0]      rs2,        //second source address
    input   logic     [REG_ADDR_WIDTH-1:0]      rd,         // destination address 
    input   logic     [XLEN-1:0]                wdata,      // rd pointed data 
    input   logic                               reg_write,  // write enable
    output  logic    [XLEN-1:0]                 reg_data1,   
    output  logic    [XLEN-1:0]                 reg_data2
      
);

// 32x32 bit register array
logic [XLEN-1:0] register [0:31]; 
// asyncronous reading (unless rsx ='0)
    assign reg_data1 = (rs1 == '0) ? '0:register[rs1];
    assign reg_data2 = (rs2 == '0) ? '0:register[rs2];



// syncronous writing

always_ff @(posedge clk or negedge rset_n) begin   //creates ff and enables automatic controls possible in SystemVerilog
        if (!rset_n)begin // if (rset_n == 0)
            // register reset
                for(int i=0;i<32;i++) begin // i'm using 32 instead of the power of 
                                            // REG_ADDR_WIDTH to save computational 
                                            // power
                    register [i]<='0;    
                end 

                // write only if red_write enabled and the register is not 5'b0
        end else if (reg_write && (rd != 5'b0)) begin 
                    register[rd] <= wdata; // not blocking assignment
        end
end

endmodule



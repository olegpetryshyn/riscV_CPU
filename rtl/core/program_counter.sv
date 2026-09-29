// ===============================================================================================
// file name: program_counter ==> program counter
// function: points to the next instruction in a program. normally increases 
// by 4 (= 1 word), unless a jump is required.
// ===============================================================================================
  

module program_counter  import isa_pkg::*;(
    input logic                 clk,
    input logic                 rset_n,
    input logic     [XLEN-1:0]  pc_next,
    output logic    [XLEN-1:0]  pc
);

    always_ff @ (posedge clk or negedge rset_n)begin
        if (!rset_n)begin
        pc <= '0;
        end else  begin 
        pc <= pc_next; // the next pc is decided by the Control Unit
        end

    end
endmodule





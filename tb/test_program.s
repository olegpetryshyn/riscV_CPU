#===========================================================================
# File Name = test_program.s
# Function  = an assembly (with riscv instructions) loaded in the memory
# to test the single cycle cpu
# the program includes: 
    #   initialisation of x1 register using ADDI 
    #   initialising x2 = 0x0A12CF67 (to test LUI instruction)
    #   Store x1 in 0x1008
    #   Load in x3 the value stored in 0x1009
    #   branch equal not taken (confonting x1 and x2)
    #   branch equal taken (confronting x1 with  x3)
    #   fibonacci loop from taken branch

#===========================================================================

        # 1. initialisation of register x1 and x2
        ADDI x6,x0,1            # reset fibonacci count
        ADDI x7,x0,1            # reset fibonacci count
        ADDI x8,x0,0            # reset fibonacci count
        ADDI x5,x0,0            # initialisation x5

        ADDI x1,x0,5            #  Reg[x1]  <== Reg[x0]+5
            #initialising x2 = 0xA12CF67
            #assign the 20 MSBits with LUI
        LUI  x2, 0xA12D       #  Reg[x2]  <== {0x0A12C, 12'b0}
        ADDI x2,x2, 0xF67     #  add the last 12 bit 
        

        # 2. store and load on x3
        LUI x9, 1            # shift 1 by 12 bits, obtain 0x1000        
        SW  x1, 8(x9)      # add 8 in hex to x9 register
        LW  x3, 8(x9)      # Reg[x3]<== Mem[0x1008]

        # 3. failed branch
        BEQ x2,x1, branch_failure 
        # if not taken the 
        ADDI x4,x0,1
        # 3. succesful branch
        BEQ x3,x1, fibonacci_loop
        #if branch not taken, x5 signals error
        ADDI x5,x0,1

fibonacci_loop:

        ADD x8,x6,x7            # Reg[x8] <== Reg[x6]+Reg[x7]
        ADD x6,x7,x0            # f(n-1) <== f(n)
        ADD x7,x8,x0            # f(n) <== f(n+1)
        ADDI x1,x1,-1
        BEQ x1,x0,exit_branch
        
        #continue loop 
        BEQ x0,x0,fibonacci_loop


exit_branch:
        ADDI x10,x0,37      #success flag

stop: BEQ x0,x0,stop        #infinite loop


branch_failure: 
    ADDI x4, x0, -1         # Errore: il primo branch non doveva saltare
    BEQ  x0, x0, stop       # Ferma il processore

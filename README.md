# Risc V CPU 

This project has the objective of creating a single cycle CPU using riscV-RV32I architecture.

The standard has the sequent rules (taken form the risk V green card)

1) Operation assumes unsigned integers (instead of 2's complement)
2) The least significant bit of the branch address in jalr is set to 0
3) (signed) Load instructions extend the sign bit of data to fill the 32-bit register
4) Kepпa Replicates the sign bit to fillI ini the th leftmost lefimost bits of the result during right shift
5) Multiply with one operand signed and one unsigned CORE INSTRUCTION FORMATS
6) The Single version does a single-precision operation using the rightmost 32 bits of a 64- 27 26 25 24 19 15 14 11 bit F register
7) Classify writes a 10-bit mask to show which properties are true (e.g.,-inf, -0,+0, +inf.lenorm. denorm, ...)
8) Atomic memory operation; nothing else can interpose itselfbetween the read and the
write of the memory location
The immediate field is sign-extended in RISC-V



# Microarchitecture
The following image shows the complete datapath of the single cycle cpu. the CPU uses a Harvard architecture (instead of a Von Neumann one). The choice is necessary for a single cycle implementation, since it is imperative to execute an instruction with the data in a single clok cycle (not possible if the data and instruction memory arent separate).


<p align="center">
  <img src="docs/Datapath Single cycle.svg" alt="RISC-V RV32I Single-Cycle Datapath" width="850"/>
</p>

# Inplemented Instruction
# File tree
the files of the repository are divided in:
  - RTL: contains the SystemVer
  - testbench (tb)
  - Simulation

## RTL
the Hardware Descriptive language used is **SystemVerilog**, chosen for it's ease of use and industry recognition. The code structure is described from the  `Top_level`, which inplements the `RTL_core`
and the *memory registers* . the kernel of the project Is represented by the core, which has instances of all the logic described in the datapath and control unit. The components of the core are the:
- `ALU` : The arithmetic logic unit, which implemnts the following operations:
  - `ALU_ADD`: sum
  - `ALU_SUB`: subtraction
  - `ALU_AND`: and bitwise
  - `ALU_OR`:  or bitwise
  - `ALU_XOR`: xor bitwise
  - `ALU_SLT`: comparison with sign ( `out = 0x11111111` if a<b, else  `out = 0x00000000`)
  - `ALU_LUI`: takes only the second operand. It will be used for the Load upper Immediate operation.
- `control unit`: Recieves the instruction from the `instruction_memory` and outputs the necessary control signals
- `immediate_generator`: takes the instruction and generates extracts the immediate. Depending on the instruction, the immediate bits change position. 
- `program_counter`: used as a pointer to next instruction, with branch implementation.
- `register_files`: contains registers used for temporary data manipulation.
- `rv32I_core`: has all the other components instaces and connects the logic part together.

the memory is divided in:
- `instruction_memory`
- `data_memory`
- 

### Instruction Supported
This project does not have all the instruction types expected by a full RV32I implementation. The chosen instruction types reported in the ISA package are the following:
- Immediate
-  


## Testbench
the cpu test is executed using cocotb (python) to verify the results obtained 
The file contained in the tesbench are 


# Simulation
## Simulation Program 

## Simulation results
### Baseline Single-Cycle Execution Trace

Simulation waveform generated via Verilator and Cocotb, demonstrating execution of the implemented instruction set:

![Baseline Single-Cycle Waveform](docs/GTKWAVE_traces.jpg)


* **Clock Frequency:** 50 MHz (20 ns cycle time).
* *Memory Transactions Highlighted:*
  * 200 ns – 220 ns (SW): Data memory write assertion (dmem_we = 1) targeting address `0x00001008` with payload `0x00000005`.
  * 220 ns – 240 ns (LW): Single-cycle memory load (mem_to_reg = 1) retrieving `0x00000005` onto dmem_rdata with register write-back assertion (reg_write = 1).


# License and Copyright
This project is licensed under the **Apache License 2.0** - see the [LICENSE](License) file for details.

```text
Copyright (c) 2026 Oleg Petryshyn

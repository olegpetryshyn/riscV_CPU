# Risc V CPU 

This project has the objective of creating a single cycle CPU using riscV-RV321 architecture.

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
The next image shows the complete datapath of the single cycle cpu. the CPU uses a Harvard architecture (instead of a Von Neumann one). The choice is necessary for a single cycle implementation, since it is imperative to execute an instruction with the data in a single clok cycle (not possible if the data and instruction memory arent separate).

<p align="center">
  <img src="docs/Datapath Single cycle.svg" alt="RISC-V RV32I Single-Cycle Datapath" width="850"/>
</p>


# File tree
the files of the repository are divided in


# Simulation
## Simulation tools
## Simulation results
## License and Copyright

This project is licensed under the **Apache License 2.0** - see the [LICENSE](LICENSE) file for details.

```text
Copyright (c) 2026 Oleg Petryshyn
All rights reserved.

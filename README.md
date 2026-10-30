# RISC-V CPU

This project implements a **single-cycle** CPU based on the RISC-V **RV32I** architecture.

> **Status:** baseline version complete. Not under active development.

## Key Features

- **ISA**: subset of RV32I (see [Supported instructions](#supported-instructions))
- **Microarchitecture**: single-cycle Harvard, with separate instruction and data memories
- **HDL**: SystemVerilog
- **Verification**: **cocotb** testbench on **Verilator**, waveforms viewable in **GTKWave**
- **Clock frequency** in the simulation: 50 MHz (20 ns period)

## Microarchitecture

The following image shows the complete datapath of the single-cycle CPU.

The CPU uses a Harvard architecture (instead of a Von Neumann one). This choice is necessary for a single-cycle implementation: the instruction and its data must be accessed within a single clock cycle, which is not possible if instruction and data memory are not separate.

<p align="center">
  <img src="docs/Datapath Single cycle.svg" alt="RISC-V RV32I Single-Cycle Datapath" width="850"/>
</p>

## Repository structure

The files of the repository are divided into:

- `rtl/`: SystemVerilog source files
- `tb/`: testbench
- `docs/`: datapath diagram and waveform screenshots

## RTL

The hardware description language used is **SystemVerilog**, chosen for its ease of use and industry recognition.

The code structure starts from the top level `rv32I_top`, which instantiates the core (`rv32I_core`) and the memories. The core is the heart of the project: it contains instances of all the logic described in the datapath and in the control unit. Its components are:

- `ALU`: the arithmetic logic unit, which supports the following operations:
  - `ALU_ADD`: addition
  - `ALU_SUB`: subtraction
  - `ALU_AND`: bitwise AND
  - `ALU_OR`: bitwise OR
  - `ALU_XOR`: bitwise XOR
  - `ALU_SLT`: signed comparison (set if less than)
  - `ALU_LUI`: passes through the second operand only; used by the Load Upper Immediate operation
- `control_unit`: receives the instruction from the `instruction_memory` and outputs the necessary control signals
- `immediate_generator`: extracts the immediate from the instruction; the position of the immediate bits depends on the instruction type
- `program_counter`: pointer to the next instruction, with branch support
- `register_file`: the registers used for temporary data manipulation
- `rv32I_core`: instantiates all the other components and connects the logic together

The memory is divided into:

- `instruction_memory`: contains the instructions from which the control unit generates the control signals
- `data_memory`: contains the operands used by the instructions

All the common definitions used across different instances are in the ISA package (`isa_pkg.sv`).

### Supported instructions

This project does not implement all the instruction types expected by a full RV32I implementation. The instruction types defined in the ISA package are:

- **R-type**
- **I-type** (immediate)
- **I-type** (load)
- **S-type** (store)
- **B-type** (branches)
- **J-type** (unconditional jumps)
- **I-type** (indirect jumps)
- **U-type**

These correspond to the supported instructions.

## Testbench

The CPU is tested using cocotb (Python). The script simulates a clock source and checks the results produced by the RTL logic, which executes a hex program derived from the assembly test program.

The files in the testbench folder (`tb/`) are:

- `makefile`: contains the information needed to run the simulation, including references to:
  - the program used for the simulation
  - the tool used for trace visualisation
  - all the RTL files to be tested
  - the cocotb Python script
  - the RTL top level
- `test_top.py`: the Python script that generates the clock and compares the CPU output with the expected results
- `test_program.s`: the test program, written in RISC-V assembly
- `program.hex`: the test program converted to hexadecimal
- `test_results`: the results of the test run

## Running the simulation

### Requirements

- Linux (tested on Ubuntu) with Python 3.12
- [Verilator](https://www.veripool.org/verilator/)
- [cocotb](https://www.cocotb.org/)
- [GTKWave](https://gtkwave.sourceforge.net/) (optional, to view waveforms)

### Quick start

```bash
git clone https://github.com/olegpetryshyn/riscV_CPU.git
cd riscV_CPU

python3 -m venv .venv
source .venv/bin/activate
pip install cocotb

cd tb
make
```

`make` compiles the RTL (`rtl/package/isa_pkg.sv` and `rtl/core/*.sv`) with Verilator, using `rv32I_top` as top module, and runs the cocotb testbench `test_top.py`.

At the end, cocotb prints a summary table: a passing run shows `PASS` for every test and `FAIL=0`.

### Viewing the waveform

Open the waveform file generated in `tb/` with GTKWave:

```bash
gtkwave <waveform file>
```

### Cleaning up

```bash
make clean
```

## Simulation results

### Baseline single-cycle execution trace

Simulation waveform generated with Verilator and cocotb, showing the execution of the test program:

![Baseline Single-Cycle Waveform](docs/GTKWAVE_traces.jpg)

- **Clock frequency:** 50 MHz (20 ns cycle time)
- **Memory transactions highlighted:**
  - 200 ns – 220 ns (`SW`): data memory write (`dmem_we = 1`) to address `0x00001008` with data `0x00000005`
  - 220 ns – 240 ns (`LW`): single-cycle memory load (`mem_to_reg = 1`) returning `0x00000005` on `dmem_rdata`, with register write-back (`reg_write = 1`)

## Possible future work

- Pass the `riscv-arch-test` suite for the supported instructions
- Add a memory handshake (`valid`/`ready`) with stall support
- Add a CI workflow that runs the tests on every commit
- FPGA implementation
- Synthesis results (area, frequency, power) with an open-source flow

## License and Copyright

This project is licensed under the **Apache License 2.0**. See the [LICENSE](LICENSE) file for details.
```
Copyright (c) 2026 Oleg Petryshyn
```

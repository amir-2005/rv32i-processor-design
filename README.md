# RISC-V RV32I Processor Design

A SystemVerilog RTL implementation of a 32-bit RISC-V processor targeting the **RV32I** Base Integer Instruction Set. This project highlights a clean, modular, and synthesis-ready approach to digital design and computer architecture.

## Features
- **ISA Support:** Implements the complete RV32I base integer instruction set.
- **Supported Base Formats:** R-type, I-type, S-type, B-type, U-type, and J-type.
- **Hardware Language:** Written purely in synthesis-ready **SystemVerilog**.
- **Modularity:** Easily readable separation between major architectural components.

---

## Repository Structure

```text
├── src/                  # SystemVerilog RTL Source Files
│   ├── top.sv            # Top-level module anchoring the processor datapath
│   ├── alu.sv            # Arithmetic Logic Unit
│   ├── control_unit.sv   # Core decode and signal control matrix
│   ├── reg_file.sv       # General-purpose register file (x0 - x31)
│   ├── imm_gen.sv        # Immediate sign-extension logic
│   ├── imem.sv           # Instruction Memory module
│   └── dmem.sv           # Data Memory module
├── tb/                   # Simulation Verification Testbenches
│   ├── tb_top.sv         # Full integration/system testbench
│   └── individual_tbs/   # Module-level tests (ALU, RegFile, etc.)
└── README.md

---

## How to Run and Simulate

**1. Simulating the Hardware**
Create a new project in ModelSim.
Add all files from the Component folder and your desired design directory to the project.
Compile all files.
Locate the testbench file (marked with the tb postfix) and run the simulation.

**2. Running Custom Programs**
To change the program that runs in the processor:
Write your assembly code in the program.asm file.
Ensure the file path is correctly addressed in MachineCodeGenerator.py.
Run the Python script to generate the machine code.
Copy the generated machine code output and paste it into the inst.mem file inside your ModelSim project directory.
Restart and run your simulation.

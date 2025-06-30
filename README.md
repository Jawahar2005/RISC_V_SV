## RISC-V Core Verification in SystemVerilog

This project implements verification testbenches for a RISC-V processor's core components using SystemVerilog. The verification environment includes:

- ALU, Register File, Instruction and Data Memory
- Control Unit and ALU Control logic
- Random, deterministic, and edge-case tests

Key Highlights:
- Interface-based design for modularity
- Clock generation abstraction
- Packet-driven stimuli for test consistency

Testbench files include:
- `alu_random_test.sv`, `control_unit_test.sv`, `data_memory_test.sv`, etc.

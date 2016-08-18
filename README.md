## Reduced Instruction Set Computer Machine
This is a RISC machine written in verilog utilizing ModelSim for debugging.

## Block Diagram Visuals
This is generated from Yosys Software: https://github.com/cliffordwolf/yosys

https://github.com/anguslin/RISC/files/423904/RISC.Block.Diagram.pdf

## Executable Instructions
The instruction decoder will decode the 15 bit instructions and determine which of the 8 instruction below it is. 

Shift = 2 bits | imm8 = 8 bits | imm5 = 5 bits | Rn, Rm, and Rd = 3 bits.

| Instructions           |opcode| op | 11 bits           |
| -----------------------|------|----|-------------------|
| MOV Rn, #imm8          | 110  | 10 | {Rn imm8}         |
| MOV Rd, RM(Shift)      | 110  | 00 | {000 Rd Shift Rm} |
| ADD Rd, Rn, Rm(Shift)  | 101  | 00 | {Rn Rd Shift Rm}  |
| CMP Rn, RM(Shift)      | 101  | 01 | {Rn 000 Shift Rm} |
| AND Rd, Rn, Rm(Shift)  | 101  | 10 | {Rn Rd Shift Rm}  |
| MVN Rd, Rm(Shifted)    | 101  | 11 | {000 Rd Shift Rm} |
| LDR Rd, [RN(#imm5)]    | 011  | 00 | {Rn Rd imm5}      |
| STR Rd, [RN(#imm5)]    | 100  | 00 | {Rn Rd imm5}      |


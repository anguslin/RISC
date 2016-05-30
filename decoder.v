module decoder(instruction);
input[15:0] instruction
output [2:0] opcode, Rn, Rd, Rm;
output [1:0] ALUop, op, shift
output [15:0] sximm5, sximm8;

assign opcode = instruction[15:13];
assign op = instruction[12:11];
assign ALUop = instruction[12:11];
assign sximm5 = {10'b

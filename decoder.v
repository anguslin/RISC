//decoder module
module decoder(instruction);
        //inputs and outputs
        input[15:0] instruction
        output [2:0] opcode, Rn, Rd, Rm;
        output [1:0] ALUop, op, shift
        output [15:0] sximm5, sximm8;
        
        //assignments based off of instruction
        assign opcode = instruction[15:13];
        assign op = instruction[12:11];
        assign ALUop = instruction[12:11];
        assign sximm5 = {10{instruction[4]},instruction[4:0]};
        assign sximm8 = {7{instruction[7]},instruction[7:0]};
        assign shift = instruction[4:3];
        assign Rn = instruction[10:8];
        assign Rd = instruction[7:5];
        assign Rm = instruction[2:0];
endmodule

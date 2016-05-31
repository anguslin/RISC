module decoder(instruction, nsel, opcode, readnum, writenum, ALUop, op, shift, sximm5, sximm8);
        input [2:0] nsel;
        output [2:0] opcode, readnum, writenum;
        output [1:0] ALUop, op, shift;

module datapath(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, writenum, write, mdata, sximm5, sximm8, status, datapath_out);
	input clk, loada, loadb, write, vsel, asel, bsel, loadc, loads;
	input [1:0] shift, ALUop;
	
module counter(clk, reset, loadpc, msel, C,);
        input clk, reset, loadpc, msel;
      
assign {nsel, loada, loadb, write, vsel, asel, bsel, loadc, loads, shift, ALUop, reset, loadpc, msel, mwrite readAddress, writeAddress}

       
RAM #(16,8,"data.txt") RAMInstantiate(
                (~KEY[0])		inp
                (readAddress), 		inp
                (writeAddress)		inp
                (mwrite), 		inp
                
module instructionReg(clk, mdata, loadir, instruction);
        
        input clk, loadir;
        output [15:0] instruction;
        
        

//OUTPUTS ARE THINGS I HAVE TO WORK WITH
//INPUTS ARE THINGS I NEED TO PROVIDE

//GENERAL FORMAT
//first receive an instruction
//assign state things and next state things depending on which operaiton
//under each state, u shuld have another set of case statements describing what to do in each state
//after all the things are done in each state
//You should load the instruction register by enable loadir = 1 or something along the lines
//do this for all the operations

//START HERE

module cpu();

wire [3:0] currentState, nextState; 
wire [2:0] opCode;
wire [1:0] operation;

//Operation Code
`define MOV 3'b110
`define ALU 3'b101
`define STR 3'b100
`define LDR 3'b011
`define opCodeNone 3'bxxx;

//Operations
`define ADD 2'b00
`define CMP 2'b01
`define AND 2'b10
`define MVN 2'b11
`define operationNone 2'bxx


//instr 2 Reads Rm (nsel = 10) into datapath reg B, sets asel = 1 (to get all 0s), in the ALU it adds together to put in register C -> then written to Rd
`define REGTOREG 2'b00

//REGISTER choosing
`define RN 2'b00
`define RD 2'b01
`define RM 2'b10

//VSEL to choose with data to let in for the writing part
`define MDATA 2'b00
`define SXIMM8 2'b01
`define ZEROANDPC 2'b10
`define C 1'b1

//TRUE OR FALSE
`define ON 1'b1
`define OFF 1'b0

always @(*)
	case(currentstate, opcode, op)
	//Loading Instruction
	{`loadInstr, `opCodeNone, `operationNone}: {loadpc, reset, msel, write, loadir} = {`ON, `OFF, `OFF, `OFF, ON}
	//Move value of sximm8 into Rn register
	{`writeInstrToRn, `MOV, `AND}: {nsel, vsel, write} ={`RN,`SXIMM8VSEL,`ON};
	//Write shifted value of Rm register into Rd register
	{`writeShiftedRmToRd, `MOV, `ADD}: {nsel,bsel ={`RM, `ON,
//States
`define writeInstrToRn 4'b0000
`define loadInstr 4'b0001	
	
//instr 2 Reads Rm (nsel = 10) into datapath reg B, sets asel = 1 (to get all 0s), in the ALU it adds together to put in register C -> then written to Rd



 output [2:0] opcode, readnum, writenum;
        output [1:0] ALUop, op, shift;
        output [15:0] sximm5, sximm8;

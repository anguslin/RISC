module decoder(instruction, nsel, opcode, readnum, writenum, ALUop, op, shift, sximm5, sximm8);
        input [1:0] nsel;
        output [2:0] opcode, readnum, writenum;
        output [1:0] ALUop, op, shift;

module datapath(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, writenum, write, mdata, sximm5, sximm8, status, datapath_out);
	input clk, loada, loadb, write, vsel, asel, bsel, loadc, loads;
	
	
module counter(clk, reset, loadpc, msel, C,);
        input clk, reset, loadpc, msel;
      
       
RAM #(16,8,"data.txt") RAMInstantiate(
                (~KEY[0])		inp
                (address), 		inp
                (mwrite), 		inp
                
module instructionReg(clk, mdata, loadir, instruction);
        
        input clk, loadir;
        
        

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

wire [3:0] currentState, nextState, nextStateToBeUpdated; 
wire [2:0] opcode;
wire [1:0] operation;
wire [13:0] inputData;

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

//REGISTER choosing
`define RN 2'b00
`define RD 2'b01
`define RM 2'b10

//VSEL to choose with data to let in for the writing part
`define MDATA 2'b00
`define SXIMM8 2'b01
`define ZEROANDPC 2'b10
`define C 2'b11 

//TRUE OR FALSE
`define ON 1'b1
`define OFF 1'b0

//State Updates
DFlipFlop #(4) StateUpdate(clk, nextStateToBeUpdated, nextState);

//initial read -> Set reset to 0 to start program counter
always @(*) begin
	case(inputData)
		14'bxxxxxxxxxxxxxx: reset= 1;
		default: reset= 0;
	endcase
end

//All outputs needed for module instantiations
assign inputData[13:12] = nsel;
assign inputData[11:10] = vsel;
assign inputData[9] = loada;
assign inputData[8] = loadb;
assign inputData[7] = write;
assign inputData[6] = asel;
assign inputData[5] = bsel;
assign inputData[4] = loadc;
assign inputData[3] = loadpc;
assign inputData[2] = msel;
assign inputData[1] = mwrite;
assign inputData[0] = loadir;

//Specifications for what to do in each state 
//Each state is separated by a rising clock update
always @(*)
	case(currentState, opcode, op)
	//INSTRUCTION //Loading Instruction and Counter
	//Load counter value
	//loadPC = 1 mwrite = 0 loadir = 0, else = before -> Clk
	{`loadPC, `opCodeNone, `operationNone}:	inputData = {inputData[13:4], 1'b1, inputData[2], 2'b00};
	//load value into RAM
	//loadPC = 0 mwrite = 0 msel = 0 loadir = 0 , else = before -> Clk
	{`loadRAM, `opCodeNone, `operationNone}: inputData = {inputData[13:4], 4'b0001};
	//load instruction
	//loadPC = 0 mwrite = 0 loadir = 1, else = before -> Clk
	{`loadIR, `opCodeNone, `operaitonNone}: inputData = {inputData[13:4], 1'b0, inputData[2], 2'b01}
	
	
	//INSTRUCTION 1 //Write value of sximm8 into Rn register
	//nsel = Rn Vsel = SXIMM8 write = 1 loadir = 0  -> Clk
	{`writeInstrToRn, `MOV, `AND}: inputData = {`RN, `SXIMM8, inputData[9:8], 1'b1, inputData[6:1], 1'b0};
	
	//INSTRUCTION 2 //Write shifted value of Rm register into Rd register 
	//read value from RM register and put in B, loadb = 1 and loada = 0 and write = 0->Clock
	//nsel = RM, loada = 0 loadb = 1 write = 0
	{`readRmToB, `MOV, `ADD}:			inputData = {`RM, inputData[11:10], 3'b010, inputData[6:1], 1'b0}
	
	//read value from RM register and put in B (loadb = 1) ->Clock
	//set bsel = 0 and asel = 1 (to load 16 bit 0s) and loadc = 1 ->Clock
	//set vsel = `C and write = 1 nsel = `Rd ->Clock
	//load instruction
	
	
//States
`define writeInstrToRn 4'b0000
`define loadPC 4'b0001
`define loadRAM 4'b0010
`define loadIR 4'b0011
`define writeShiftedRmToRd 4'b0100

	
//instr 2 Reads Rm (nsel = 10) into datapath reg B, sets asel = 1 (to get all 0s), in the ALU it adds together to put in register C -> then written to Rd



 output [2:0] opcode, readnum, writenum;
        output [1:0] ALUop, op, shift;
        output [15:0] sximm5, sximm8;

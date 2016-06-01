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

wire [4:0] currentState, nextState, nextStateToBeUpdated; 
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
	//loadPC = 1, else = 0 -> Clk //put all load values back into 0 when finished executing a command
	{`loadPC, `opCodeNone, `operationNone}:	inputData = {14'b00000000001000};
	//load value into RAM
	//loadPC = 0, else = before -> Clk
	{`loadRAM, `opCodeNone, `operationNone}: inputData = {inputData[13:4], 1'b0, inputData[2:0]};
	//load instruction
	//loadir = 1, else = before -> Clk
	{`loadIR, `opCodeNone, `operaitonNone}: inputData = {inputData[13:1], 1'b1};
	//--------------
	
	//only loadir = 1, everything else is 0 
	//INSTRUCTION 1 //Write value of sximm8 into Rn register
	//nsel = Rn Vsel = SXIMM8 write = 1 loadir = 0  -> Clk
	{`writeInstrToRn, `MOV, `AND}: inputData = {`RN, `SXIMM8, inputData[9:8], 1'b1, inputData[6:1], 1'b0};
	
	//load instruction
	//---------------
	
	//only loadir = 1, everything else is 0 
	//INSTRUCTION 2 //Write shifted value of Rm register into Rd register 
	
	//read value from RM register 
	//nsel = RM loadir = 0 (write already 0), else = before -> Clk
	{`readRm, `MOV, `ADD}: inputData = {`RM, inputData[11:1], 1'b0,};
	
	//put specified reading value in B
	//loadb = 1, else = before -> Clk 
	{`putInB, `MOV, `ADD}: inputData = {inputData[13:9], 1'b1, inputData[6:0]};
	
	//Add A and Shifted B values and put into register C -> Clk
	//bsel = 0 asel = 1 loadc = 1, else = before -> Clk
	{`aluMovOpAndPutInC, `MOV, `ADD}: inputData = {inputData[13:7], 3'b101, inputData[3:0]};
	
	//Put value of C into Rd register
	//nsel = `RD vsel = `C write = 1, else = before -> Clk
	{`writeCInRd, `MOV, `ADD}: inputData = {`RD, `C, inputData[9:8], 1'b1, inputData[6:0]};
	
	//load instruction
	//---------------
	
	//INSTRUCTION 3 Add values of Rn and and shifted Rm and put it in Rd
	
	//read value from RM register 
	//nsel = RM loadir = 0 (write already 0), else = before -> Clk
	{`readRm, `ALU, `ADD}: inputData = {`RM, inputData[11:1], 1'b0,};
	
	//put specified reading value in B
	//loadb = 1, else = before -> Clk 
	{`putInB, `ALU, `ADD}: inputData = {inputData[13:9], 1'b1, inputData[6:0]};
	
	//read value from RN register
	//nsel = `Rn (write already 0), else = begore -> Clk
	{`readRn, `ALU, `ADD}: inputData = {`RN, inputData[11:0]};
	
	//put specified reading value in A
	//loadb = 0, loada = 1, else = before -> Clk
	{`putInA, `ALU, `ADD}: inputData = {inputData[13:10], 2'b10, inputData[7:0]};
	
	//do addition computations and load in register C
	//asel = 0 bsel = 0 loadc = 1, else - before -> Clk
	{`aluAddOpAndPutInC, `ALU, `ADD}: inputData = {inputData[13:7], 3'b001, inputData[3:0]};
	
	//Put Value into Rd
	//nsel = `RD vsel = `C write = 1, else = before -> Clk
	{`writeCInRd, `ALU, `ADD}: inputData = {`RD, `C, inputData[9:8], 1'b1, inputData[6:0]};
	
	//load instruction
	//------------
	
	//INSTRUCTION 4 

	
//States
//loading intructions
`define writeInstrToRn 5'b00000
`define loadPC 5'b00001
`define loadRAM 5'b00010
`define loadIR 5'b00011
//Instruction 1 
`define writeInstrToRn 5'b00100
//Instruction 2
`define readRm 5'b00101
`define putInB 5'b00110
`define aluMovOpAndPutInC 5'b00111
`define writeCInRd 5'b01000
`define readRn 5'b01001
`define `putInA 5'b01010
`define aluAddOpAndPutInC 5'b01011







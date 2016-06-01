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
wire [14:0] inputData;

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
		15'bxxxxxxxxxxxxxxx: reset= 1;
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


assign inputData[14:13] = nsel;
assign inputData[12:11] = vsel;
assign inputData[10] = loada;
assign inputData[9] = loadb;
assign inputData[8] = write;
assign inputData[7] = asel;
assign inputData[6] = bsel;
assign inputData[5] = loads;
assign inputData[4] = loadc;
assign inputData[3] = loadpc;
assign inputData[2] = msel;
assign inputData[1] = mwrite;
assign inputData[0] = loadir;


//Specifications for what to do in each state 
//Each state is separated by a rising clock update
always @(*)
	case(currentState, opcode, op)
	
	//only loadir = 1, everything else is 0 
	//INSTRUCTION //Loading Instruction and Counter
	
	//Load counter value
	//loadPC = 1, else = 0 -> Clk //put all load values back into 0 when finished executing a command
	{`loadPC, `opCodeNone, `operationNone}:	inputData = {15'b000000000001000};
	
	//load value into RAM
	//loadPC = 0, else = before -> Clk
	{`loadRAM, `opCodeNone, `operationNone}: inputData = {inputData[14:4], 1'b0, inputData[2:0]};
	
	//load instruction
	//loadir = 1, else = before -> Clk
	{`loadIR, `opCodeNone, `operaitonNone}: inputData = {inputData[14:1], 1'b1};
	
	//--------------
	
	
	//only loadir = 1, everything else is 0 
	//INSTRUCTION 1 //Write value of sximm8 into Rn register
	
	//nsel = Rn Vsel = SXIMM8 write = 1 loadir = 0  -> Clk
	{`writeInstrToRn, `MOV, `AND}: inputData = {`RN, `SXIMM8, inputData[10:9], 1'b1, inputData[7:1], 1'b0};
	
	//load instruction
	//---------------

	
	//only loadir = 1, everything else is 0 
	//INSTRUCTION 2 //Write shifted value of Rm register into Rd register 
	
	//read value from RM register 
	//nsel = RM loadir = 0 (write already 0), else = before -> Clk
	{`readRm, `MOV, `ADD}: inputData = {`RM, inputData[12:1], 1'b0,};
	
	//put specified reading value in B
	//loadb = 1, else = before -> Clk 
	{`putInB, `MOV, `ADD}: inputData = {inputData[14:10], 1'b1, inputData[8:0]};
	
	//Add A and Shifted B values and put into register C -> Clk
	//bsel = 0 asel = 1 loadc = 1, else = before -> Clk
	{`aluMovOpAndPutInC, `MOV, `ADD}: inputData = {inputData[14:8], 2'b10, inputData[5], 1'b1, inputData[3:0]};
	
	//Put value of C into Rd register
	//nsel = `RD vsel = `C write = 1, else = before -> Clk
	{`writeCInRd, `MOV, `ADD}: inputData = {`RD, `C, inputData[10:9], 1'b1, inputData[7:0]};
	
	//load instruction
	//---------------
	
	
	//only loadir = 1, everything else is 0 
	//INSTRUCTION 3 //Add values of Rn and shifted Rm and put it in Rd
	
	//read value from RM register 
	//nsel = RM loadir = 0 (write already 0), else = before -> Clk
	{`readRm, `ALU, `ADD}: inputData = {`RM, inputData[12:1], 1'b0,};
	
	//put specified reading value in B
	//loadb = 1, else = before -> Clk 
	{`putInB, `ALU, `ADD}: inputData = {inputData[14:10], 1'b1, inputData[8:0]};
	
	//read value from RN register
	//nsel = `Rn (write already 0), else = begore -> Clk
	{`readRn, `ALU, `ADD}: inputData = {`RN, inputData[12:0]};
	
	//put specified reading value in A
	//loadb = 0, loada = 1, else = before -> Clk
	{`putInA, `ALU, `ADD}: inputData = {inputData[14:11], 2'b10, inputData[8:0]};
	
	//do addition computations and load in register C
	//asel = 0 bsel = 0 loadc = 1, else - before -> Clk
	{`aluAddOpAndPutInC, `ALU, `ADD}: inputData = {inputData[14:8], 2'b00, inputData[5], 1'b1, inputData[3:0]};
	
	//Put Value of C into Rd
	//nsel = `RD vsel = `C write = 1, else = before -> Clk
	{`writeCInRd, `ALU, `ADD}: inputData = {`RD, `C, inputData[10:9], 1'b1, inputData[7:0]};
	
	//load instruction
	//------------
	
	
	//only loadir = 1, everything else is 0 
	//INSTRUCTION 4 //Find the status output of Rn - Shifted Rm 
	
	//read the value of Rm
	//nsel = RM loadir = 0 (write already 0), else = before -> Clk
	{`readRm, `ALU, `CMP}: inputData = {`RM, inputData[12:1], 1'b0,};
	
	//put specified reading value in register B
	//loadb = 1 loada= 0, else = before -> Clk 
	{`putInB, `ALU, `CMP}: inputData = {inputData[14:11], 2'b01, inputData[8:0]};
	
	//read value from RN register
	//nsel = `Rn (write already 0), else = begore -> Clk
	{`readRn, `ALU, `CMP}: inputData = {`RN, inputData[12:0]};
	
	//put specified reading value in A
	//loadb = 0, loada = 1, else = before -> Clk
	{`putInA, `ALU, `CMP}: inputData = {inputData[14:11], 2'b10, inputData[8:0]};
	
	//do subtraction computations and load in status
	//asel = 0 bsel = 0 loads = 1, else - before -> Clk
	{`aluSubOpAndPutInStatus, `ALU, `CMP}: inputData = {inputData[14:8], 3'b001, inputData[5:0]};
	
	//load instruction
	//-----------
	
	
	//INSTRUCTION 5 //Compute Rn ANDed with Shifted Rm and put it in Rd
	
	//read value from RM register 
	//nsel = RM loadir = 0 (write already 0), else = before -> Clk
	{`readRm, `ALU, `AND}: inputData = {`RM, inputData[12:1], 1'b0,};
		
	//put specified reading value in register B
	//loadb= 1 loada= 0, else = before -> Clk 
	{`putInB, `ALU, `AND}: inputData = {inputData[14:11], 2'b01, inputData[8:0]};

	//read value from RN register
	//nsel = `Rn (write already 0), else = begore -> Clk
	{`readRn, `ALU, `AND}: inputData = {`RN, inputData[12:0]};
	
	//put specified reading value in A
	//loadb = 0, loada = 1, else = before -> Clk
	{`putInA, `ALU, `AND}: inputData = {inputData[14:11], 2'b10, inputData[8:0]};

	//AND values inside reg A and B and then load it into C
	//bsel = 0 asel = 0 loadc = 1, else = before -> Clk
	{`aluAndOpAndPutInC, `ALU, `AND}: inputData = {inputData[14:8], 2'b00, inputData[5], 1'b1, inputData[3:0]};

	//Put Value of C into Rd
	//nsel = `RD vsel = `C write = 1, else = before -> Clk
	{`writeCInRd, `ALU, `AND}: inputData = {`RD, `C, inputData[10:9], 1'b1, inputData[7:0]};
	
	//load instruction
	//----------
	
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

//Instruction 3 -> Reused some from Instruction 2
`define readRn 5'b01001
`define `putInA 5'b01010
`define aluAddOpAndPutInC 5'b01011

//Instruction 4 
`define aluSubOpAndPutInStatus 5'b01100

//Instruction 5
`define aluAndOpAndPutInC 5'b01101






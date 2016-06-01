module controller(clk, AlUop, op, shift, opcode, readnum, writenum, loada, loadb, write, asel, bsel, loadc, loads, reset, loadpc, msel, mwrite, loadir, nsel, vsel );      
	input clk;
        input [1:0] ALUop, op, shift;
        input [2:0] opcode, readnum, writenum;
        output loada, loadb, write, asel, bsel, loadc, loads, reset, loadpc, msel, mwrite, loadir;
      	output [1:0] nsel, vsel;
        
	wire [3:0] currentState, nextState; 
	wire [2:0] opcode;
	wire [1:0] operation;
	wire [14:0] inputData;
	reg [3:0] nextStateToBeUpdated;
	
	//PC States
	//Initial State
	`define initiatePC 4'b0000
	
	//loading intructions
	`define loadPC 4'b0001
	`define loadRAM 4'b0010
	`define loadIR 4'b0011
	
	//General
	`define instrFirst 4'b0100
	`define instrLast 4'b0101
	
	//Instruction 2 
	`define putInB 4'b0110
	`define aluMovOpAndPutInC 4'b0111
	
	//ALU States
	//Instruction 3 
	`define readRn 4'b1000
	`define putInA 4'b1001
	`define aluAddOpAndPutInC 4'b1010
	
	//Instruction 5
	`define aluAndOpAndPutInC 4'b1011
	
	//Instruction 6
	`define aluNotMovOpAndPutInC 4'b1100
	
	//MEM States
	//Instruction 7
	`define aluMemLoadOpAndPutInC 4'b1101
	
	//Instruction 8
	`define aluMemStoreOpAndPutInC 4'b1110
	`define readRd 4'b1111
	
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
	
	//Register choosing
	`define RN 2'b00
	`define RD 2'b01
	`define RM 2'b10
	
	//vsel to choose with data to let in for the registers
	`define MDATA 2'b00
	`define SXIMM8 2'b01
	`define ZEROANDPC 2'b10
	`define C 2'b11 
	
	//State Updates
	//If reset, set program counter to 1
	assign nextState = reset? `initiatePC: nextStateToBeUpdated;
	//Update states based on clock
	DFlipFlop #(4) StateUpdate(clk, nextState, currentState);
	
	//initial read -> Set reset to 0 to start program counter
	always @(*) begin
		case(inputData)
			15'bxxxxxxxxxxxxxxx: reset=1;
			default: reset= 0;
		endcase
	end
	
	//All outputs needed for module instantiations
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
	//At start of each instruction, only loadir = 1, everything else is set to 0 from the instruction states
	always @(*)
		casex({currentState, opcode, op})
			//Set everything to zero for initial or reset state
			{`initiatePC, `opCodeNone, `operationNone}: inputData = {15'b000000000000000};
			//----------
			
			//INSTRUCTION COUNTER + RAM //Loading Instruction and Counter
			//Load counter value
			//loadPC = 1, else = 0 -> Clk //put all load values back into 0 when finished executing a command
			{`loadPC, `opCodeNone, `operationNone}:	inputData = {15'b000000000001000};
			
			//load value into RAM
			//loadPC = 0, else = before -> Clk
			{`loadRAM, `opCodeNone, `operationNone}: inputData = {inputData[14:4], 1'b0, inputData[2:0]};
			
			//load instruction
			//loadir = 1, else = before -> Clk
			{`loadIR, `opCodeNone, `operaitonNone}: inputData = {inputData[14:1], 1'b1};
			//----------
			
			//INSTRUCTION 1 //Write value of sximm8 into Rn register
			//nsel = Rn Vsel = SXIMM8 write = 1 loadir = 0  -> Clk
			{`instrFirst, `MOV, `AND}: inputData = {`RN, `SXIMM8, inputData[10:9], 1'b1, inputData[7:1], 1'b0};
			//----------
			
			//INSTRUCTION 2 //Write shifted value of Rm register into Rd register 
			//read value from RM register 
			//nsel = RM loadir = 0 (write already 0), else = before -> Clk
			{`instrFirst, `MOV, `ADD}: inputData = {`RM, inputData[12:1], 1'b0,};
			
			//put specified reading value in B
			//loadb = 1, else = before -> Clk 
			{`putInB, `MOV, `ADD}: inputData = {inputData[14:10], 1'b1, inputData[8:0]};
			
			//Add A and Shifted B values and put into register C -> Clk
			//bsel = 0 asel = 1 loadc = 1, else = before -> Clk
			{`aluMovOpAndPutInC, `MOV, `ADD}: inputData = {inputData[14:8], 2'b10, inputData[5], 1'b1, inputData[3:0]};
			
			//Put value of C into Rd register
			//nsel = `RD vsel = `C write = 1, else = before -> Clk
			{`instrLast, `MOV, `ADD}: inputData = {`RD, `C, inputData[10:9], 1'b1, inputData[7:0]};
			//----------
			
			//INSTRUCTION 3 //Add values of Rn and shifted Rm and put it in Rd
			//read value from RM register 
			//nsel = RM loadir = 0 (write already 0), else = before -> Clk
			{`instrFirst, `ALU, `ADD}: inputData = {`RM, inputData[12:1], 1'b0,};
			
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
			{`instrLast, `ALU, `ADD}: inputData = {`RD, `C, inputData[10:9], 1'b1, inputData[7:0]};
			//----------
			
			//INSTRUCTION 4 //Find the status output of Rn - Shifted Rm 
			//read the value of Rm
			//nsel = RM loadir = 0 (write already 0), else = before -> Clk
			{`instrFirst, `ALU, `CMP}: inputData = {`RM, inputData[12:1], 1'b0,};
			
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
			{`instrLast, `ALU, `CMP}: inputData = {inputData[14:8], 3'b001, inputData[5:0]};
			//----------
			
			//INSTRUCTION 5 //Compute Rn ANDed with Shifted Rm and put it in Rd
			//read value from RM register 
			//nsel = RM loadir = 0 (write already 0), else = before -> Clk
			{`instrFirst, `ALU, `AND}: inputData = {`RM, inputData[12:1], 1'b0,};
				
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
			{`instrLast, `ALU, `AND}: inputData = {`RD, `C, inputData[10:9], 1'b1, inputData[7:0]};
			//----------
			
			//INSTRUCTION 6 //Write NOTed shifted value of Rm register into Rd register 
			//read value from RM register 
			//nsel = RM loadir = 0 (write already 0), else = before -> Clk
			{`instrFirst, `ALU, `MVN}: inputData = {`RM, inputData[12:1], 1'b0,};
			
			//put specified reading value in B
			//loada= 0 loadb = 1, else = before -> Clk 
			{`putInB, `ALU, `MVN}: inputData = {inputData[14:11], 2'b01, inputData[8:0]};
			
			//Add A and Shifted B values and put into register C -> Clk
			//bsel = 0 asel = 1 loadc = 1, else = before -> Clk
			{`aluNotMovOpAndPutInC, `ALU, `MVN}: inputData = {inputData[14:8], 2'b10, inputData[5], 1'b1, inputData[3:0]};
			
			//Put value of C into Rd register
			//nsel = `RD vsel = `C write = 1, else = before -> Clk
			{`instrLast, `ALU, `MVN}: inputData = {`RD, `C, inputData[10:9], 1'b1, inputData[7:0]};
			//----------
			
			//INSTRUCTION 7 //load memory from address specified by Rn + imm5 nad put it into RD
			//read value from RN register
			//nsel = `Rn (write already 0) loadir = 0, else = begore -> Clk
			{`instrFirst, `LDR, `ADD}: inputData = {`RN, inputData[12:1], 1'b0};
			
			//put specified reading value in A
			//loadb = 0, loada = 1, else = before -> Clk
			{`putInA, `LDR, `ADD}: inputData = {inputData[14:11], 2'b10, inputData[8:0]};
		
			//load computed effective address into C
			//bsel = 1 asel = 0 and loadc = 1, else = before -> Clk
			{`aluMemLoadOpAndPutInC, `LDR, `ADD}: inputData = {inputData[14:8], 2'b01, inputData[5], 1'b1, inputData[3:0]};
			
			//load address into Ram and put mdata from RAM output into register RD
			//set msel = 1 mwrite = 0 vsel=`MDATA nsel=`RD 
			{`instrLast, `LDR, `ADD}: inputData = {`RD, `MDATA, inputData[10:3], 2'b10, inputData[0]};
			//----------
		
			//INSTRUCTION 8 //store value of register Rd into memory at address = sximm5+Rn
			//read value from RN register
			//nsel = `Rn (write already 0) loadir = 0, else = before -> Clk
			{`instrFirst, `STR, `ADD}: inputData = {`RN, inputData[12:1], 1'b0};
			
			//put specified reading value in A
			//loadb = 0, loada = 1, else = before -> Clk
			{`putInA, `STR, `ADD}: inputData = {inputData[14:11], 2'b10, inputData[8:0]};
		
			//load computed effective address into C
			//bsel = 1 asel = 0 and loadc = 1, else = before -> Clk
			{`aluMemStoreOpAndPutInC, `STR, `ADD}: inputData = {inputData[14:8], 2'b01, inputData[5], 1'b1, inputData[3:0]};
			
			//read value from RD register
			//nsel = `RD, else = before -> Clk
			{`readRd, `STR, `ADD}: inputData = {`RD, inputData[12:0]};
			
			//put specified reading value in B
			//loada = 0 loadb = 1, else = before -> Clk 
			{`putInB, `STR, `ADD}: inputData = {inputData[14:11], 2'b01, inputData[8:0]};
			
			//update value in B with address from C into RAM 
			//mwrite = 1 msel = 1, else = before -> Clk
			{`instrLast, `STR, `ADD}: inputData = {inputData[14:3], 2'b11, inputData[0]};
		endcase
	end
	
	always @(*) begin
		casex({currentState, opcode, op})
			//Counters and first and last parts of instructions
			//Set counter to zero for initial or reset state
			{`initiatePC, `opCodeNone, `operationNone}: nextStateToBeUpdated = `loadPC;
			
			//Loading Instruction and Counter
			{`loadPC, `opCodeNone, `operationNone}:	nextStateToBeUpdated = `loadRAM;
			{`loadRAM, `opCodeNone, `operationNone}: nextStateToBeUpdated = `loadIR;
			
			//When instruction loaded, move into first part of instruction
			{`loadIR, `opCodeNone, `operaitonNone}: nextStateToBeUpdated = `instrFirst;
			
			//When last part of instruction executed, counter+1 to load next instruction
			{`instrLast, `opCodeNone, `operaitonNone}: nextStateToBeUpdated = `loadPC;
			//----------
			
			//INSTRUCTION 1 
			{`instrFirst, `MOV, `AND}: nextStateToBeUpdated = `loadPC;
			//----------
			
			//INSTRUCTION 2 
			{`instrFirst, `MOV, `ADD}: nextStateToBeUpdated = `putInB;
			{`putInB, `MOV, `ADD}: nextStateToBeUpdated = `aluMovOpAndPutInC;
			{`aluMovOpAndPutInC, `MOV, `ADD}: nextStateToBeUpdated = `instrLast;
			//----------
			
			//INSTRUCTION 3 
			{`instrFirst, `ALU, `ADD}:  nextStateToBeUpdated = `putInB;
			{`putInB, `ALU, `ADD}: nextStateToBeUpdated = `readRn;
			{`readRn, `ALU, `ADD}: nextStateToBeUpdated = `putInA;
			{`putInA, `ALU, `ADD}: nextStateToBeUpdated = `aluAddOpAndPutInC;
			{`aluAddOpAndPutInC, `ALU, `ADD}: nextStateToBeUpdated = `instrLast;
			//----------
			
			//INSTRUCTION 4 //Find the status output of Rn - Shifted Rm 
			{`instrFirst, `ALU, `CMP}: nextStateToBeUpdated = `putInB;
			{`putInB, `ALU, `CMP}: nextStateToBeUpdated = `readRn;
			{`readRn, `ALU, `CMP}: nextStateToBeUpdated = `putInA;
			{`putInA, `ALU, `CMP}: nextStateToBeUpdated = `instrLast;
			//----------
			
			//INSTRUCTION 5 //Compute Rn ANDed with Shifted Rm and put it in Rd
			{`instrFirst, `ALU, `AND}: nextStateToBeUpdated = `putInB;
			{`putInB, `ALU, `AND}: nextStateToBeUpdated = `readRn;
			{`readRn, `ALU, `AND}: nextStateToBeUpdated = `putInA;
			{`putInA, `ALU, `AND}: nextStateToBeUpdated = `aluAndOpAndPutInC;
			{`aluAndOpAndPutInC, `ALU, `AND}: nextStateToBeUpdated = `instrLast;
			//----------
			
			//INSTRUCTION 6 //Write NOTed shifted value of Rm register into Rd register 
			{`instrFirst, `ALU, `MVN}: nextStateToBeUpdated = `putInB;
			{`putInB, `ALU, `MVN}: nextStateToBeUpdated = `aluNotMovOpAndPutInC;
			{`aluNotMovOpAndPutInC, `ALU, `MVN}: nextStateToBeUpdated = `instrLast;
			//----------
			
			//INSTRUCTION 7 //load memory from address specified by Rn + imm5 nad put it into RD
			{`instrFirst, `LDR, `ADD}: nextStateToBeUpdated = `putInA;
			{`putInA, `LDR, `ADD}: nextStateToBeUpdated = `aluMemLoadOpAndPutInC;
			{`aluMemLoadOpAndPutInC, `LDR, `ADD}: nextStateToBeUpdated = `instrLast;
			//----------
		
			//INSTRUCTION 8 //store value of register Rd into memory at address = sximm5+Rn
			{`instrFirst, `STR, `ADD}: nextStateToBeUpdated = `putInA;
			{`putInA, `STR, `ADD}: nextStateToBeUpdated = `aluMemStoreOpAndPutInC;
			{`aluMemStoreOpAndPutInC, `STR, `ADD}: nextStateToBeUpdated = `readRd;
			{`readRd, `STR, `ADD}: nextStateToBeUpdated = `putInB;
			{`putInB, `STR, `ADD}: nextStateToBeUpdated = `instrLast;
		endcase
	end
endmodule

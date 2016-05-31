module decoder(instruction, nsel, opcode, readnum, writenum, ALUop, op, shift, sximm5, sximm8);
        input [2:0] nsel;
        output [2:0] opcode, readnum, writenum;
        output [1:0] ALUop, op, shift;
        output [15:0] sximm5, sximm8;

module datapath(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, writenum, write, mdata, sximm5, sximm8, status, datapath_out);
	input clk, loada, loadb, write, vsel, asel, bsel, loadc, loads;
	input [2:0] readnum, writenum;
	input [1:0] shift, ALUop;
	input [15:0] mdata, sximm5, sximm8;
	
module counter(clk, reset, loadpc, msel, C,);
        input clk, reset, loadpc, msel;
        input [15:0] C;
       
RAM #(16,8,"data.txt") RAMInstantiate(
                (~KEY[0])		inp
                (readAddress), 		inp
                (writeAddress)		inp
                (write), 		inp
                (B),    		inp       //B is what is being written in
                (mdata) 		out   

module instructionReg(clk, mdata, loadir, instruction);
        
        input clk, loadir;
        input [15:0] mdata;
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

00: tempReg = Rn; //nsel 00 = Rn
	        	01: tempReg = Rd; //nsel 01 = Rd
	        	10: tempReg = Rm; //nsel 10 = Rm

//START HERE

module cpu();
//STATES
//instr 1 MOV Rn,#<imm8> take bits 0 to 7 of instruction (imm8) and put it in the register identified by register Rn bits 8-10 -> nsel=00 
`define MOV 3'b110
`define INSTRTOREG 2'b10
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


wire [4:0] currentState, nextState; 

always @(*)
	case(currentstate)
	{MOV,INSTRTOREG}: {nsel,vsel,write ={`RN,`SXIMM8VSEL,`ON, 

	case(vsel)
			00: data_in= mdata; 
			01: data_in= sximm8;
			10: data_in= {8'b00000000, PC};
			11: data_in= datapath_out;



 output [2:0] opcode, readnum, writenum;
        output [1:0] ALUop, op, shift;
        output [15:0] sximm5, sximm8;

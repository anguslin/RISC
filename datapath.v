
module datapath(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, writenum, write, datapath_in, status, datapath_out);

	//constants to define
	`define WIDTH 16
	`define STATUSWIDTH 1

	input clk, loada, loadb, write, vsel, asel, bsel, loadc, loads;
	input [2:0] readnum, writenum;
	input [1:0] shift, ALUop;
	input [15:0] datapath_in;
	output [15:0] datapath_out;
	output status
	
	wire [15:0] A, B, C, reg0, reg1, reg2, reg3, reg4 ,reg5 ,reg6 ,reg7;
	

Register instantiateReg(
  .clk(clk)
  .vsel(vsel)
  .write(write)
  .readnum(readnum)
  .reg1(reg1)
  .reg1(reg1)
  .reg1(reg1)



regFile REGISTER(
				.clk(clk),
				.write(write),
				.writenum(writenum),
				.readnum(readnum),
				.data_in(data_in),
				.data_out(data_out),
				.regi0(register0));
				

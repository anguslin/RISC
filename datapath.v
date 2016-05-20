module datapath(clk, readnum, vsel, loada, loadb, shift, axel, bel, ALUop, loadc, loads, writenum, write, datapath_in, status, datapath_out)
input clk, vsel, loada, loadb, write, asel, bsel, loadc, loads;
input [2:0] readnum, writenum;
input [15:0] datapath_in;
input [1:0] shift, ALUop
output [15:0] datapath_out;
wire [15:0] reg0, reg1, reg2, reg3, reg4 ,reg5 ,reg6 ,reg7, Ain, Bin, BShift, ALUComputedValue, C, A, B, statusComputed, status;
reg [15:0] AToUpdate, BToUpdate, CToUpdate, statusToUpdate, data_out, data_in;


//module Register(clk, vsel, loada, loadb, write, readnum)



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
				

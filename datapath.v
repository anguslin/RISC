//Datapath module of the RISC
module datapath(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, writenum, write, mdata, sximm5, sximm8, status, B, C);

//constants to define
`define WIDTH 16
`define STATUSWIDTH 3

input clk, loada, loadb, write, asel, bsel, loadc, loads;
input [2:0] readnum, writenum;
input [1:0] shift, ALUop, vsel;
input [15:0] mdata, sximm5, sximm8;
output [2:0] status;
output [15:0] B, C;

wire [15:0] A, reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7;

wire [7:0] PC; //no function currently
	
	//Instantiation of register module
register #(
		.width(`WIDTH)
		) instantiateReg(
	 	.clk(clk),
		.loada(loada),
		.loadb(loadb),
		.write(write),
		.readnum(readnum),
		.reg0(reg0),
		.reg1(reg1),
		.reg2(reg2),
		.reg3(reg3),
		.reg4(reg4),
		.reg5(reg5),
		.reg6(reg6),
		.reg7(reg7),
		.A(A),
		.B(B)
	 );
	 
	//Instatiation of computation module
	computation #(
		.width(`WIDTH),
		.statusWidth(`STATUSWIDTH) 
		) instantiateComp(
		.clk(clk), 
		.asel(asel), 
		.bsel(bsel), 
		.loadc(loadc), 
		.loads(loads), 
		.shift(shift), 
		.ALUop(ALUop),
		.A(A), 
		.B(B), 
		.sximm5(sximm5),
		.status(status), 
		.C(C)
	);

	//Instantiation of write module
	write #(
		.width(`WIDTH)
		) instantiateWrite(
		.clk(clk), 
		.vsel(vsel), 
		.write(write),
		.writenum(writenum), 
		.C(C), 
		.mdata(mdata), 
		.sximm8(sximm8),
		.PC(PC),
		.reg0(reg0), 
		.reg1(reg1), 
		.reg2(reg2), 
		.reg3(reg3), 
		.reg4(reg4), 
		.reg5(reg5), 
		.reg6(reg6), 
		.reg7(reg7)
	);

//module to control the datapath

module datapath_tb();

	reg clk_SIM, loada_SIM, loadb_SIM, write_SIM, vsel_SIM, asel_SIM, bsel_SIM, loadc_SIM, loads_SIM;
	reg [2:0] readnum_SIM, writenum_SIM;
	reg [1:0] shift_SIM, ALUop_SIM;
	reg [15:0] datapath_in_SIM;
	wire [15:0] datapath_out_SIM;
	wire status_SIM;
	

datapath DUT(
	.clk(clk_SIM), 
	.readnum(readnum_SIM),
	.vsel(vsel_SIM), 
	.loada(loada_SIM), 
	.loadb(loadb_SIM), 
	.shift(shift_SIM), 
	.asel(asel_SIM), 
	.bsel(bsel_SIM), 
	.ALUop(ALUop_SIM), 
	.loadc(loadc_SIM), 
	.loads(loads_SIM), 
	.writenum(writenum_SIM), 
	.write(write_SIM), 
	.datapath_in(datapath_in_SIM), 
	.status(status_SIM), 
	.datapath_out(datapath_out_SIM)
	);

	initial begin
		//Put 3 in reg 0
		vsel_SIM=1;
		#10;
		datapath_in_SIM = 16'b0000000000000011; //1+2=3
		#10;
		write_SIM = 1;
		#10;	
		writenum_SIM = 3'b000; //put in register 0
		#10;	

		//clk update
		clk_SIM = 0;
		#10;
		clk_SIM = 1;

		//put 4 in reg 1
		write_SIM = 1;
		#10;	
		writenum_SIM = 3'b001; //put in register 1
		#10;
		datapath_in_SIM = 16'b0000000000000100; //4
		#10;	

		//clk update
		clk_SIM = 0;
		#10;
		clk_SIM = 1;

		//Put 3 from reg 0 into A
		write_SIM = 0;
		#10;
		readnum_SIM = 000;
		#10;
		loadb_SIM= 0;
		#10;	
		loada_SIM= 1;
		#10;

		//clk update
		clk_SIM = 0;
		#10;
		clk_SIM = 1;

		//Put 4 from reg 1 into B
		write_SIM = 0;
		#10;
		readnum_SIM = 001;
		#10;
		loada_SIM= 0;
		#10	
		loadb_SIM= 1;
		#10;

		//clk update
		clk_SIM = 0;
		#10;
		clk_SIM = 1;

		//shift B value one to left
		shift_SIM = 01; //B = 8
	
		//Put values through to ALU
		asel_SIM=0;
		bsel_SIM =0;
		#10;

		//ALU
		ALUop_SIM [1:0]= 00; //add Ain + Bin
		#10;

		//Put values into C and status Reg
		loads_SIM = 1;
		loadc_SIM = 1;

		//clk update
		clk_SIM = 0;
		#10;
		clk_SIM = 1;
		#10;

		//put this value into reg 2
		vsel_SIM= 0;
		#10;
		writenum_SIM= 010;
		#10;
		write_SIM= 1;
		#10;

		//clk update
		clk_SIM = 0;
		#10;
		clk_SIM = 1;
		#10;
		clk_SIM = 0;
		#20;	

		$display("reg2 = 8 = 1000");
	end
endmodule

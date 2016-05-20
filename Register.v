module Register(clk, vsel, loada, loadb, write, readnum)
	input [2:0] readnum;
  	wire [15:0] reg0, reg1, reg2, reg3, reg4 ,reg5 ,reg6 ,reg7;
  	wire [15:0] A, B;
  	reg [15:0] AToUpdate, BToUpdate;
  	reg [15:0] data_out;
  
	  always @(*) begin
		casex(write, readnum, loada, loadb)
			6’b0000xx: data_out = reg0;	 		//if write is 0 and readnum is 000 take the value in register 0 and put in data_out
			6’b0001xx: data_out = reg1; 			//if write is 0 and readnum is 001 take the value in register 1 and put in data_out
			6’b0010xx: data_out = reg2; 			//if write is 0 and readnum is 010 take the value in register 2 and put in data_out
			6’b0011xx: data_out = reg3; 			//if write is 0 and readnum is 011 take the value in register 3 and put in data_out
			6’b0100xx: data_out = reg4;	 		//if write is 0 and readnum is 100 take the value in register 4 and put in data_out
			6’b0101xx: data_out = reg5; 			//if write is 0 and readnum is 101 take the value in register 5 and put in data_out
			6’b0110xx: data_out = reg6; 			//if write is 0 and readnum is 110 take the value in register 6 and put in data_out
			6’b0111xx: data_out = reg7; 			//if write is 0 and readnum is 111 take the value in register 7 and put in data_out
			6’b0xxx10: AtoUpdate = data_out; 		//if load a is 1 and load b is 0 put value of data_out in load a
			6’b0xxx01: BtoUpdate = data_out; 		//if load b is 1 and load a is 0 put value of data out in load b —> what if both 1? unsure
	
			default: {data_in, data_out, AToUpdate, BToUpdate} = {64{1’bx}};       //set everything to x for default
		endcasex
	end
	
	//Clock Upates for A and B //Instantiate DFlipFlop
	DFlipFlop #(16) loadaData(clk, A , AToUpdate); 		//A is running on a clock
	DFlipFlop #(16) loadbData(clk, B, BToUpdate); 		//B is running on a cock

endmodule

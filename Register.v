module Register(clk, vsel, loada, loadb, write, readnum)
  
	input clk, loada, loadb, write;
	input [2:0] readnum;
	input [15:0] reg0, reg1, reg2, reg3, reg4 ,reg5 ,reg6 ,reg7;
	output [15:0] A, B;
	reg [15:0] data_out;

	always @(*) begin
		case(readnum)
			3'b000: data_out= write? data_out: reg0; //if write= 0 and readnum= 000 data_out = reg0
			3'b001: data_out= write? data_out: reg1; //if write= 0 and readnum= 001 data_out = reg1
			3'b010: data_out= write? data_out: reg2; //if write= 0 and readnum= 010 data_out = reg2
			3'b011: data_out= write? data_out: reg3; //if write= 0 and readnum= 011 data_out = reg3
			3'b100: data_out= write? data_out: reg4; //if write= 0 and readnum= 100 data_out = reg4
			3'b101: data_out= write? data_out: reg5; //if write= 0 and readnum= 101 data_out = reg5
			3'b110: data_out= write? data_out: reg6; //if write= 0 and readnum= 110 data_out = reg6
			3'b111: data_out= write? data_out: reg7; //if write= 0 and readnum= 111 data_out = reg7
			default: data_out= {`WIDTH{1'bx}}; //set everything to x for default
		endcase
	end

	//Clock Updates for A and B depending on clock and loada and loadb
	DFlipFlopAllow #(`WIDTH) loadaData(clk, loada, data_out, A); //A= running on a clock
	DFlipFlopAllow #(`WIDTH) loadbData(clk, loadb, data_out, B); //B= running on a clock

endmodule

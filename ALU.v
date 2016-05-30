//ALU operations
module ALU(ALUop, Ain, Bin, ALUComputedValue);

	`define ADD 00
	`define SUB 01
	`define ANDVAL 10
	`define NOTB 11
	

	parameter width= 1;
	input [1:0] ALUop;
	input [15:0] Ain, Bin;
	output [15:0] ALUComputedValue;
	reg [15:0] ALUComputedValue;

	always @(*) begin
		case(ALUop)
			`ADD: ALUComputedValue= Ain + Bin;		//if operation= 00 output= Ain + Bin
			`SUB: ALUComputedValue= Ain - Bin;		//if operation= 01 output= Ain - Bin
			`ANDVAL: ALUComputedValue= Ain & Bin;		//if operation= 10 output= Ain AND Bin
			`NOTB: ALUComputedValue= ~Bin;			//if operation= 11 output= not Bin
			default: ALUComputedValue= {width{1'bx}};	//default all x
		endcase
	end
endmodule

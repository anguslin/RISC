//ALU operations
module ALU(ALUop, Ain, Bin, ALUComputedValue);

	parameter width= 1;
	input [1:0] ALUop;
	input [15:0] Ain, Bin;
	output [15:0] ALUComputedValue;

	always @(*) begin
		case(ALUop)
			2'b00: ALUComputedValue= Ain + Bin;		//if operation= 00 output= Ain + Bin
			2'b01: ALUComputedValue= Ain - Bin;		//if operation= 01 output= Ain - Bin
			2'b10: ALUComputedValue= Ain & Bin;		//if operation= 10 output= Ain AND Bin
			2'b11: ALUComputedValue= ~Bin;			//if operation= 11 output= not Bin
			default: ALUComputedValue= {width{1'bx}};	//default all x
		endcase
	end
endmodule

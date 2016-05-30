//ALU operations
module ALU(ALUop, Ain, Bin, ALUComputedValue, overflow);

	`define ADD 2'b00
	`define SUB 2'b01
	`define ANDVAL 2'b10
	`define NOTB 2'b11

	parameter width= 1;
	input [1:0] ALUop;
	input [15:0] Ain, Bin;
	output [15:0] ALUComputedValue;
	output overflow;
	reg [15:0] ALUComputedValue;
	wire [15:0] computedValueTemp;
	reg addSubVals, andVals, notBVal, sub;
       
	always @(*) begin
		case(ALUop)
			`ADD: {addSubVals, andVals, notBVal, sub}= {4'b1000};	
			`SUB: {addSubVals, andVals, notBVal, sub}= {4'b1001};		
			`ANDVAL: {addSubVals, andVals, notBVal, sub}= {4'b0100};		
			`NOTB: {addSubVals, andVals, notBVal, sub}= {4'b0010};			
			default: {addSubVals, andVals, notBVal, sub}= {4'bxxxx};	//default all x
		endcase
	end
	
	//Instatiate operation module to compute the specified operation
	operation #(16) instatiateOperation(
		.Ain(Ain), 
		.Bin(Bin),  
		.overflow(overflow), 
		.addSubVals(addSubVals), 
		.andVals(andVals), 
		.notBVal(notBVal), 
		.sub(sub), 
		.computedValue(computedValue)
		);

endmodule

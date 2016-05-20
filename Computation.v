module Computation(shift, ALUop, bsel, loadc, loads);

	input [1:0] shift, ALUop;
	input asel, bsel, loadc, loads;
	wire [15:0] Ain, Bin Bshift ALUComputedValue, C; 
	wire statusComputed, status;
	reg statusToUpdate;
	reg [15:0] CToUpdate;
	
	//Operations for Computation Stage
	always @(*) begin
		casex(asel, bsel, loadc,loads)
			4’b1xxx: Ain =  A;	            	          	//if asel is 1 set Ain = A value 
			4’b0xxx: Ain = {16{1’b0}}                         	//if asel is 0 set Ain = 16bit 0s
			4’bx0xx: Bin = Bshift;	                      	  	//if bsel is 0 set Bin = to shifted B value
			4’bx1xx: Bin = {{11{1’b0}},datapath_in[4:0]};		//if bsel is 1 set Bin = to 11bits 0s + first 5 bits of datapath_in
			4’bxx1x: CToUpdate = ALUComputedValue			//if loadc is 1 load computed ALU value into CToUpdate (wait for clock)
			4’bxxx1: statusToUpdate = statusComputed			//if loadc is 1 load computed status value into statusToUpdate (wait for clock)
			
			default: {Ain, Bin, CToUpdate, statusToUpdate} = {49{1’bx}}      //set everything to x for default
		endcase
	end
	
	//Clock updates for status and C
	DFlipFlop #(1) loadaData(clk, status , statusToUpdate); 	//status is running on a clock
	DFlipFlop #(16) loadbData(clk, C, CToUpdate); 		        //C is running on a cock
	
	//Values for ALU and status
	always @(*) begin
		case(ALUComputedValue)
			16’b0000000000000000: statusComputed = 1; 	//if all 0 then status value to be updated will be 0 
			default: statusComputed =0;			//if not all 0 then status value to be updated will be 1
		endcase
	end
	
	//Shift operations
	always @(*) begin
		case(shift)
			2’b00: Bshift = B;				//if operation is 00 output is B
			2’b01: Bshift = {B[14:0], 1’b0};			//if operation is 01 output is B shifted left one and right bit becomes 0 
			2’b10: Bshift = {1’b0, B[15:1]};			//if operation is 10 output is B shifted right one and left bit becomes 0 
			2’b11: Bshift = {B[15], B[15:1]};		//if operation is 11 output is B shifted right one and left bit becomes b[15]
		endcase
	end
	
	//ALUop operations
	always @(*) begin
		case(ALUop)
			2’b00: ALUComputedValue = Ain + Bin;		//if operation is 00 output is Ain + Bin
			2’b01: ALUComputedValue = Ain - Bin;		//if operation is 01 output is Ain - Bin
			2’b10: ALUComputedValue = Ain & Bin;		//if operation is 10 output is Ain AND Bin
			2’b11: ALUComputedValue = ~Bin;			//if operation is 11 output is not Bin
		endcase
	end

endmodule


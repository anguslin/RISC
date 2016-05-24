module Computation(shift, ALUop, bsel, loadc, loads);

	input [1:0] shift, ALUop;
	input clk, asel, bsel, loadc, loads;
	input [15:0] datapath_in, A, B;
	reg [15:0] BShift, ALUComputedValue;
	reg statusComputed;
	wire [15:0] Ain, Bin;
	output status;
	output [15:0] C;
	
	//if asel= 1 set Ain= A value else set Ain= 0s 
	assign Ain= asel? A: {`WIDTH{1'b0}}; 

	//if bsel= 0 set Bin= to shifted B value else set Bin= to 11bits 0s + first 5 bits of datapath_in
	assign Bin= bsel? {{11{1'b0}},datapath_in[4:0]}: BShift; 

	//Clock updates for status and C
	DFlipFlopAllow #(`STATUSWIDTH) loadStatusData(clk, loads, statusComputed, status); 	//status= running on a clock
	DFlipFlopAllow #(`WIDTH) loadCData(clk, loadc, ALUComputedValue, C); 		//C= running on a clock

	//Values for ALU and status
	always @(*) begin
		case(ALUComputedValue)
			16'b0000000000000000: statusComputed= 1; 	//if all 0 then status value to be updated will be 0 
			default: statusComputed= 0;			//if not all 0 then status value to be updated will be 1
		endcase
	end

	//Shift operations
	always @(*) begin
		case(shift)
			2'b00: BShift= B;			//if operation= 00 output= B
			2'b01: BShift= {B[14:0], 1'b0};		//if operation= 01 output= B shifted left one and right bit= 0 
			2'b10: BShift= {1'b0, B[15:1]} ;	//if operation= 10 output= B shifted right one and left bit= 0 
			2'b11: BShift= {B[15], B[15:1]};	//if operation= 11 output= B shifted right one and left bit= b[15]
			default: BShift= {`WIDTH{1'bx}};	//default all to x
		endcase
	end

	//ALUop operations
	always @(*) begin
		case(ALUop)
			2'b00: ALUComputedValue= Ain + Bin;		//if operation= 00 output= Ain + Bin
			2'b01: ALUComputedValue= Ain - Bin;		//if operation= 01 output= Ain - Bin
			2'b10: ALUComputedValue= Ain & Bin;		//if operation= 10 output= Ain AND Bin
			2'b11: ALUComputedValue= ~Bin;			//if operation= 11 output= not Bin
			default: ALUComputedValue= {`WIDTH{1'bx}};	//default all x
		endcase
	end

endmodule


module computation(clk, asel, bsel, loadc, loads, shift, ALUop, datapath_in, A, B, sximm5, status, C);

	parameter width= 1;
	parameter statusWidth= 1;
	input clk, asel, bsel, loadc, loads;
	input [1:0] shift, ALUop;
	input [15:0] datapath_in, A, B, sximm5;
	output status;
	output [15:0] C;
	reg statusComputed;
	wire [15:0] Ain, Bin, BShift, ALUComputedValue;

	//if asel= 0 set Ain= A value else set Ain= 0s 
	assign Ain= asel? {width{1'b0}}: A; 

	//if bsel= 0 set Bin= to shifted B value else set Bin= to 11bits 0s + first 5 bits of datapath_in
	assign Bin= bsel? sximm5: BShift; 

	//Clock updates for status and C
	DFlipFlopAllow #(statusWidth) loadStatusData(clk, loads, statusComputed, status); 	//status= running on a clock
	DFlipFlopAllow #(width) loadCData(clk, loadc, ALUComputedValue, C); 		//C= running on a clock

	//Values for ALU and status
	always @(*) begin
		case(ALUComputedValue)
			16'b0000000000000000: statusComputed= 1; 	//if all 0 then status value to be updated will be 0 
			default: statusComputed= 0;			//if not all 0 then status value to be updated will be 1
		endcase
	end
	
	//Shift Operations
	shift #(width) instantiateShift(
		.B(B), 
		.BShift(BShift),
		.shift(shift)
	);
	
	//ALU Operations
	ALU #(width) instatiateOperation(
		.ALUop(ALUop), 
		.Ain(Ain), 
		.Bin(Bin), 
		.ALUComputedValue(ALUComputedValue)
	);
endmodule

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
		4’b1xxx: Ain =  A; 					                          //if asel is 1 set Ain = A value 
		4’b0xxx: Ain = {16{1’b0}} 				                    //if asel is 0 set Ain = 16bit 0s
		4’bx0xx: Bin = Bshift; 			                      	  //if bsel is 0 set Bin = to shifted B value
		4’bx1xx: Bin = {{11{1’b0}},datapath_in[4:0]};	        //if bsel is 1 set Bin = to 11bits 0s + first 5 bits of datapath_in
		4’bxx1x: CToUpdate = ALUComputedValue	                //if loadc is 1 load computed ALU value into CToUpdate (wait for clock)
		4’bxxx1: statusToUpdate = statusComputed	            //if loadc is 1 load computed status value into statusToUpdate (wait for clock)
		
		default: {Ain, Bin, CToUpdate, statusToUpdate} = {49{1’bx}}       //set everything to x for default
	endcasex
end

//Clock updates for status and C
DFlipFlop #(1) loadaData(clk, status , statusToUpdate); 		//status is running on a clock
DFlipFlop #(16) loadbData(clk, C, CToUpdate); 		        	//C is running on a cock

Register RegisterInstatiation ( 
 .readnum     (readnum),
  .vsel        (vsel)
);

Shift ShiftInstatiation ( 
 .readnum     (readnum),
  .vsel        (vsel)
);

ALUOperation ALUInstatiation ( 
 .readnum     (readnum),
  .vsel        (vsel)
);


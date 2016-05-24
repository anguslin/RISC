//Shift operations
module Shift(B, BShift);

	input [15:0] B;
	output [15:0] BShift;

	always @(*) begin
		case(shift)
			2'b00: BShift= B;			//if operation= 00 output= B
			2'b01: BShift= {B[14:0], 1'b0};		//if operation= 01 output= B shifted left one and right bit= 0 
			2'b10: BShift= {1'b0, B[15:1]} ;	//if operation= 10 output= B shifted right one and left bit= 0 
			2'b11: BShift= {B[15], B[15:1]};	//if operation= 11 output= B shifted right one and left bit= b[15]
			default: BShift= {`WIDTH{1'bx}};	//default all to x
		endcase
	end
endmodule

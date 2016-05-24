module Write(clk, vsel, write, writenum, C, datapath_in, datapath_out, reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7);

	input clk, vsel, write;
	input [2:0] writenum;
	input [15:0] C, datapath_in;
	output [15:0] datapath_out, reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7;
	wire [15:0] data_in;
	reg [15:0] reg0ToUpdate, reg1ToUpdate, reg2ToUpdate, reg3ToUpdate, reg4ToUpdate, reg5ToUpdate, reg6ToUpdate, reg7ToUpdate;
	
	//Update based on clock
	always @(*) begin
		case(writenum)
			3'b000: reg0ToUpdate= write? data_in: reg0ToUpdate; 	//if write= 1 and writenum= 000
			3'b001: reg1ToUpdate= write? data_in: reg1ToUpdate; 	//if write= 1 and writenum= 001 
			3'b010: reg2ToUpdate= write? data_in: reg2ToUpdate; 	//if write= 1 and writenum= 010 
			3'b011: reg3ToUpdate= write? data_in: reg3ToUpdate; 	//if write= 1 and writenum= 011 
			3'b100: reg4ToUpdate= write? data_in: reg4ToUpdate; 	//if write= 1 and writenum= 100 
			3'b101: reg5ToUpdate= write? data_in: reg5ToUpdate;	//if write= 1 and writenum= 101 
			3'b110: reg6ToUpdate= write? data_in: reg6ToUpdate;	//if write= 1 and writenum= 110 
			3'b111: reg7ToUpdate= write? data_in: reg7ToUpdate; 	//if write= 1 and writenum= 111 
			default: {reg0ToUpdate,reg1ToUpdate,reg2ToUpdate,reg3ToUpdate,reg4ToUpdate,reg5ToUpdate,reg6ToUpdate,reg7ToUpdate}= {112{1'bx}};	//default all x
		endcase
	end

	//Update registers on a clock
	DFlipFlop #(`WIDTH) loadreg0Data(clk, reg0ToUpdate, reg0);
	DFlipFlop #(`WIDTH) loadreg1Data(clk, reg1ToUpdate, reg1);
	DFlipFlop #(`WIDTH) loadreg2Data(clk, reg2ToUpdate, reg2);
	DFlipFlop #(`WIDTH) loadreg3Data(clk, reg3ToUpdate, reg3);
	DFlipFlop #(`WIDTH) loadreg4Data(clk, reg4ToUpdate, reg4);
	DFlipFlop #(`WIDTH) loadreg5Data(clk, reg5ToUpdate, reg5);
	DFlipFlop #(`WIDTH) loadreg6Data(clk, reg6ToUpdate, reg6);
	DFlipFlop #(`WIDTH) loadreg7Data(clk, reg7ToUpdate, reg7);

	//if vsel= 1 input values from datapath_in to data_in else data_in= datapath_in
	assign data_in= vsel? datapath_in: datapath_out; 

	assign datapath_out= C; 
	
endmodule

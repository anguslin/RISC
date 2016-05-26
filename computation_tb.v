module computation_tb();

	reg asel_SIM, bsel_SIM, loadc_SIM, loads_SIM, clk_SIM;
	reg [1:0] ALUop_SIM, shift_SIM;
	reg [15:0] A_SIM, B_SIM;
	wire status_SIM;
	wire [15:0] C_SIM, datapath_in_SIM;

	`define WIDTH 16
	`define STATUSWIDTH 1

	computation #(
		.width(`WIDTH),
		.statusWidth(`STATUSWIDTH)
		) DUT(
		.clk			(clk_SIM), 
		.asel			(asel_SIM), 
		.bsel			(bsel_SIM), 
		.loadc			(loadc_SIM), 
		.loads			(loads_SIM), 
		.shift			(shift_SIM), 
		.ALUop			(ALUop_SIM), 
		.datapath_in	(datapath_in_SIM), 
		.A				(A_SIM), 
		.B				(B_SIM), 
		.status			(status_SIM), 
		.C				(C_SIM)
		);

	initial begin
		loadc_SIM= 1;
		loads_SIM= 1;
		asel_SIM= 1;
		bsel_SIM= 0;
		B_SIM [15:0]= 16'b0000000000011101; //1+4+8+16= 29
		A_SIM [15:0]= 16'b0000000000101110; //2+4+8+32= 46
		ALUop_SIM [1:0]= 00; //add Ain + Bin
		shift_SIM [1:0]= 10; // B = shifted right one and left bit = 0 -> 2+4+8 =14 //ALUComputed= 60
		$display("ALUComputed = 60 = 00111100");
		#10;

			repeat(2) begin
				#10;
				clk_SIM = 1;
				#10;
				clk_SIM = 0;
			end

		#10;
		asel_SIM= 1;
		#10;
		bsel_SIM= 0;
		#10;
		B_SIM [15:0]= 16'b0000000000011101; //1+4+8+16= 29
		#10;
		A_SIM [15:0]= 16'b0000000000101110; //2+4+8+32= 46
		#10;
		ALUop_SIM [1:0]= 00; //add Ain + Bin
		#10;
		shift_SIM [1:0]= 01; // B = shifted left one and right bit = 0 -> 2+8+16+32= 58 //ALUcomputed = 104
		$display("ALUComputed = 104 = 01101000");
		#10;
		
			repeat(2) begin
				#10;
				clk_SIM = 1;
				#10;
				clk_SIM = 0;
			end
	end	

endmodule


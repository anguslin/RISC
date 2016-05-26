module computation_tb

	computation #(16)
		DUT(
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
		.C				(C_SIM),
		);

	initial begin
		asel_SIM= 1;
		bsel_SIM= 0;
		B_SIM [15:0]= 16’b0000000000011101; //1+4+8+16= 29
		A_SIM [15:0]= 16’b0000000000101110; //2+4+8+32= 46
		ALUop_SIM [1:0]= 00; //add Ain + Bin
		shift [1:0]= 10 // B = shifted right one and left bit = 0 -> 2+4+8 =14
		//ALUComputed should equal 60

	repeat(2) begin
	#10;
	clk_SIM = 1;
	#10;
	clk_SIM = 0;
	end

		asel_SIM= 1;
		bsel_SIM= 0;
		B_SIM [15:0]= 16’b0000000000011101; //1+4+8+16= 29
		A_SIM [15:0]= 16’b0000000000101110; //2+4+8+32= 46
		ALUop_SIM [1:0]= 00; //add Ain + Bin
		shift [1:0]= 01 // B = shifted left one and right bit = 0 -> 2+8+16+32= 58
		//ALUComputed should equal 104
		
repeat(2) begin
	#10;
	clk_SIM = 1;
	#10;
	clk_SIM = 0;
	end

	end	

endmodule



module top_tb();

reg [3:0] KEY_SIM;
wire CLOCK_50_SIM;
wire [9:0] LEDR_SIM;
wire [6:0] HEX0_SIM, HEX1_SIM, HEX2_SIM, HEX3_SIM, HEX4_SIM, HEX5_SIM;

top DUT (
	.KEY(KEY_SIM),
        .CLOCK_50(CLOCK_50_SIM), 
        .LEDR(LEDR_SIM), 
        .HEX0(HEX0_SIM), 
	.HEX1(HEX1_SIM), 
	.HEX2(HEX2_SIM), 
	.HEX3(HEX3_SIM), 
	.HEX4(HEX4_SIM), 
	.HEX5(HEX5_SIM)
	);
       
	initial begin
		KEY_SIM[3:0] = 4'b0011;
		
		#10;
		KEY_SIM[1] = 1'b0;
		#10;
		KEY_SIM[0] = 1'b0;
		#10;
		KEY_SIM[0] = 1'b1;
		#10;
		KEY_SIM[1] = 1'b1;
		#10;

		repeat(10) begin
			#10;
			KEY_SIM[0] = 0;
			#10;
			KEY_SIM[0] = 1;
		end

	
	end
endmodule

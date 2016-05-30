module status(ALUComputedValue, status, overflow);

        output [2:0] status;
        output overflow;
        wire [15:0] ALUComputedValue;
        wire zeroVal;
        
        //Values status if all 0s
        	always @(*) begin
        		case(ALUComputedValue)
        			16'b0000000000000000: zeroVal= 1; 	//if all 0 then status value to be updated will be 0 
        			default: zeroVal= 0;			//if not all 0 then status value to be updated will be 1
        		endcase
        	end
        	
        //status[2]= overflow flag
        //status[1]= negative flag
        //status[0]= zero flag
        assign status = {overflow, ALUComputedValue[15], zeroVal};

endmodule

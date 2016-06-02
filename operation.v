module operation (Ain, Bin, addSubVals, andVals, notBVal, sub, computedValue, overflow);

        parameter width= 1;
        input [width-1:0] Ain, Bin;
        input addSubVals, andVals, notBVal, sub;
        output [width-1:0] computedValue;
	reg [width-1:0] computedValue;
        output overflow;
        wire sign, lastNonSign;
	wire [width-1:0] holder;
        
	always @(*) begin
		case({addSubVals, sub, andVals, notBVal})
			4'b1000: computedValue = Ain + Bin;	//Addition
			4'b1100: computedValue = Ain - Bin;	//Subtraction	
			4'b0010: computedValue = Ain & Bin; 	//And Operation
			4'b0001: computedValue = ~Bin; 		//Not Operation
			default: computedValue = {width{1'bx}};
		endcase
	end

        //Detect overflow
        assign overflow= addSubVals? sign ^ lastNonSign : 1'b0; //XOR gate; if not the same => overflow

	//Used to compute sign and and lastNonSign values to detect for overflow
        //Arithmetic on Non Sign Bits
        //if subtract, then convert to Two's Complement and then add
        assign {lastNonSign, holder[width-2:0]}= addSubVals? Ain[width-2:0] + (Bin[width-2:0] ^ {width-1{sub}}) + sub: {lastNonSign, holder[width-2:0]};
        //Arithmetic on Sign Bits
        assign {sign, holder[width-1]}= addSubVals? Ain[width-1] + (Bin[width-1] ^ sub) + lastNonSign: {sign, computedValue[width-1]};
          
endmodule

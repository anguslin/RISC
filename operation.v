module operation (Ain, Bin, overflow, addSubVals, andVals, notBVal, sub, computedValue);

        parameter width= 1;
        input [width-1:0] Ain, Bin;
        input overflow, addSubVals, andVals, notBVal, sub;
        output [width-1:0] computedValue;
        wire sign, lastNonSign;
        
        always@(*) begin
        //subtraction or add
                case({addSubVals, andVals, notBVal})
                        3'b100:
                                overflow = sign ^ lastNonSign; //XOR gate; if not the same => overflow
                                //Arithmetic on Non Sign Bits
                                //if subtract, then convert to Two's Complement and then add
                                {lastNonSign, computedValue[width-2:0]}= {Ain[width-2:0] + Bin[width-2:0] ^ {width-1{sub}} + sub;
                                //Arithmetic on Sign Bits
                                {sign, computedValue[width-1]}= {Ain[width-1] + (Bin[width-1] ^ sub) + lastNonSign;
                        3'b010: //If and A with B
                                {computedValue, overflow} = {Ain & Bin, 1'b0};
                        3'b001: //If not B
                                {computedValue, overflow} = {~Bin, 1'b0};
                        default: 
                                {computedValue, overflow} = {width+1{1'bx}};
        end
endmodule

module operation (Ain, Bin, overflow, addSubVals, andVals, notBVal, sub, computedValue);

        parameter width= 1;
        input [width-1:0] Ain, Bin;
        input overflow, addSubVals, andVals, notBVal, sub;
        output [width-1:0] computedValue;
        wire sign, lastNonSign;
        
        always@(*) begin
                if(addSubVals) begin
                        assign overflow = sign ^ lastNonSign; //XOR gate; if not the same => overflow
                        
                        //Arithmetic on Non Sign Bits
                        //if subtract, then convert to Two's Complement and then add
                        assign {lastNonSign, computedValue[width-2:0]}= {Ain[width-2:0] + Bin[width-2:0] ^ {width-1{sub}} + sub;
                        
                        //Arithmetic on Sign Bits
                        assign {sign, computedValue[width-1]}= {Ain[width-1] + (Bin[width-1] ^ sub) + lastNonSign;
                end
        end
        
        always@(*) begin
                if(andVals) begin
                        computedValue = Ain & Bin;
                end
        end
        
        always@(*) begin
                if(notBVal) begin
                        computedValue = ~Bin;
                end
        end

endmodule

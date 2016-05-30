module operation (Ain, Bin, addSubVals, andVals, notBVal, sub, computedValue, overflow);

        parameter width= 1;
        input [width-1:0] Ain, Bin;
        input addSubVals, andVals, notBVal, sub;
        output [width-1:0] computedValue;
        output overflow;
        wire sign, lastNonSign;
        
        //Adding or Subtracting Operation
        assign overflow = addSubVals? sign ^ lastNonSign : 1'b0; //XOR gate; if not the same => overflow
        //Arithmetic on Non Sign Bits
        //if subtract, then convert to Two's Complement and then add
        assign {lastNonSign, computedValue[width-2:0]}= addSubVals? {Ain[width-2:0] + Bin[width-2:0] ^ {width-1{sub}} + sub: {lastNonSign, computedValue[width-2:0]} ;
        //Arithmetic on Sign Bits
        assign {sign, computedValue[width-1]}= addSubVals? {Ain[width-1] + (Bin[width-1] ^ sub) + lastNonSign: {sign, computedValue[width-1]};
       
        //And Operation
        //If and A with B
        assign computedValue = andVals? Ain & Bin: computedValue;    
        
        //Not Operation
        //If not B
        assign computedValue = notBVal? ~Bin: computedValue;
                      
endmodule

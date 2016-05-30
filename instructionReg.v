module instructionReg(mdata, loadir, instruction);
        
        input [15:0] mdata;
        input loadir;
        output [15:0] instruction;
        
        //Update instruction on a clock depending on (loadir)
        DFlipFlopAllow #(16) updateInstruction(clk, loadir, mdata, instruction);

endmodule

module instructionReg(clk, mdata, loadir, instruction);
        
        input clk, loadir;
        input [15:0] mdata;
        output [15:0] instruction;
        
        //Update instruction on a clock depending on (loadir)
        DFlipFlopAllow #(16) updateInstruction(clk, loadir, mdata, instruction);

endmodule

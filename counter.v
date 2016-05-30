//module for program counter

module counter(reset, loadpc, msel, out, C);
        
        `define COUNTWIDTH 8
        input reset, loadpc, msel;
        input [15:0] C;
        output [7:0] out;
        wire [7:0] loadValue, countOut, countOutToBeUpdated;
        
        assign loadValue = loadpc? out + 1'b1 : out;
        assign out = msel? C[7:0] : countOut;
        assign outToBeUpdated= reset? 8'b00000000 : loadValue;
        //update on rising clock
        DFlipFlop #(`COUNTWIDTH) loadCountOut(clk, countOutToBeUpdated, countOut); 

endmodule

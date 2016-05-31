//module for program counter
module counter(clk, reset, loadpc, msel, out, C);
        
        input clk, reset, loadpc, msel;
        input [15:0] C;
        output [7:0] address;
        wire [7:0] loadValue, addressOut, addressToBeUpdated;
        
        //assign values
        assign loadValue = loadpc? addressOut + 1'b1 : addressOut;
        assign addressToBeUpdated= reset? 8'b00000000 : loadValue;
        
        //update on rising clock
        DFlipFlop #(8) loadCountOut(clk, addressToBeUpdated, addressOut); 
        
        //address value to be input into RAM
        assign address = msel? C[7:0] : addressOut;
        
endmodule

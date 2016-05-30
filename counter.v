//module for program counter

module counter(reset, loadpc, out);
        
        `define COUNTWIDTH 8;
        input reset, loadpc;
        output [7:0] out;
        wire [7:0] loadValue, outToBeUpdated;
        
        assign loadValue = loadpc? out + 1'b1 : out;
        assign outToBeUpdated= reset? 8'b00000000 : loadValue;
        DFlipFlop #(`COUNTWIDTH) loadOut(clk, outToBeUpdated, out);

endmodule

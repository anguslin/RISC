//D Flip Flop with enabling property

module DFlipFlopAllow(clk, allow, in, out) ;
  parameter width = 1;  // width
  input clk, allow ;
  input [width-1:0] in ;
  output [width-1:0] out ;
  reg [width-1:0] out ;
  wire [width-1:0] toBeUpdated;

assign toBeUpdated = allow? in : out; //only update if allowed

  always @(posedge clk) 
    out = toBeUpdated ; 
endmodule

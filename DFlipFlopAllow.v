//D Flip Flop with enabling property

module DFlipFlopAllow(clk, allow, in, out) ;
  parameter n = 1;  // width
  input clk, allow ;
  input [n-1:0] in ;
  output [n-1:0] out ;
  reg [n-1:0] out ;
  wire toBeUpdate [n-1:0];

assign toBeUpdated = allow? in : out; //only update if allowed

  always @(posedge clk) 
    out = toBeUpdated ; 
endmodule

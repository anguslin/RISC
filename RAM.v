module RAM(clk, readAddress, writeAddress, write, in, out);

        parameter dataWidth = 16;       //size of data in each address
        parameter addrWidth = 8;        //size of address
        parameter filename = "data.txt";

        input clk, write;
        input [addrWidth-1:0] readAddress, writeAddress;
        input [dataWidth-1:0] in;
        output [dataWidth-1:0] out;
        reg [dataWidth-1:0] out;
        reg [dataWidth-1:0] mem[2**addrWidth-1:0];
        
        initial $readmemb(filename, mem);
        
        always @ (posedge clk) begin
                if (write) begin
                        mem[writeAddress] <= in;
                end
                out <= mem[readAddress]; 
        end
endmodule

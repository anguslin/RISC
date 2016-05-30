module RAM(clk, readAddress, writeAddress, write, in, out);

        parameter dataWidth = 32; //size of data
        parameter multWidth = 4;	//4 bytes needed per 32 bits of data 
        parameter filename = "data.txt";

        input clk, write;
        input [multWidth-1:0] readAddress, writeAddress;
        input [dataWidth-1:0] in;
        output [dataWidth-1:0] out;
        reg [dataWidth-1:0] out;
        reg [dataWidth-1:0] mem[2**multWidth-1:0];
        
        initial $readmemb(filename, mem);
        
        always @ (posedge clk) begin
                if (write) begin
                        mem[writeAddress] <= din;
                end
                out <= mem[readAddress]; 
        end
endmodule

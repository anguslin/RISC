// DE1-SOC Interface Specification

// KEY0= rising lock edge (When pressed) 
// LEDR[9:7]= status register output
// HEX3, HEX2, HEX1, HEX0= wired to datapath_out for LED display

module top(KEY, CLOCK_50, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

        input [3:0] KEY;
        input CLOCK_50; //VERIFY THE PURPOSE OF THIS
        output [9:0] LEDR; 
        output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
        wire [15:0] datapath_out, mdata, B, C, sximm5, sximm8;
        wire write, vsel, loada, loadb, asel, bsel, loadc, loads, loadpc, reset, msel;
        wire [2:0] readnum, writenum, nsel;
        wire [1:0] shift, ALUop, op;
        wire [7:0] readAddress, writeAddress;
          
        datapath datapathInstantiate( 
                .clk(~KEY[0]),
                //register module
                .readnum(readnum),
                .vsel(vsel),
                .loada(loada),
                .loadb(loadb),
                //computation + alu + shift modules
                .shift(shift),
                .asel(asel),
                .bsel(bsel),
                .ALUop(ALUop),
                .loadc(loadc),
                .loads(loads),
                // write module
                .writenum(writenum),
                .write(write),  
                .mdata(mdata),
                // outputs
                .status(LEDR[9:7]),
                .datapath_out(datapath_out)
                );
                     
        decoder decoderInstantiate(
                .instruction(mdata),
                .nsel(nsel),
                .opcode(opcode), 
                .readnum(Rn), 
                .writenum(writenum), 
                .ALUop(ALUop), 
                .op(op), 
                .shift(shift), 
                .sximm(sximm5), 
                .sximm8(sximm8)
                );
                     
        instructionReg instrRegInstantiate(
                .clk(~KEY[0]), 
                .mdata(mdata), 
                .loadir(loadir), 
                .instruction(instruction)
                );
                
        RAM #(16,8,"data.txt") RAMInstantiate(
                .clk(~KEY[0]), 
                .readAddress(readAddress), 
                .writeAddress(writeAddress), 
                .write(write), 
                .in(B),                 //B is what is being written in
                .out(mdata)             //output is both instructions as well as values in the addresses
                );
                
        counter counterInstantiate(
                .clk(clk), 
                .reset(reset), 
                .loadpc(loadpc), 
                .msel(msel), 
                .C(C)
                .address(readAddress) //output of counter is the read address
                );
        
        // assigned HEX display to datapath_out values
        HEXDisplay HEX0Instantiate(datapath_out[3:0], HEX0);   
        HEXDisplay HEX1Instantiate(datapath_out[7:4], HEX1);
        HEXDisplay HEX2Instantiate(datapath_out[11:8], HEX2);
        HEXDisplay HEX3Instantiate(datapath_out[15:12], HEX3);
          
        assign HEX4 = 7'b1111111;  // disabled
        assign HEX5 = 7'b1111111;  // disabled
endmodule

// DE1-SOC Interface Specification

// KEY0= rising lock edge (When pressed) 
// LEDR9= status register output
// HEX3, HEX2, HEX1, HEX0= wired to datapath_out for LED display

// control signal(s)  switch(es)
// ~~~~~~~~~~~~~~~~~  ~~~~~~~~~       
// Register Stage
//           readnum  SW[3:1]
//             loada  SW[5]
//             loadb  SW[6]
// Computation Stage
//             shift  SW[2:1]
//              asel  SW[3]
//              bsel  SW[4]
//             ALUop  SW[6:5]
//             loadc  SW[7]
//             loads  SW[8]
// Write Stage
//             write  SW[0]      
//          writenum  SW[3:1]
//              vsel  SW[4]

module top(KEY, SW, CLOCK_50, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

        input [3:0] KEY;
        input [9:0] SW;
        input CLOCK_50;
        output [9:0] LEDR; 
        output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
        wire [15:0] datapath_out, datapath_in;
        wire write, vsel, loada, loadb, asel, bsel, loadc, loads;
        wire [2:0] readnum, writenum;
        wire [1:0] shift, ALUop;
        
          
        datapath datapathInstatiate( 
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
                        .datapath_in(datapath_in),
        
                        // outputs
                        .status(LEDR[9]),
                        .datapath_out(datapath_out)
                     );
        
        
        // assigned HEX display to datapath_out values
        HEXDisplay HEX0Instantiate(datapath_out[3:0], HEX0);   
        HEXDisplay HEX1Instantiate(datapath_out[7:4], HEX1);
        HEXDisplay HEX2Instantiate(datapath_out[11:8], HEX2);
        HEXDisplay HEX3Instantiate(datapath_out[15:12], HEX3);
          
        assign HEX4 = 7'b1111111;  // disabled
        assign HEX5 = 7'b1111111;  // disabled
endmodule

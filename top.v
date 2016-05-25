
// DE1-SOC Interface Specification

// KEY0= rising lock edge (When pressed) 
// LEDR9= status register output
// HEX3, HEX2, HEX1, HEX0= wired to datapath_out for LED dispaly
//
// When SW[9] is set to 1, SW[7:0] changes the lower 8 bits of datpath_in.
// (The upper 8-bits are hardwired to zero.) The LEDR[8:0] will show the
// current control inputs (LED "on" means input has logic value of 1).
//
// When SW[9] is set to 0, SW[8:0] changes the control inputs to the datapath
// as listed in the table below.  Note that the datapath has three main
// stages: register read, execute and writeback.  On any given clock cycle,
// you should only need to configure one of these stages so some switches are
// reused.  LEDR[7:0] will show the lower 8-bits of datapath_in (LED "on"
// means corresponding input has logic value of 1).
//
// control signal(s)  switch(es)
// ~~~~~~~~~~~~~~~~~  ~~~~~~~~~       
// <<register read stage>>
//           readnum  SW[3:1]
//             loada  SW[5]
//             loadb  SW[6]
// <<execute stage>>
//             shift  SW[2:1]
//              asel  SW[3]
//              bsel  SW[4]
//             ALUop  SW[6:5]
//             loadc  SW[7]
//             loads  SW[8]
// <<writeback stage>>
//             write  SW[0]      
//          writenum  SW[3:1]
//              vsel  SW[4]

module top(KEY, SW, CLOCK_50, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

        input [3:0] KEY;
        input [9:0] SW;
        input CLOCK_50;
        output [9:0] LEDR; 
        output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
        input CLOCK_50;
        wire [15:0] datapath_out, datapath_in;
        wire write, vsel, loada, loadb, asel, bsel, loadc, loads;
        wire [2:0] readnum, writenum;
        wire [1:0] shift, ALUop;
        
          input_iface inputInstantiate(CLOCK_50, SW, datapath_in, write, vsel, loada, loadb, asel, 
                         bsel, loadc, loads, readnum, writenum, shift, ALUop, LEDR[8:0]);
        
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
        
          // fill in sseg to display 4-bits in hexidecimal 0,1,2...9,A,B,C,D,E,F
          sseg H0(datapath_out[3:0],   HEX0);   
          sseg H1(datapath_out[7:4],   HEX1);
          sseg H2(datapath_out[11:8],  HEX2);
          sseg H3(datapath_out[15:12], HEX3);
          assign HEX4 = 7'b1111111;  // disabled
          assign HEX5 = 7'b1111111;  // disabled
        endmodule
        
        module input_iface(clk, SW, datapath_in, write, vsel, loada, loadb, asel, bsel, 
                           loadc, loads, readnum, writenum, shift, ALUop, LEDR);
          input clk;
          input [9:0] SW;
          output [15:0] datapath_in;
          output write, vsel, loada, loadb, asel, bsel, loadc, loads;
          output [2:0] readnum, writenum;
          output [1:0] shift, ALUop;
          output [8:0] LEDR;
        
          wire sel_sw = SW[9];  
        
          // When SW[9] is set to 1, SW[7:0] changes the lower 8 bits of datpath_in.
          wire [15:0] datapath_in_next = sel_sw ? {8'b0,SW[7:0]} : datapath_in;
          vDFF #(16) DATA(clk,datapath_in_next,datapath_in);
        
          // When SW[9] is set to 0, SW[8:0] changes the control inputs 
          //
          wire [8:0] ctrl_sw;
          wire [8:0] ctrl_sw_next = sel_sw ? ctrl_sw : SW[8:0];
          vDFF #(9) CTRL(clk,ctrl_sw_next,ctrl_sw);
        
          assign {readnum,vsel,loada,loadb,shift,asel,bsel,ALUop,loadc,loads,writenum,write}={
            // register operand fetch stage
            //     readnum       vsel        loada       loadb
                   ctrl_sw[3:1], ctrl_sw[4], ctrl_sw[5], ctrl_sw[6], 
            // computation stage (sometimes called "execute")
            //     shift         asel        bse         ALUop         loadc       loads
                   ctrl_sw[2:1], ctrl_sw[3], ctrl_sw[4], ctrl_sw[6:5], ctrl_sw[7], ctrl_sw[8],  
            // set when "writing back" to register file
            //   writenum        write
                   ctrl_sw[3:1], ctrl_sw[0]    
          };
        
          // LEDR[7:0] shows other bits
          assign LEDR = sel_sw ? ctrl_sw : {1'b0, datapath_in[7:0]};  
        endmodule         
        
        // The sseg module below can be used to display the value of datpath_out on
        // the hex LEDS the input is a 4-bit value representing numbers between 0 and
        // 15 the output is a 7-bit value that will print a hexadecimal digit.  You
        // may want to look at the code in Figure 7.20 and 7.21 in Dally but note this
        // code will not work with the DE1-SoC because the order of segments used in
        // the book is not the same as on the DE1-SoC (see comments below).
        
        module sseg(in,segs);
          input [3:0] in;
          output [6:0] segs;
        
          
          // One bit per segment. On the DE1-SoC a HEX segment is illuminated when
          // the input bit is 0. Bits 6543210 correspond to:
          //
          //    0000
          //   5    1
          //   5    1
          //    6666
          //   4    2
          //   4    2
          //    3333
          //
          // Decimal value | Hexadecimal symbol to render on (one) HEX display
          //             0 | 0
          //             1 | 1
          //             2 | 2
          //             3 | 3
          //             4 | 4
          //             5 | 5
          //             6 | 6
          //             7 | 7
          //             8 | 8
          //             9 | 9
          //            10 | A
          //            11 | b
          //            12 | C
          //            13 | d
          //            14 | E
          //            15 | F
        
          assign segs = 7'b0001110;  // this will output "F" 

endmodule

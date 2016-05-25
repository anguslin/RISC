
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
        
          // assigned HEX display to datapath_out values
          HEXDisplay HEX0(datapath_out[3:0], HEX0);   
          HEXDisplay HEX1(datapath_out[7:4], HEX1);
          HEXDisplay HEX2(datapath_out[11:8], HEX2);
          HEXDisplay HEX3(datapath_out[15:12], HEX3);
          
          assign HEX4 = 7'b1111111;  // disabled
          assign HEX5 = 7'b1111111;  // disabled
endmodule
        
//Two possibilities depending on value of SW[9]
module input_iface(clk, SW, datapath_in, write, vsel, loada, loadb, asel, bsel, loadc, loads, readnum, writenum, shift, ALUop, LEDR);

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
          wire [8:0] ctrl_sw;
          wire [8:0] ctrl_sw_next = sel_sw ? ctrl_sw : SW[8:0];
          vDFF #(9) CTRL(clk,ctrl_sw_next,ctrl_sw);
        
          assign {readnum,vsel,loada,loadb,shift,asel,bsel,ALUop,loadc,loads,writenum,write}={
                 //readnum       vsel        loada       loadb       shift         asel        bse         ALUop         loadc       loads       writenum      write
                   ctrl_sw[3:1], ctrl_sw[4], ctrl_sw[5], ctrl_sw[6], ctrl_sw[2:1], ctrl_sw[3], ctrl_sw[4], ctrl_sw[6:5], ctrl_sw[7], ctrl_sw[8], ctrl_sw[3:1], ctrl_sw[0]};
          // LEDR[7:0] shows other bits
          assign LEDR = sel_sw ? ctrl_sw : {1'b0, datapath_in[7:0]};  
endmodule         
        
//module to display the value of datpath_out DE1-SoC

 // One bit per segment on the DE1-SoC a HEX segment is illuminated depending on the input from datapath_out
          //The HEX display bits are as follows:
          
          //    0000
          //   5    1
          //   5    1
          //    6666
          //   4    2
          //   4    2
          //    3333
          
module HEXDisplay(inValue, display);
        input [3:0] inValue;
        output [6:0] display;
        always @(*) begin
                case(inValue)
                        4'b0000: display = 7'b1000000 //0
                        4'b0001: display = 7'b1111001 //1
                        4'b0010: display = 7'b0100100 //2
                        4'b0011: display = 7'b0110000 //3
                        4'b0100: display = 7'b0011001 //4
                        4'b0101: display = 7'b0010010 //5
                        4'b0110: display = 7'b0000010 //6
                        4'b0111: display = 7'b1111000 //7
                        4'b1000: display = 7'b0000000 //8
                        4'b1001: display = 7'b0011000 //9
                        4'b1010: display = 7'b0001000 //10 = A
                        4'b1011: display = 7'b0000011 //11 = b
                        4'b1100: display = 7'b1000110 //12 = C
                        4'b1101: display = 7'b0100001 //13 = d
                        4'b1110: display = 7'b0000110 //14 = E
                        4'b1111: display = 7'b0001110 //15 = F
                endcase
        end
endmodule

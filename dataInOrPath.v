//Two possibilities depending on value of SW[9]

module dataInOrPath(clk, SW, datapath_in, write, vsel, loada, loadb, asel, bsel, loadc, loads, readnum, writenum, shift, ALUop, LEDR);

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
        DFlipFlop #(9) CTRL(clk,ctrl_sw_next,ctrl_sw);
        
        assign {readnum,vsel,loada,loadb,shift,asel,bsel,ALUop,loadc,loads,writenum,write}={
                 //readnum       vsel        loada       loadb       shift         asel        bse         ALUop         loadc       loads       writenum      write
                   ctrl_sw[3:1], ctrl_sw[4], ctrl_sw[5], ctrl_sw[6], ctrl_sw[2:1], ctrl_sw[3], ctrl_sw[4], ctrl_sw[6:5], ctrl_sw[7], ctrl_sw[8], ctrl_sw[3:1], ctrl_sw[0]};
        // LEDR[7:0] shows other bits
        assign LEDR = sel_sw ? ctrl_sw : {1'b0, datapath_in[7:0]};  
endmodule  

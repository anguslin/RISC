module Write( datapath_in, vsel, writenum, datapath_out);
  
  input [15:0] datapath_in;
  input vsel;
  input [2:0] writenum;
  output [15:0] datapath_out;
  reg [15:0] data_in;
  
  //Operations for Writing Back values and Registering inputs
  
  always @(*) begin
    casex(vsel, write, writenum)
  	  5’b1xxxx: data_in = datapath_in;   	//if vsel is 1 put input new values from datapath_in to data_in
  		5’b0xxxx: data_in = datapath_out;	  //if vsel is 0 put write back values to data_in
  		5’bx1000: reg0 = data_in; 	  		  //if write is 1 and writenum is 000 put value in data_in and put in reg0
  		5’bx1001: reg1 = data_in;  		    	//if write is 1 and writenum is 001 put value in data_in and put in reg0
  		5’bx1010: reg2 = data_in;   			  //if write is 1 and writenum is 010 put value in data_in and put in reg0
  		5’bx1011: reg3 = data_in; 	  	  	//if write is 1 and writenum is 011 put value in data_in and put in reg0
  		5’bx1100: reg4 = data_in; 		    	//if write is 1 and writenum is 100 put value in data_in and put in reg0
  		5’bx1101: reg5 = data_in;		       	//if write is 1 and writenum is 101 put value in data_in and put in reg0
  		5’bx1110: reg6 = data_in; 		    	//if write is 1 and writenum is 110 put value in data_in and put in reg0		
  		5’bx1111: reg7 = data_in; 		    	//if write is 1 and writenum is 111 put value in data_in and put in reg0
  	endcase
  end
  
  output [15:0] datapath_out;
  assign datapath_out = C; 	  	//put value of C into datapath_out
endmodule

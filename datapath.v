module datapath (clk, hi, lo, fmapAddrSel, jSel, iSel, eclassSel, fmapDataSel, loadtmp, loadec_tmp, loadi, loadj, notReturn, cont1, cont2, cont3);
        input [31:0] hi, lo;           		     //input of function
        input [3:0] fmapAddrSel, jSel; 		     //4 bit mux selecter;
        input [2:0] iSel;              		     //3 bit mux selecter;
        input [1:0] eclassSel, fmapDataSel;          //2 bit mux selecter;
        input clk, loadi, loadj, loadtmp, loadec_tmp;
        output notReturn, cont1, cont2, cont3;
        wire [31:0] i, j, tmp, ec_tmp, fmapOut, eclassOut;
      
        memory memoryInstant(
                .i(i), 
                .j(j), 
                .tmp(tmp), 
                .fmapAddrSel(fmapAddrSel), 
                .eclassSel(eclassSel), 
                .fmapDataSel(fmapDataSel), 
                .eclassMemWrite(eclassMemWrite), 
                .fmapMemWrite(fmapMemWrite), 
                .clk(clk), 
                .fmapOut(fmapOut), 
                .eclassOut(eclassOut)
                );
                
        register registerInstant(
                .hi(hi), 
                .lo(lo), 
                .iSel(iSel), 
                .eclassSel(eclassSel), 
                .clk(clk), 
                .iLoad(iLoad), 
                .jLoad(jLoad), 
                .tmpLoad(tmpLoad), 
                .ec_tempLoad(ec_tmpLoad), 
                .i(i), 
                .j(j), 
                .tmp(tmp),
                .ec_tmp(ec_tmp)
                );
                
        verify verifyInstant(
                .hi(hi), 
                .lo(lo),
                .i(i), 
                .j(j), 
                .eclassOut(eclassOut), 
                .ec_tmp(ec_tmp), 
                .notReturn(notReturn), 
                .cont1(cont1), 
                .cont2(cont2), 
                .cont3(cont3)
                );
endmodule

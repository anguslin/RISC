// DE1-SOC Interface Specification

// KEY0= rising lock edge (When pressed)
// KEY1= Reset button
// LEDR[9:7]= status register output
// HEX3, HEX2, HEX1, HEX0= wired for LED display

module top(KEY, CLOCK_50, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

        input [3:0] KEY;
        input CLOCK_50;
        output [9:0] LEDR;
        output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
        wire [15:0]  mdata, B, C, sximm5, sximm8, instruction;
        wire write, loada, loadb, asel, bsel, loadc, loads, loadpc, msel, mwrite;
        wire [2:0] readnum, writenum, opcode;
        wire [1:0] shift, ALUop, op, vsel, nsel;
        wire [7:0] address;

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
        .sximm5(sximm5),
        .sximm8(sximm8),
                // outputs
                .status(LEDR[9:7]),
        .B(B),
        .C(C)
                );

        decoder decoderInstantiate(
                .instruction(instruction),
                .nsel(nsel),
                .opcode(opcode),
                .readnum(readnum),
                .writenum(writenum),
                .ALUop(ALUop),
                .op(op),
                .shift(shift),
                .sximm5(sximm5),
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
                .readAddress(address),
                .writeAddress(address),
                .mwrite(mwrite),
                .in(B),                 //B is what is being written in
                .out(mdata)             //output is both instructions as well as values in the addresses
                );

        counter counterInstantiate(
                .clk(~KEY[0]),
                .reset(~KEY[1]),
                .loadpc(loadpc),
                .msel(msel),
                .C(C),
                .address(address) //output of counter is the read address
                );

        controller controllerInstantiate(
        .clk(~KEY[0]),
        .ALUop(ALUop),
        .op(op),
        .shift(shift),
        .opcode(opcode),
        .readnum(readnum),
        .writenum(writenum),
        .loada(loada),
        .loadb(loadb),
        .write(write),
        .asel(asel),
        .bsel(bsel),
        .loadc(loadc),
        .loads(loads),
        .reset(~KEY[1]),
        .loadpc(loadpc),
        .msel(msel),
        .mwrite(mwrite),
        .loadir(loadir),
        .nsel(nsel),
        .vsel(vsel)
        );

        // assigned HEX display to datapath_out values

     //   HEXDisplay HEX0Instantiate(datapath_out[3:0], HEX0);
     //   HEXDisplay HEX1Instantiate(datapath_out[7:4], HEX1);
     //   HEXDisplay HEX2Instantiate(datapath_out[11:8], HEX2);
     //   HEXDisplay HEX3Instantiate(datapath_out[15:12], HEX3);

     //   assign HEX4 = 7'b1111111;  // disabled
      //  assign HEX5 = 7'b1111111;  // disabled
endmodule

module status(ALUComputedValue, status, overflow);

        parameter width = 1;

    input [width-1:0] ALUComputedValue;
    output [2:0] status;
        output overflow;
        reg zeroVal;

        //Values status if all 0s
            always @(*) begin
                case(ALUComputedValue)
                    16'b0000000000000000: zeroVal= 1;   //if all 0 then status value to be updated will be 0
                    default: zeroVal= 0;            //if not all 0 then status value to be updated will be 1
                endcase
            end

        //status[2]= overflow flag
        //status[1]= negative flag
        //status[0]= zero flag
        assign status = {overflow, ALUComputedValue[width-1], zeroVal};

endmodule

//Shift operations
module shift(B, BShift, shift);

    parameter width= 1;
    input [15:0] B;
    input [1:0] shift;
    output [15:0] BShift;
    reg [15:0] BShift;

    always @(*) begin
        case(shift)
            2'b00: BShift= B;           //if operation= 00 output= B
            2'b01: BShift= {B[14:0], 1'b0};     //if operation= 01 output= B shifted left one and right bit= 0
            2'b10: BShift= {1'b0, B[15:1]};     //if operation= 10 output= B shifted right one and left bit= 0
            2'b11: BShift= {B[15], B[15:1]};    //if operation= 11 output= B shifted right one and left bit= b[15]
            default: BShift= {width{1'bx}}; //default all to x
        endcase
    end
endmodule
//register module to load values stored in registers
module register(clk, loada, loadb, write, readnum, reg0, reg1, reg2, reg3, reg4 ,reg5 ,reg6 ,reg7, A, B);

    parameter width= 1;
    input clk, loada, loadb, write;
    input [2:0] readnum;
    input [15:0] reg0, reg1, reg2, reg3, reg4 ,reg5 ,reg6 ,reg7;
    output [15:0] A, B;
    reg [15:0] data_out;

    always @(*) begin
        case(readnum)
            3'b000: data_out= write? data_out: reg0; //if write= 0 and readnum= 000 data_out = reg0
            3'b001: data_out= write? data_out: reg1; //if write= 0 and readnum= 001 data_out = reg1
            3'b010: data_out= write? data_out: reg2; //if write= 0 and readnum= 010 data_out = reg2
            3'b011: data_out= write? data_out: reg3; //if write= 0 and readnum= 011 data_out = reg3
            3'b100: data_out= write? data_out: reg4; //if write= 0 and readnum= 100 data_out = reg4
            3'b101: data_out= write? data_out: reg5; //if write= 0 and readnum= 101 data_out = reg5
            3'b110: data_out= write? data_out: reg6; //if write= 0 and readnum= 110 data_out = reg6
            3'b111: data_out= write? data_out: reg7; //if write= 0 and readnum= 111 data_out = reg7
            default: data_out= {width{1'bx}};    //set everything to x for default
        endcase
    end

    //Clock Updates for A and B depending on clock and loada and loadb
    DFlipFlopAllow #(width) loadaData(clk, loada, data_out, A);
    DFlipFlopAllow #(width) loadbData(clk, loadb, data_out, B);
endmodule
module operation (Ain, Bin, addSubVals, andVals, notBVal, sub, computedValue, overflow);

        parameter width= 1;
        input [width-1:0] Ain, Bin;
        input addSubVals, andVals, notBVal, sub;
        output [width-1:0] computedValue;
    reg [width-1:0] computedValue;
        output overflow;
        wire sign, lastNonSign;
    wire [width-1:0] holder;

    always @(*) begin
        case({addSubVals, sub, andVals, notBVal})
            4'b1000: computedValue = Ain + Bin; //Addition
            4'b1100: computedValue = Ain - Bin; //Subtraction
            4'b0010: computedValue = Ain & Bin;     //And Operation
            4'b0001: computedValue = ~Bin;      //Not Operation
            default: computedValue = {width{1'bx}};
        endcase
    end

        //Detect overflow
        assign overflow= addSubVals? sign ^ lastNonSign : 1'b0; //XOR gate; if not the same => overflow

    //Used to compute sign and and lastNonSign values to detect for overflow
        //Arithmetic on Non Sign Bits
        //if subtract, then convert to Two's Complement and then add
        assign {lastNonSign, holder[width-2:0]}= addSubVals? Ain[width-2:0] + (Bin[width-2:0] ^ {width-1{sub}}) + sub: {lastNonSign, holder[width-2:0]};
        //Arithmetic on Sign Bits
        assign {sign, holder[width-1]}= addSubVals? Ain[width-1] + (Bin[width-1] ^ sub) + lastNonSign: {sign, computedValue[width-1]};

endmodule
module instructionReg(clk, mdata, loadir, instruction);

        input clk, loadir;
        input [15:0] mdata;
        output [15:0] instruction;

        //Update instruction on a clock depending on (loadir)
        DFlipFlopAllow #(16) updateInstruction(clk, loadir, mdata, instruction);

endmodule
//decoder module
module decoder(instruction, nsel, opcode, readnum, writenum, ALUop, op, shift, sximm5, sximm8);
        //inputs and outputs
        input[15:0] instruction;
        input [1:0] nsel;
        output [2:0] opcode, readnum, writenum;
        output [1:0] ALUop, op, shift;
        output [15:0] sximm5, sximm8;
        reg [2:0] tempReg;
    wire [2:0] Rd, Rn, Rm;

        //assignments based off of instruction
        assign opcode = instruction[15:13];
        assign op = instruction[12:11];
        assign ALUop = instruction[12:11];
        assign sximm5 = instruction[4]? {10'b1111111111,instruction[4:0]} : {10'b0000000000, instruction[4:0]};
    assign sximm8 = instruction[7]? {7'b1111111,instruction[7:0]} : {7'b0000000, instruction[7:0]};
        assign shift = instruction[4:3];
        assign Rn = instruction[10:8];
        assign Rd = instruction[7:5];
        assign Rm = instruction[2:0];

        always@(*) begin
            case(nsel)
                2'b00: tempReg = Rn; //nsel 00 = Rn
                2'b01: tempReg = Rd; //nsel 01 = Rd
                2'b10: tempReg = Rm; //nsel 10 = Rm
                default: tempReg = 3'bxxx;
            endcase
        end

        assign readnum = tempReg;
        assign writenum = tempReg;

endmodule

//Datapath module of the RISC
module datapath(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, writenum, write, mdata, sximm5, sximm8, status, B, C);

//constants to define
`define WIDTH 16
`define STATUSWIDTH 3

input clk, loada, loadb, write, asel, bsel, loadc, loads;
input [2:0] readnum, writenum;
input [1:0] shift, ALUop, vsel;
input [15:0] mdata, sximm5, sximm8;
output [2:0] status;
output [15:0] B, C;

wire [15:0] A, reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7;

wire [7:0] PC; //no function currently

    //Instantiation of register module
register #(
        .width(`WIDTH)
        ) instantiateReg(
        .clk(clk),
        .loada(loada),
        .loadb(loadb),
        .write(write),
        .readnum(readnum),
        .reg0(reg0),
        .reg1(reg1),
        .reg2(reg2),
        .reg3(reg3),
        .reg4(reg4),
        .reg5(reg5),
        .reg6(reg6),
        .reg7(reg7),
        .A(A),
        .B(B)
     );

    //Instatiation of computation module
    computation #(
        .width(`WIDTH),
        .statusWidth(`STATUSWIDTH)
        ) instantiateComp(
        .clk(clk),
        .asel(asel),
        .bsel(bsel),
        .loadc(loadc),
        .loads(loads),
        .shift(shift),
        .ALUop(ALUop),
        .A(A),
        .B(B),
        .sximm5(sximm5),
        .status(status),
        .C(C)
    );

    //Instantiation of write module
    write #(
        .width(`WIDTH)
        ) instantiateWrite(
        .clk(clk),
        .vsel(vsel),
        .write(write),
        .writenum(writenum),
        .C(C),
        .mdata(mdata),
        .sximm8(sximm8),
        .PC(PC),
        .reg0(reg0),
        .reg1(reg1),
        .reg2(reg2),
        .reg3(reg3),
        .reg4(reg4),
        .reg5(reg5),
        .reg6(reg6),
        .reg7(reg7)
    );
    endmodule

  //module for program counter
module counter(clk, reset, loadpc, msel, C, address);

        input clk, reset, loadpc, msel;
        input [15:0] C;
        output [7:0] address;
        wire [7:0] loadValue, addressOut, addressToBeUpdated;

        //assign values
        assign loadValue = loadpc? addressOut + 1'b1 : addressOut;
        assign addressToBeUpdated= reset? 8'b00000000 : loadValue;

        //update on rising clock
        DFlipFlop #(8) loadCountOut(clk, addressToBeUpdated, addressOut);

        //address value to be input into RAM
        assign address = msel? C[7:0] : addressOut;

endmodule

module controller(clk, ALUop, op, shift, opcode, readnum, writenum, loada, loadb, write, asel, bsel, loadc, loads, reset, loadpc, msel, mwrite, loadir, nsel, vsel );
    input clk, reset;
        input [1:0] ALUop, op, shift;
        input [2:0] opcode, readnum, writenum;
        output loada, loadb, write, asel, bsel, loadc, loads, loadpc, msel, mwrite, loadir;
        output [1:0] nsel, vsel;

    wire [4:0] currentState, nextState;
    wire [2:0] opcode;
    wire [1:0] operation;

    reg [4:0] nextStateToBeUpdated;
    reg [14:0] inputData;

    //PC States
    //Initial State
    `define initiatePC 5'b00000

    //loading intructions
    `define loadPC 5'b00001
    `define loadRAM 5'b00010
    `define loadIR 5'b00011

    //General
    `define instrFirst 5'b00100
    `define instrLast 5'b00101

    //Instruction 2
    `define putInB 5'b00110
    `define aluMovOpAndPutInC 5'b00111

    //ALU States
    //Instruction 3
    `define readRn 5'b01000
    `define putInA 5'b01001
    `define aluAddOpAndPutInC 5'b01010

    //Instruction 5
    `define aluAndOpAndPutInC 5'b01011

    //Instruction 6
    `define aluNotMovOpAndPutInC 5'b01100

    //MEM States
    //Instruction 7
    `define aluMemLoadOpAndPutInC 5'b01101
    `define loadReadAddress 5'b01110

    //Instruction 8
    `define aluMemStoreOpAndPutInC 5'b01111
    `define readRd 5'b10000

    //Operation Code
    `define MOV 3'b110
    `define ALU 3'b101
    `define STR 3'b100
    `define LDR 3'b011
    `define opCodeNone 3'bxxx

    //Operations
    `define ADD 2'b00
    `define CMP 2'b01
    `define AND 2'b10
    `define MVN 2'b11
    `define operationNone 2'bxx

    //Register choosing
    `define RN 2'b00
    `define RD 2'b01
    `define RM 2'b10

    //vsel to choose with data to let in for the registers
    `define MDATA 2'b00
    `define SXIMM8 2'b01
    `define ZEROANDPC 2'b10
    `define C 2'b11

    //State Updates
    //If reset, set program counter to 1
    assign nextState= reset? `initiatePC: nextStateToBeUpdated;
    //Update states based on clock
    DFlipFlop #(5) StateUpdate(clk, nextState, currentState);

    //All outputs needed for module instantiations
    assign nsel= inputData[14:13];
    assign vsel= inputData[12:11];
    assign loada= inputData[10];
    assign loadb= inputData[9];
    assign write= inputData[8];
    assign asel= inputData[7];
    assign bsel= inputData[6];
    assign loads= inputData[5];
    assign loadc= inputData[4];
    assign loadpc= inputData[3];
    assign msel= inputData[2];
    assign mwrite= inputData[1];
    assign loadir= inputData[0];


    //Specifications for what to do in each state
    //Each state is separated by a rising clock update
    //At start of each instruction, only loadir= 1, everything else is set to 0 from the instruction states
    always @(*) begin
        casex({currentState, opcode, op})
            //Set everything to zero for initial or reset state
            {`initiatePC, `opCodeNone, `operationNone}: inputData= 15'b000000000000000;
            //----------

            //INSTRUCTION COUNTER + RAM //Loading Instruction and Counter
            //Load counter value
            //loadPC= 1, else= 0 -> Clk //put all load values back into 0 when finished executing a command
            {`loadPC, `opCodeNone, `operationNone}: inputData= 15'b000000000001000;

            //load value into RAM
            //loadPC= 0, else= before -> Clk
            {`loadRAM, `opCodeNone, `operationNone}: inputData= {inputData[14:4], 1'b0, inputData[2:0]};

            //load instruction
            //loadir= 1, else= before -> Clk
            {`loadIR, `opCodeNone, `operationNone}: inputData= {inputData[14:1], 1'b1};
            //----------

            //INSTRUCTION 1 //Write value of sximm8 into Rn register
            //nsel= Rn Vsel= SXIMM8 write= 1 loadir= 0  -> Clk
            {`instrFirst, `MOV, `AND}: inputData= {`RN, `SXIMM8, inputData[10:9], 1'b1, inputData[7:1], 1'b0};
            //----------

            //INSTRUCTION 2 //Write shifted value of Rm register into Rd register
            //read value from RM register
            //nsel= RM loadir= 0 (write already 0), else= before -> Clk
            {`instrFirst, `MOV, `ADD}: inputData= {`RM, inputData[12:1], 1'b0};

            //put specified reading value in B
            //loadb= 1, else= before -> Clk
            {`putInB, `MOV, `ADD}: inputData= {inputData[14:10], 1'b1, inputData[8:0]};

            //Add A and Shifted B values and put into register C -> Clk
            //bsel= 0 asel= 1 loadc= 1 loadb= 0, else= before -> Clk
            {`aluMovOpAndPutInC, `MOV, `ADD}: inputData= {inputData[14:10], 1'b0, inputData[8], 2'b10, inputData[5], 1'b1, inputData[3:0]};

            //Put value of C into Rd register
            //nsel= `RD vsel= `C write= 1 loadc= 0, else= before -> Clk
            {`instrLast, `MOV, `ADD}: inputData= {`RD, `C, inputData[10:9], 1'b1, inputData[7:5], 1'b0, inputData[3:0]};
            //----------

            //INSTRUCTION 3 //Add values of Rn and shifted Rm and put it in Rd
            //read value from RM register
            //nsel= RM loadir= 0 (write already 0), else= before -> Clk
            {`instrFirst, `ALU, `ADD}: inputData= {`RM, inputData[12:1], 1'b0};

            //put specified reading value in B
            //loadb= 1, else= before -> Clk
            {`putInB, `ALU, `ADD}: inputData= {inputData[14:10], 1'b1, inputData[8:0]};

            //read value from RN register
            //nsel= `Rn (write already 0) loadb= 0, else= begore -> Clk
            {`readRn, `ALU, `ADD}: inputData= {`RN, inputData[12:10], 1'b0, inputData[8:0]};

            //put specified reading value in A
            //loadb= 0, loada= 1, else= before -> Clk
            {`putInA, `ALU, `ADD}: inputData= {inputData[14:11], 2'b10, inputData[8:0]};

            //do addition computations and load in register C
            //asel= 0 bsel= 0 loadc= 1 loada= 0, else - before -> Clk
            {`aluAddOpAndPutInC, `ALU, `ADD}: inputData= {inputData[14:11], 1'b0, inputData[9:8], 2'b00, inputData[5], 1'b1, inputData[3:0]};

            //Put Value of C into Rd
            //nsel= `RD vsel= `C write= 1 loadc= 0, else= before -> Clk
            {`instrLast, `ALU, `ADD}: inputData= {`RD, `C, inputData[10:9], 1'b1, inputData[7:5], 1'b0, inputData[3:0]};
            //----------

            //INSTRUCTION 4 //Find the status output of Rn - Shifted Rm
            //read the value of Rm
            //nsel= RM loadir= 0 (write already 0), else= before -> Clk
            {`instrFirst, `ALU, `CMP}: inputData= {`RM, inputData[12:1], 1'b0};

            //put specified reading value in register B
            //loadb= 1 loada= 0, else= before -> Clk
            {`putInB, `ALU, `CMP}: inputData= {inputData[14:11], 2'b01, inputData[8:0]};

            //read value from RN register
            //nsel= `Rn (write already 0) loadb= 0, else= begore -> Clk
            {`readRn, `ALU, `CMP}: inputData= {`RN, inputData[12:10], 1'b0, inputData[8:0]};

            //put specified reading value in A
            //loadb= 0, loada= 1, else= before -> Clk
            {`putInA, `ALU, `CMP}: inputData= {inputData[14:11], 2'b10, inputData[8:0]};

            //do subtraction computations and load in status
            //asel= 0 bsel= 0 loada= 0 loads= 1, else - before -> Clk
            {`instrLast, `ALU, `CMP}: inputData= {inputData[14:11], 1'b0, inputData[9:8], 3'b001, inputData[5:0]};
            //----------

            //INSTRUCTION 5 //Compute Rn ANDed with Shifted Rm and put it in Rd
            //read value from RM register
            //nsel= RM loadir= 0 (write already 0), else= before -> Clk
            {`instrFirst, `ALU, `AND}: inputData= {`RM, inputData[12:1], 1'b0};

            //put specified reading value in register B
            //loadb= 1 loada= 0, else= before -> Clk
            {`putInB, `ALU, `AND}: inputData= {inputData[14:11], 2'b01, inputData[8:0]};

            //read value from RN register
            //nsel= `Rn (write already 0) loadb= 0, else= begore -> Clk
            {`readRn, `ALU, `AND}: inputData= {`RN, inputData[12:10], 1'b0, inputData[8:0]};

            //put specified reading value in A
            //loadb= 0, loada= 1, else= before -> Clk
            {`putInA, `ALU, `AND}: inputData= {inputData[14:11], 2'b10, inputData[8:0]};

            //AND values inside reg A and B and then load it into C
            //bsel= 0 asel= 0 loada= 0 loadc= 1, else= before -> Clk
            {`aluAndOpAndPutInC, `ALU, `AND}: inputData= {inputData[14:11], 1'b0, inputData[9:8], 2'b00, inputData[5], 1'b1, inputData[3:0]};

            //Put Value of C into Rd
            //nsel= `RD vsel= `C loadc= 0 write= 1, else= before -> Clk
            {`instrLast, `ALU, `AND}: inputData= {`RD, `C, inputData[10:9], 1'b1, inputData[7:5], 1'b0, inputData[3:0]};
            //----------

            //INSTRUCTION 6 //Write NOTed shifted value of Rm register into Rd register
            //read value from RM register
            //nsel= RM loadir= 0 (write already 0), else= before -> Clk
            {`instrFirst, `ALU, `MVN}: inputData= {`RM, inputData[12:1], 1'b0};

            //put specified reading value in B
            //loada= 0 loadb= 1, else= before -> Clk
            {`putInB, `ALU, `MVN}: inputData= {inputData[14:11], 2'b01, inputData[8:0]};

            //Add A and Shifted B values and put into register C -> Clk
            //bsel= 0 asel= 1 loadb= 0 loadc= 1, else= before -> Clk
            {`aluNotMovOpAndPutInC, `ALU, `MVN}: inputData= {inputData[14:10], 1'b0, inputData[8], 2'b10, inputData[5], 1'b1, inputData[3:0]};

            //Put value of C into Rd register
            //nsel= `RD vsel= `C loadc= 0 write= 1, else= before -> Clk
            {`instrLast, `ALU, `MVN}: inputData= {`RD, `C, inputData[10:9], 1'b1, inputData[7:5], 1'b0, inputData[3:0]};
            //----------

            //INSTRUCTION 7 //load memory from address specified by Rn + imm5 nad put it into RD
            //read value from RN register
            //nsel= `Rn (write already 0) loadir= 0, else= begore -> Clk
            {`instrFirst, `LDR, `ADD}: inputData= {`RN, inputData[12:1], 1'b0};

            //put specified reading value in A
            //loadb= 0, loada= 1, else= before -> Clk
            {`putInA, `LDR, `ADD}: inputData= {inputData[14:11], 2'b10, inputData[8:0]};

            //load computed effective address into C
            //bsel= 1 asel= 0 loada= 0 loadc= 1, else= before -> Clk
            {`aluMemLoadOpAndPutInC, `LDR, `ADD}: inputData= {inputData[14:11], 1'b0, inputData[9:8], 2'b01, inputData[5], 1'b1, inputData[3:0]};

            //load address into Ram and put mdata from RAM output into register RD
            //msel= 1 mwrite= 0 loadc = 0, else= before -> Clk
            {`loadReadAddress, `LDR, `ADD}: inputData= {inputData[14:5], 1'b0, inputData[3], 2'b10, inputData[0]};

            //Put mdata into register Rd
            //nsel= `RD, vsel= `MDATA, write=1, else = before -> Clk
            {`instrLast, `LDR, `ADD}: inputData= {`RD, `MDATA, inputData[10:9], 1'b1, inputData[7:0]};
            //----------

            //INSTRUCTION 8 //store value of register Rd into memory at address= sximm5+Rn
            //read value from RN register
            //nsel= `Rn (write already 0) loadir= 0, else= before -> Clk
            {`instrFirst, `STR, `ADD}: inputData= {`RN, inputData[12:1], 1'b0};

            //put specified reading value in A
            //loadb= 0, loada= 1, else= before -> Clk
            {`putInA, `STR, `ADD}: inputData= {inputData[14:11], 2'b10, inputData[8:0]};

            //load computed effective address into C
            //bsel= 1 asel= 0 loada=0 loadc= 1, else= before -> Clk
            {`aluMemStoreOpAndPutInC, `STR, `ADD}: inputData= {inputData[14:11], 1'b0, inputData[9:8], 2'b01, inputData[5], 1'b1, inputData[3:0]};

            //read value from RD register
            //nsel= `RD loadc=0, else= before -> Clk
            {`readRd, `STR, `ADD}: inputData= {`RD, inputData[12:5], 1'b0, inputData[3:0]};

            //put specified reading value in B
            //loada= 0 loadb= 1, else= before -> Clk
            {`putInB, `STR, `ADD}: inputData= {inputData[14:11], 2'b01, inputData[8:0]};

            //update value in B with address from C into RAM
            //mwrite= 1 msel= 1 loadb = 0, else= before -> Clk
            {`instrLast, `STR, `ADD}: inputData= {inputData[14:10], 1'b0, inputData[8:3], 2'b11, inputData[0]};
        endcase
    end

    always @(*) begin
        casex({currentState, opcode, op})
            //Counters and first and last parts of instructions
            //Set counter to zero for initial or reset state
            {`initiatePC, `opCodeNone, `operationNone}: nextStateToBeUpdated= `loadRAM;

            //Loading Instruction and Counter
            {`loadPC, `opCodeNone, `operationNone}: nextStateToBeUpdated= `loadRAM;
            {`loadRAM, `opCodeNone, `operationNone}: nextStateToBeUpdated= `loadIR;

            //When instruction loaded, move into first part of instruction
            {`loadIR, `opCodeNone, `operationNone}: nextStateToBeUpdated= `instrFirst;

            //When last part of instruction executed, counter+1 to load next instruction
            {`instrLast, `opCodeNone, `operationNone}: nextStateToBeUpdated= `loadPC;
            //----------

            //INSTRUCTION 1
            {`instrFirst, `MOV, `AND}: nextStateToBeUpdated= `loadPC;
            //----------

            //INSTRUCTION 2
            {`instrFirst, `MOV, `ADD}: nextStateToBeUpdated= `putInB;
            {`putInB, `MOV, `ADD}: nextStateToBeUpdated= `aluMovOpAndPutInC;
            {`aluMovOpAndPutInC, `MOV, `ADD}: nextStateToBeUpdated= `instrLast;
            //----------

            //INSTRUCTION 3
            {`instrFirst, `ALU, `ADD}:  nextStateToBeUpdated= `putInB;
            {`putInB, `ALU, `ADD}: nextStateToBeUpdated= `readRn;
            {`readRn, `ALU, `ADD}: nextStateToBeUpdated= `putInA;
            {`putInA, `ALU, `ADD}: nextStateToBeUpdated= `aluAddOpAndPutInC;
            {`aluAddOpAndPutInC, `ALU, `ADD}: nextStateToBeUpdated= `instrLast;
            //----------

            //INSTRUCTION 4 //Find the status output of Rn - Shifted Rm
            {`instrFirst, `ALU, `CMP}: nextStateToBeUpdated= `putInB;
            {`putInB, `ALU, `CMP}: nextStateToBeUpdated= `readRn;
            {`readRn, `ALU, `CMP}: nextStateToBeUpdated= `putInA;
            {`putInA, `ALU, `CMP}: nextStateToBeUpdated= `instrLast;
            //----------

            //INSTRUCTION 5 //Compute Rn ANDed with Shifted Rm and put it in Rd
            {`instrFirst, `ALU, `AND}: nextStateToBeUpdated= `putInB;
            {`putInB, `ALU, `AND}: nextStateToBeUpdated= `readRn;
            {`readRn, `ALU, `AND}: nextStateToBeUpdated= `putInA;
            {`putInA, `ALU, `AND}: nextStateToBeUpdated= `aluAndOpAndPutInC;
            {`aluAndOpAndPutInC, `ALU, `AND}: nextStateToBeUpdated= `instrLast;
            //----------

            //INSTRUCTION 6 //Write NOTed shifted value of Rm register into Rd register
            {`instrFirst, `ALU, `MVN}: nextStateToBeUpdated= `putInB;
            {`putInB, `ALU, `MVN}: nextStateToBeUpdated= `aluNotMovOpAndPutInC;
            {`aluNotMovOpAndPutInC, `ALU, `MVN}: nextStateToBeUpdated= `instrLast;
            //----------

            //INSTRUCTION 7 //load memory from address specified by Rn + imm5 nad put it into RD
            {`instrFirst, `LDR, `ADD}: nextStateToBeUpdated= `putInA;
            {`putInA, `LDR, `ADD}: nextStateToBeUpdated= `aluMemLoadOpAndPutInC;
            {`aluMemLoadOpAndPutInC, `LDR, `ADD}: nextStateToBeUpdated= `loadReadAddress;
            {`loadReadAddress, `LDR, `ADD}: nextStateToBeUpdated= `instrLast;
            //----------

            //INSTRUCTION 8 //store value of register Rd into memory at address= sximm5+Rn
            {`instrFirst, `STR, `ADD}: nextStateToBeUpdated= `putInA;
            {`putInA, `STR, `ADD}: nextStateToBeUpdated= `aluMemStoreOpAndPutInC;
            {`aluMemStoreOpAndPutInC, `STR, `ADD}: nextStateToBeUpdated= `readRd;
            {`readRd, `STR, `ADD}: nextStateToBeUpdated= `putInB;
            {`putInB, `STR, `ADD}: nextStateToBeUpdated= `instrLast;
        endcase
    end
endmodule




module computation(clk, asel, bsel, loadc, loads, shift, ALUop, A, B, sximm5, status, C);

    parameter width= 1;
    parameter statusWidth= 3;
    input clk, asel, bsel, loadc, loads;
    input [1:0] shift, ALUop;
    input [15:0] A, B, sximm5;
    output [2:0] status;
    output [15:0] C;
    wire [2:0] statusComputed;
    wire overflow;
    wire [15:0] Ain, Bin, BShift, ALUComputedValue;

    //if asel= 0 set Ain= A value else set Ain= 0s
    assign Ain= asel? {width{1'b0}}: A;

    //if bsel= 0 set Bin= to shifted B value else set Bin= to 11bits 0s + first 5 bits of datapath_in
    assign Bin= bsel? sximm5: BShift;

    //Clock updates for status and C
    DFlipFlopAllow #(statusWidth) loadStatusData(clk, loads, statusComputed, status);   //status= running on a clock
    DFlipFlopAllow #(width) loadCData(clk, loadc, ALUComputedValue, C);         //C= running on a clock

    //Shift Operations
    shift #(width) instantiateShift(
        .B(B),
        .BShift(BShift),
        .shift(shift)
    );

    //ALU Operations
    ALU #(width) instantiateALU(
        .ALUop(ALUop),
        .Ain(Ain),
        .Bin(Bin),
        .ALUComputedValue(ALUComputedValue),
        .overflow(overflow)
    );

    //status Update
    status #(width) instantiateStatus(
    .ALUComputedValue(ALUComputedValue),
    .status(statusComputed),
    .overflow(overflow)
    );

endmodule



       module RAM(clk, readAddress, writeAddress, mwrite, in, out);

        parameter dataWidth = 16;       //size of data in each address
        parameter addrWidth = 8;        //size of address
        parameter filename = "data.txt";

        input clk, mwrite;
        input [addrWidth-1:0] readAddress, writeAddress;
        input [dataWidth-1:0] in;
        output [dataWidth-1:0] out;
        reg [dataWidth-1:0] out;
        reg [dataWidth-1:0] mem[2**addrWidth-1:0];


        always @ (posedge clk) begin
                if (mwrite) begin
                        mem[writeAddress] <= in;
                end
                out <= mem[readAddress];
        end
endmodule

      //D Flip Flop with enabling property

module DFlipFlopAllow(clk, allow, in, out) ;
  parameter width = 1;  // width
  input clk, allow ;
  input [width-1:0] in ;
  output [width-1:0] out ;
  reg [width-1:0] out ;
  wire [width-1:0] toBeUpdated;

assign toBeUpdated = allow? in : out; //only update if allowed

  always @(posedge clk)
    out = toBeUpdated ;
endmodule

module DFlipFlop(clk,in,out);
  parameter n=1;
  input clk;
  input [n-1:0] in;
  output [n-1:0] out;
  reg [n-1:0] out;

  //update on rising edge
  always @(posedge clk)
    out = in;
endmodule

//ALU operations
module ALU(ALUop, Ain, Bin, ALUComputedValue, overflow);

    `define ADD 2'b00
    `define SUB 2'b01
    `define ANDVAL 2'b10
    `define NOTB 2'b11

    parameter width= 1;
    input [1:0] ALUop;
    input [15:0] Ain, Bin;
    output [15:0] ALUComputedValue;
    output overflow;
    reg addSubVals, andVals, notBVal, sub;

    always @(*) begin
        case(ALUop) //Set the operation needed to be true and the rest to be false
            `ADD: {addSubVals, andVals, notBVal, sub}= {4'b1000};
            `SUB: {addSubVals, andVals, notBVal, sub}= {4'b1001};
            `ANDVAL: {addSubVals, andVals, notBVal, sub}= {4'b0100};
            `NOTB: {addSubVals, andVals, notBVal, sub}= {4'b0010};
            default: {addSubVals, andVals, notBVal, sub}= {4'bxxxx};    //default all x
        endcase
    end

    //Instantiate operation module to compute the specified operation
    operation #(16) instantiateOperation(
        .Ain(Ain),
        .Bin(Bin),
        .overflow(overflow),
        .addSubVals(addSubVals),
        .andVals(andVals),
        .notBVal(notBVal),
        .sub(sub),
        .computedValue(ALUComputedValue)
        );
endmodule

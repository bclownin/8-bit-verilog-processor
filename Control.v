`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 08:59:45 PM
// Design Name: 
// Module Name: Control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Control(
    output [15:0] LED,
    output [7:0] D1_SEG,
    output [3:0] D1_AN,
    input [15:0] SW,
    input [3:0] BTN,
    input clk
    );
    wire clk25;
    // clock divider module I wrote
    sysClock sysClk (clk25, clk);

//    vivado clock wizard IP
//    reg reset = 0;
//    clk_wiz_0 inst_clk_wiz
//	(
//	.clk_out1(clk25),     // 25MHz output clock
//	.reset(reset), // input reset
//	.clk_in1(clk)		//input clk_in1
//	);      
    
    wire BTN_0;
    debouncer btn0 (BTN_0,BTN[0], clk25); 
    wire BTN_2;
    debouncer btn2 (BTN_2, BTN[2],clk25); //using clk25 (original used clk, worked great, lots of warnings)
    wire instrLoop = SW[3]; //option to halt processor when instructions run out or continuously loop (not implemented)

    //instruction_memory output
    wire [2:0] targetIn, AregIn, BregIn;
    wire [7:0] immed;
    wire [4:0] funct;
    wire [15:0] instr;
    
    //ALU outputs
    wire [7:0] ALUresult;
    wire zeroFlag;
    wire overflow;
    
    //ALU inputs
    reg [2:0] ALUop;
    wire [7:0] alui_opA, alui_opB;
    
    //reg file input
    reg regWrite;
    reg [2:0] targetReg,Areg,Breg;
    reg [7:0] writeData;
    
    //reg file output
    wire [7:0] o_Areg, o_Breg;
    
    //mem file inputs
    reg memWrite;
    reg [7:0] memDataIn;
    reg [7:0] addressIn;
    reg memReadWrite;

    // mem file outputs
    wire [7:0] memDataOut;
    
    //7Seg signals
    reg [3:0] ones = 4'd0;
    reg [3:0] tens = 4'd0;
    reg [3:0] hundreds = 4'd0;
    wire [15:0] BCD_result_extended;
    wire [11:0] BCD_result;
    reg [7:0] display_num = 8'd0;
    
    //control signals
    reg [7:0] PC = 8'd0;
    reg [7:0] PCnext = 8'd0;
    reg memDataSrc;
    reg branch = 0;
    
    //wire SWexe; 
    reg [7:0] jumpCount = 0;
    reg [7:0] jumpLimit = 8'b11111111; // to do: make a "0" jumpLimit do infinite loops
    reg IF_IDstall;
    reg jumpClear; 
    
    //MEM_WB output wires
    wire [4:0] funct_WBo;
    wire [7:0] ALUresult_WBo, memDataOut_WBo, immed_WBo;
    wire writeDataSrc_WBo, zeroFlag_WBo;
    
    //more variables for things and such
    wire [2:0] Areg_EXo, Breg_EXo, Areg_MEMo, Breg_MEMo, Areg_WBo, Breg_WBo;
    wire [2:0] targetReg_WBo;
    wire regWrite_WBo;
    
    //EX_MEM output wires
    wire [4:0] funct_MEMo;
    wire [7:0] immed_MEMo;
    wire [7:0] ALUresult_MEMo;
    wire [2:0] targetReg_MEMo;
    wire zeroFlag_MEMo, regWrite_MEMo;
    
    Instruction_Memory Instr (instr, PC);
    // IF_ID
    wire [15:0] instr_IDo;
    
    IF_ID fetch_decode (
        .instr_o (instr_IDo), 
        .funct (funct), 
        .target (targetIn), 
        .Areg (AregIn), 
        .Breg (BregIn), 
        .immed (immed), 
        .instr (instr), 
        .IF_IDstall (IF_IDstall), 
        .jumpClear (jumpClear), 
        .clk (clk25)
    );

    reg [7:0] branchTarget;
    reg jumpEnable = 0;
    wire jumpEnable_EXo;
    wire jumpEnable_MEMo;
    //reg [7:0] setJumpLimit = 0;
    reg [7:0] jumpCountNext = 0;
    
always @(posedge clk25) begin
    jumpCount <= jumpCountNext;
    if (branch) begin
        PC <= PCnext;
    end
    else if (PC == 8'd255) begin
        PC <= instrLoop ? 8'd0 : PC;
    end
    else if (!IF_IDstall) begin
        PC <= PCnext;
        end
    else begin
        PC <= PC;
    end
end

reg [7:0] PClink = 0;
    
always @ (*)begin
    regWrite = 0;
    memReadWrite = 0; 
    memDataSrc = 0;
    targetReg = 3'd0;
    Areg = 0;
    Breg = 0;
    jumpEnable = 0;
    PClink = PClink;
    addressIn = addressIn;
       case (funct[4:3])
	0: 	begin  //alu 
			ALUop = funct[2:0];
			targetReg = targetIn;
			Areg = AregIn;
			Breg = BregIn;
			regWrite = 1'd1;
		end
	1:  begin //li
		    regWrite = 1'd1;
            targetReg = targetIn;            
            ALUop = 3'b010;
		end
	2: begin
		  case (funct[2:0])
			0: begin //SW
				Areg = targetIn;
				memReadWrite = 1;
				addressIn = immed;
			    memDataSrc = 0;
			   end
			1: begin //LW
				targetReg = targetIn;
				addressIn = immed;
				regWrite = 1;
			   end
			2: begin //Link (store PC in dataMem[immed])
			     memReadWrite = 1; 
			     addressIn = immed;
			     memDataSrc = 1;
			     PClink = PC - 8'd1;
			   end  
			3: begin //JUMP (jumps to PC = dataMem[RT], limit = immed)
			     jumpEnable = (immed > jumpCount) ? 1 : 0;   
			     addressIn = targetIn; 
			   end
			4: begin //BEQ to PC @ dataMem[immed] 
			     Areg = AregIn;
			     Breg = BregIn;
			     ALUop = 3'b011;
			     addressIn = targetIn;
			   end
		    default: begin
			    regWrite = 0;
                memReadWrite = 0; 
			end
		  endcase
		end
		default: begin
		    regWrite = 0;
            memReadWrite = 0; 
            memDataSrc = 0;
            targetReg = 3'd0;
            Areg = 0;
            Breg = 0;
		end
    endcase
    end

    wire [7:0] memAddr_MEMo;
    wire memReadWrite_MEMo;
    wire [7:0] memDataIn_MEMo;
    wire [7:0] displayDataMem;
    reg [7:0] memDataIn_muxxed;
    
    always @ (*) begin
        if (regWrite_WBo && (targetReg_WBo != 0) && (targetReg_WBo == Areg_MEMo)) begin
            memDataIn_muxxed = writeData; 
        end
        else begin 
            memDataIn_muxxed = memDataIn_MEMo;
        end
    end

    dataMem m0 (
    displayDataMem, 
    memDataOut, 
    memDataIn_muxxed, 
    memAddr_MEMo, 
    memReadWrite_MEMo, 
    SW[15:8],
    clk25);
    
    wire [7:0] displayData;// displayData sent to 7seg
    
    Registers r0 (
    displayData, 
    o_Areg, 
    o_Breg, 
    Areg, 
    Breg, 
    targetReg_WBo, 
    regWrite_WBo, 
    writeData, 
    SW[2:0],
    clk25);
    //ID_EX output wires
    wire [4:0] funct_EXo;
    wire [7:0] memDataIn_EXo;
    wire [7:0] addressIn_EXo;
    wire [7:0] immed_EXo;
    wire [2:0] ALUop_EXo, targetReg_EXo;
    wire regWrite_EXo, memReadWrite_EXo, displayON_EXo;
    //ID_EX out on top, in on bottom
    ID_EX decode_execute (
        .funct_o (funct_EXo), 
        .opA (alui_opA), 
        .opB (alui_opB),
        .memWriteData (memDataIn_EXo), 
        .addressIn_o (addressIn_EXo), 
        .immed_o (immed_EXo), 
        .ALUop_o (ALUop_EXo), 
        .targetReg_o (targetReg_EXo), 
        .Areg_o (Areg_EXo), 
        .Breg_o (Breg_EXo), 
        .regWrite_o (regWrite_EXo), 
        .memReadWrite_o (memReadWrite_EXo), 
        .jumpEnable_o (jumpEnable_EXo),
        .dataA (o_Areg), 
        .dataB (o_Breg), 
        .PClink (PClink), 
        .addressIn (addressIn), 
        .immed (immed), 
        .Areg (Areg), 
        .Breg (Breg), 
        .regWrite (regWrite), 
        .memReadWrite (memReadWrite), 
        .ALUop (ALUop), 
        .targetReg (targetReg), 
        .memDataSrc (memDataSrc), 
        .funct (funct), 
        .IF_IDstall (IF_IDstall), 
        .jumpClear (jumpClear), 
        .jumpEnable (jumpEnable),
        .clk (clk25));
    
    ///////STALL LOGIC/////////
    always @(*)begin
        if ((funct_EXo == 5'b10001)  && ((targetReg_EXo == Areg) || (targetReg_EXo == Breg)))begin
            IF_IDstall = 1;
        end
        else if ((funct_EXo == 5'b10100) || (funct_EXo == 5'b10011)) begin
            IF_IDstall = 1;
        end
        else begin
            IF_IDstall = 0;
        end
    end

    reg [7:0] aluAin, aluBin;
    
    ALU a0 (ALUresult, zeroFlag, overflow, aluAin, aluBin, ALUop_EXo, funct_EXo[4:3]);
    
    EX_MEM execute_memAccess(
    .funct_o (funct_MEMo), 
    .immed_o (immed_MEMo), 
    .memAddr_o (memAddr_MEMo), 
    .ALUresult_o (ALUresult_MEMo), 
    .memWriteData_o (memDataIn_MEMo),
    .zeroFlag_o (zeroFlag_MEMo), 
    .memReadWrite_o (memReadWrite_MEMo), 
    .regWrite_o (regWrite_MEMo), 
    .targetReg_o (targetReg_MEMo),
    .Areg_o (Areg_MEMo), 
    .Breg_o (Breg_MEMo),
    .jumpEnable_o (jumpEnable_MEMo),
    .immed (immed_EXo), 
    .memAddr (addressIn_EXo), 
    .ALUresult (ALUresult), 
    .memWriteData (memDataIn_EXo), 
    .targetReg (targetReg_EXo), 
    .Areg (Areg_EXo), 
    .Breg (Breg_EXo), 
    .regWrite (regWrite_EXo), 
    .memReadWrite (memReadWrite_EXo), 
    .zeroFlag (zeroFlag), 
    .funct (funct_EXo),
    .jumpClear (jumpClear), 
    .jumpEnable (jumpEnable_EXo),
    .clk (clk25)
    );
    
   // HAZARD FORWARDING AND ALU MUX //
    reg [1:0] forwardA = 0;
    reg [1:0] forwardB = 0;
    
    always @ (*)begin
        if (regWrite_MEMo && (targetReg_MEMo != 0) && (targetReg_MEMo == Areg_EXo)) begin
            forwardA = 2'b10;
        end 
        else if (regWrite_WBo && (targetReg_WBo != 0) && (targetReg_WBo == Areg_EXo)) begin
            forwardA = 2'b01;
        end
        else begin
            forwardA = 2'b00;
        end
        if (regWrite_MEMo && (targetReg_MEMo != 0) && (targetReg_MEMo == Breg_EXo)) begin
            forwardB = 2'b10;
        end
        else if (regWrite_WBo && (targetReg_WBo != 0) && (targetReg_WBo == Breg_EXo)) begin
            forwardB = 2'b01;
        end
        else begin
            forwardB = 2'b00;
        end
    end
    
    //BRANCH LOGIC
    always @ (*) begin
        branchTarget = memDataOut;        
         if (funct_MEMo == 5'b10100)begin // BEQ
            branch = zeroFlag_MEMo ? 1 : 0;
            jumpClear = zeroFlag_MEMo ? 1 : 0;
            PCnext = branch ? branchTarget : (PC + 1);
            jumpCountNext = jumpCount;
         end
         else if (funct_MEMo == 5'b10011) begin //jump
              branch = jumpEnable_MEMo ? 1 : 0;
              jumpClear = jumpEnable_MEMo ? 1: 0;
              PCnext = jumpEnable_MEMo ? branchTarget : (PC + 1);
              jumpCountNext = jumpCount + 1;
         end
         else begin
            branch = 0;
            jumpClear = 0;
            PCnext = PC + 1;
            jumpCountNext = jumpCount;
         end
    end
    
    //REST OF THE FORWARDING LOGIC
    always @ (*) begin
        if (funct_EXo[4:3] == 2'b01) begin
            aluAin = immed_EXo;
            aluBin = 0;
        end
        else begin
        case (forwardA)
        2'b00: aluAin = alui_opA;
        2'b10: aluAin = ALUresult_MEMo;
        2'b01: aluAin = ALUresult_WBo;
        default: aluAin = alui_opA;
        endcase
        case (forwardB)
        2'b00: aluBin = alui_opB;
        2'b10: aluBin = ALUresult_MEMo;
        2'b01: aluBin = ALUresult_WBo;
        default: aluBin = alui_opA;
        endcase
        end
    end
    
    MEM_WB memAccess_WriteBack(
    .funct_o (funct_WBo),
    .immed_o (immed_WBo), 
    .memData_o (memDataOut_WBo), 
    .ALUresult_o (ALUresult_WBo), 
    .targetReg_o (targetReg_WBo),
    .regWrite_o (regWrite_WBo), 
    .immed (immed_MEMo), 
    .memData (memDataOut), 
    .ALUresult (ALUresult_MEMo), 
    .targetReg (targetReg_MEMo), 
    .regWrite (regWrite_MEMo), 
    .jumpClear (jumpClear), 
    .funct (funct_MEMo),
    .clk (clk25)
    );
    
    always @ (*)begin
        branch = 0; 
         if (funct_WBo == 5'b10001) begin
            writeData = memDataOut_WBo;
         end
         else begin
            writeData = ALUresult_WBo;  
         end
    end 
   
     assign LED[7:0] = displayData;
     //assign LED[15:8] = jumpLimit;
   
   //bin2bcd module is from RealDigital.org
   //takes a 14 bit binary input and outputs 4 digit (16 bit) bcd out
   wire [13:0] extended = displayData; //expand 14 bits
   wire [13:0] extended2 = displayDataMem; //expand 14 bits
   wire [11:0] BCD_result_extended2;
   bin2bcd bcd (BCD_result_extended, extended);
   bin2bcd bcd2 (BCD_result_extended2, extended2);
   always @(posedge clk25) begin
    if (BTN_0 && !BTN_2) begin
      ones = BCD_result_extended[3:0];
      tens = BCD_result_extended[7:4];
      hundreds = BCD_result_extended[11:8];
      hundreds = BCD_result_extended[11:8];
    end
    else if (BTN_2 & !BTN_0) begin
      ones = BCD_result_extended2[3:0];
      tens = BCD_result_extended2[7:4];
      hundreds = BCD_result_extended2[11:8];
    end
    else begin
      ones = ones;
      tens = tens;
      hundreds = hundreds;
    end
   end 
  
   timer_display d0 (D1_SEG, D1_AN, ones, tens, hundreds, clk);
endmodule


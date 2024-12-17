`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 10:45:40 PM
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM(
    output reg [4:0] funct_o,
    output reg [7:0] immed_o, 
    output reg [7:0] memAddr_o, 
    output reg [7:0] ALUresult_o, 
    output reg [7:0] memWriteData_o,
    //output reg writeDataSrc_o, 
    output reg zeroFlag_o, 
    //output reg displayON_o, 
    output reg memReadWrite_o, 
    output reg regWrite_o,
    output reg [2:0] targetReg_o, 
    output reg [2:0] Areg_o, 
    output reg [2:0] Breg_o,
    output reg jumpEnable_o,
    input [7:0] immed, 
    input [7:0] memAddr, 
    input [7:0] ALUresult, 
    input [7:0] memWriteData,
    input [2:0] targetReg, 
    input [2:0] Areg, 
    input [2:0] Breg,
    //input writeDataSrc, 
    input regWrite, 
    //input displayON,
    input memReadWrite,
    input zeroFlag, 
    input [4:0] funct,
    //input IF_IDstall, 
    input jumpClear,
    //input EOP,
    input jumpEnable,
    input clk
    );
    
    always @(posedge clk)begin
        if (!jumpClear)begin
            immed_o <= immed;
            memAddr_o <= memAddr;
            zeroFlag_o <= zeroFlag;
            ALUresult_o <= ALUresult;
            memWriteData_o <= memWriteData;
            targetReg_o <= targetReg;
            regWrite_o <= regWrite;
            memReadWrite_o <= memReadWrite;  
            funct_o <= funct;
            Areg_o <= Areg;
            Breg_o <= Breg;
            jumpEnable_o <= jumpEnable;
        end
        else begin
            immed_o <= 0;
            memAddr_o <= 0;
            zeroFlag_o <= 0;
            ALUresult_o <= 0;
            memWriteData_o <= 0;
            targetReg_o <= 0;
            regWrite_o <= 0;
            memReadWrite_o <= 0;  
            funct_o <= 0;
            Areg_o <= 0;
            Breg_o <= 0;
            jumpEnable_o <= 0;
        end
    end
    
endmodule

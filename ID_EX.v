`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 10:35:21 PM
// Design Name: 
// Module Name: ID_EX
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


module ID_EX(
    output reg [4:0] funct_o,
    output reg [7:0] opA,
    output reg [7:0]opB,
    output reg [7:0]memWriteData, 
    output reg [7:0]addressIn_o,
    output reg [7:0]immed_o,
    output reg [2:0] ALUop_o, 
    output reg [2:0]targetReg_o, 
    output reg [2:0]Areg_o, 
    output reg [2:0]Breg_o,
    output reg regWrite_o, 
    output reg memReadWrite_o, 
    output reg jumpEnable_o,
    input [7:0] dataA, 
    input [7:0] dataB, 
    input [7:0] PClink, 
    input [7:0] addressIn, 
    input [7:0] immed,
    input [2:0] Areg, 
    input [2:0] Breg,
    input regWrite, 
    input memReadWrite, 
    input [2:0] ALUop, 
    input [2:0] targetReg,
    input memDataSrc,
    input [4:0] funct,
    input IF_IDstall, 
    input jumpClear, 
    input jumpEnable,
    input clk
    );
    always @(posedge clk)begin
        if (!IF_IDstall && !jumpClear) begin
            opA <= dataA;
            opB <= dataB;
            memWriteData <= memDataSrc ? (PClink) : dataA;
            addressIn_o <= addressIn;
            ALUop_o <= ALUop;
            targetReg_o <= targetReg;
            regWrite_o <= regWrite;
            memReadWrite_o <= memReadWrite; 
            immed_o <= immed;    
            funct_o <= funct;
            Areg_o <= Areg;
            Breg_o <= Breg;
            jumpEnable_o <= jumpEnable;
        end
        else begin
            opA <= 0;
            opB <= 0;
            memWriteData <= 0;
            addressIn_o <= 0;
            ALUop_o <= 0;
            targetReg_o <= 0;
            regWrite_o <= 0;
            memReadWrite_o <= 0; 
            immed_o <= 0;    
            funct_o <= 0;
            Areg_o <= 0;
            Breg_o <= 0;
            jumpEnable_o <= 0;
        end
    end
endmodule

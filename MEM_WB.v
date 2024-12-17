`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 11:11:35 PM
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB(
    //output reg [4:0] funct_o,
    output reg [7:0] immed_o, 
    output reg [7:0] memData_o, 
    output reg [7:0] ALUresult_o,
    output reg [2:0] targetReg_o, 
    output reg regWrite_o, 
    //output reg zeroFlag_o, 
    input [7:0] immed,
    input [7:0] memData, 
    input [7:0] ALUresult,
    input [2:0] targetReg,
    input regWrite, 
    //input zeroFlag, 
    //input [4:0] funct,
    input jumpClear, 
    input clk
    );
    
    always @(posedge clk)begin
        if (!jumpClear)begin
            //zeroFlag_o <= zeroFlag;
            ALUresult_o <= ALUresult;
            targetReg_o <= targetReg;
            regWrite_o <= regWrite;
            immed_o <= immed;
            //funct_o <= funct;
            memData_o <= memData;
        end
        else  begin
            //zeroFlag_o <= 0;
            ALUresult_o <= 0;
            targetReg_o <= 0;
            regWrite_o <= 0;
            immed_o <= 0;
            //funct_o <= 0;
            memData_o <= 0;
        end
    end
endmodule

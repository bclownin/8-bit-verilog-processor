`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 09:02:41 PM
// Design Name: 
// Module Name: Registers
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

module Registers(
output [7:0] displayData, 
output reg [7:0] dataA, dataB,
input [2:0] regA, regB, target,
input readWrite,
input [7:0] writeData,
input [2:0] displayReg,
//input EOP,
input clk
    );   
    localparam read = 0;
    localparam write = 1;
    reg [7:0] regFile [0:7];
    initial begin
        regFile[0] = 0;
        regFile[1] = 0;
        regFile[2] = 0;
        regFile[3] = 0;
        regFile[4] = 0;
        regFile[5] = 0;
        regFile[6] = 0;
        regFile[7] = 0;
    end
    
    always @ (posedge clk) begin
        if ((readWrite == write) && (target != 0)) begin
            regFile[target] <= writeData;
        end
    end

    assign displayData = regFile[displayReg];
    always @ (*) begin
        dataA = regFile[regA];
        dataB = regFile[regB];
        
        if (readWrite && (target == regA)) begin //forward data from write back stage
            dataA = writeData;
        end
        else if (readWrite && (target == regB)) begin
            dataB = writeData;
        end
    end
endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 10:13:55 PM
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(
    output reg [15:0] instr_o,
    output reg [4:0] funct,
    output reg [2:0] target,
    output reg [2:0] Areg,
    output reg [2:0] Breg,
    output reg [7:0]immed,
    input [15:0]instr, 
    input IF_IDstall, 
    input jumpClear,
    input clk
    );
    
    always @ (posedge clk)begin
        if (!IF_IDstall && !jumpClear)begin    
            funct <= instr[15:11];
            target <= instr[10:8];
            Areg <= instr[5:3];
            Breg <= instr[2:0];
            immed <= instr[7:0];
            instr_o <= instr;
        end
        else if (jumpClear) begin 
            funct <= 0;
            target <= 0;
            Areg <= 0;
            Breg <= 0;
            immed <= 0;
            instr_o <= 0;
        end
     end
endmodule

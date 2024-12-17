`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 09:03:15 PM
// Design Name: 
// Module Name: ALU
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

module ALU(
    output reg [7:0] result, 
    output zeroFlag, 
    output overflow,
    input [7:0] opA, opB, 
    input [2:0] ALUop,
    input [1:0] funct);    
    //ALUop functions
    /*   000 = AND
         001 = OR
         010 = ADD
         011 = Subtract
         100 = set less
         101 = NOR
         110 = set equal */    
    always @ (ALUop,opA, opB, funct) begin
//        if (funct == 2'd3)begin
//            result = opA; //passthrough to 7 seg
//        end
//        else begin
        case (ALUop)
            0: result = opA & opB;
            1: result = opA | opB;
            2: result = opA + opB;
            3: result = opA - opB;
            4: result = opA < opB ? 8'd1: 0;
            5: result = ~(opA |opB);
            6: result = opA == opB ? 8'd1:0;
            default: result = 0;
        endcase            
//        end
    end
    assign zeroFlag = (result == 0);
    assign overflow = ((opA[7] == opB[7]) && (opA[7] != result[7]));
endmodule 
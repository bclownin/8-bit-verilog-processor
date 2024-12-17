`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 09:01:36 PM
// Design Name: 
// Module Name: Instruction_Memory
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


module Instruction_Memory(
    output [15:0] instr,
    input [7:0] PC
    );
    
    reg [15:0] instrMem [0:255];
    
    initial $readmemb("memory.mem", instrMem);
    
    assign instr = instrMem[PC];
 
endmodule

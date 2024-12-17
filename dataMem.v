`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 09:02:19 PM
// Design Name: 
// Module Name: dataMem
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

module dataMem(
output [7:0] displayDataMem,
output [7:0] dataOut,
input [7:0] dataIn,
input [7:0] address,
input memReadWrite,
input [7:0] displayAddr,
input clk
);
localparam read = 0;
localparam write = 1;
reg [7:0] dataMem [0:255];

always @ (posedge clk) begin
    if (memReadWrite == write)begin
        dataMem [address] <= dataIn;
    end
end
assign dataOut = dataMem [address];
assign displayDataMem = dataMem[displayAddr];
       
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 09:00:21 PM
// Design Name: 
// Module Name: sysClock
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


module sysClock(
    output clk25,
    input clk
    );
   reg [1:0] counter;
   reg clk25reg;
 always @ (posedge(clk))
 begin
     if (counter == 2'b11) begin
        counter <= 0;
        clk25reg <= clk25reg ? 0 : 1;
     end
     else begin
        counter <= counter + 1;
     end
end
assign clk25 = clk25reg;
endmodule
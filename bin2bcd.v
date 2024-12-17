`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 09:03:42 PM
// Design Name: 
// Module Name: bin2bcd
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


module bin2bcd(
   output reg [15:0] bcd,
   input [13:0] bin
   );
  
integer i;
	
always @(bin) begin
    bcd=0;		 	
    for (i=0;i<14;i=i+1) begin					//Iterate once for each bit in input number
        if (bcd[3:0] >= 5) bcd[3:0] = bcd[3:0] + 3;		//If any BCD digit is >= 5, add three
	if (bcd[7:4] >= 5) bcd[7:4] = bcd[7:4] + 3;
	if (bcd[11:8] >= 5) bcd[11:8] = bcd[11:8] + 3;
	if (bcd[15:12] >= 5) bcd[15:12] = bcd[15:12] + 3;
	bcd = {bcd[14:0],bin[13-i]};				//Shift one bit, and shift in proper bit from input 
    end
end
endmodule

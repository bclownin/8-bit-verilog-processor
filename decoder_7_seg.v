`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 09:04:56 PM
// Design Name: 
// Module Name: decoder_7_seg
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

module decoder_7_seg(output reg [7:0] Seg, input [3:0] D);	
   always @(D)
      case (D) 
//         4'd0:    Seg = 8'b00000011;
//         4'd1:    Seg = 8'b10011111; 
//         4'd2:    Seg = 8'b00100101; 
//         4'd3:    Seg = 8'b00001101;
//         4'd4:    Seg = 8'b10011001;
//         4'd5:    Seg = 8'b01001001;
//         4'd6:    Seg = 8'b01000001;
//         4'd7:    Seg = 8'b00011111;
//         4'd8:    Seg = 8'b00000001;
//         4'd9:    Seg = 8'b00001001;
         
         4'd0:    Seg = 8'b11000000;
         4'd1:    Seg = 8'b11111001; 
         4'd2:    Seg = 8'b10100100; 
         4'd3:    Seg = 8'b10110000;
         4'd4:    Seg = 8'b10011001;
         4'd5:    Seg = 8'b10010010;
         4'd6:    Seg = 8'b10000010;
         4'd7:    Seg = 8'b11111000;
         4'd8:    Seg = 8'b10000000;
         4'd9:    Seg = 8'b10010000;

         default: Seg = 8'b11111111; 
      endcase
endmodule
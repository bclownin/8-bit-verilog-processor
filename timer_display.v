`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 09:04:32 PM
// Design Name: 
// Module Name: timer_display
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


module timer_display( //Seg and Display are D1_SEG and D1_AN on the boolean board. Second 7seg bank controlled seperately
   output [7:0] Seg,
   output reg [3:0] Display,
   input [3:0] ones, tens, hundreds,
   input clk);
    
    reg [3:0] D;
    reg [2:0] state = 0;
	reg [23:0] prescaler; //17 needed?
    
    decoder_7_seg d (Seg, D);
   
    always @ (posedge clk) begin
	  prescaler <= prescaler + 24'b1;
	  if (prescaler == 24'd100000) begin //  100MHz/100,000 = 1 kHz
          prescaler <= 0;
          case (state)
                0: begin 
                      D <= ones; 
                      Display <= 4'b1110;
                   end
                1: begin 
                      D <= tens; 
                      Display <= 4'b1101;
                   end
                2: begin
                      D <= hundreds; 
                      Display <= 4'b1011;
                   end                
                default: begin
                      D <= 4'b1111;
                      Display <= 4'b1111;
                   end
              endcase
              state <= state + 1;
              if (state == 3) begin //could change to 3 since only using 3 of the 7segs
               state <= 0;
               end
        end
   end
endmodule

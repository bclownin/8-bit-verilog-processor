`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 09:01:13 PM
// Design Name: 
// Module Name: debouncer
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


module debouncer(
output trans_dn, 
input switch_input, clk);
    
   reg state;  
   reg sync_0, sync_1; // For 2-bit SRG
   reg[19:0] count;    // Counter for debounce
   wire idle = (state == sync_1); // Is the state the same (i.e. idle)?
   wire finished = (count > 20'd1_000_000); // Done with count?
   
   wire ce = ~idle & finished;

   always @ (posedge clk) begin   // 2-bit SRG
      sync_0 <= switch_input;
      sync_1 <= sync_0;
   end
	
   always @ (posedge clk) begin
      if (ce)
         count <= 20'b0;
      else begin
         count <= count + 20'b1;
         if (finished) // Wait for 1/100 s (10 ms.)
            state <= ~state;
      end
   end
	
   assign trans_dn = ~idle & finished & ~state;
   //assign trans_up = ~idle & finished & state;
endmodule
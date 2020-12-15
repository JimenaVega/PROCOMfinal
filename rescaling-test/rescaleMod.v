`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.12.2020 09:53:33
// Design Name: 
// Module Name: rescaleMod
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


module rescaleMod
    #(
    NB_PIXEL = 19,
    NEW_MAX = 255,
    NEW_MIN = 0
    )(
    input  i_endSignal,
    input  signed [NB_PIXEL - 1 : 0] maxByte,
    input  signed [NB_PIXEL - 1 : 0] minByte,
    output signed [NB_PIXEL - 1 : 0] newByte
    );
    
    
endmodule

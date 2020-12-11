`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.11.2020 10:33:55
// Design Name: 
// Module Name: tb_xtremeSearch
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


module tb_xtremeSearch();

parameter NB_PIXEL = 19;
parameter NB_COUNT = 32; 



reg clock;
reg reset;
reg valid;
reg [31:0]imageSize;//480x640 & 300x450
reg  [NB_PIXEL - 1 : 0]convValue;
wire [NB_PIXEL - 1 : 0]maxValue;
wire [NB_PIXEL - 1 : 0]minValue;
wire endSignal;
wire o_entre;

initial begin
    reset = 1'b1;
    clock = 1'b0;
    imageSize = 100;
    $display("max value = %b", maxValue);
    $display("min value = %b", minValue);
    #20 reset = 1'b0;
    #10 convValue = 0;
    #10 convValue = 1;
    $display("%b", convValue);
    #10 convValue = 2;
    #10 convValue = -1;
    #10 convValue = 4;
    #10 convValue = 5;
    #10 convValue = 6;
    #10 convValue = 7;
    #10 convValue = 8;
    #10 convValue = 9;
    #10 convValue = 10;
    #10 convValue = 11;
    #10 convValue = 12;
    #10 convValue = 13;
    #10 convValue = 14;
    #10 convValue = 15;
    #10 convValue = 16;
    #10 convValue = 17;
    #10 convValue = 18;
    #10 convValue = 19;
    #10 convValue = 20;
    #10 convValue = 21;
    #10 convValue = 22;
    #10 convValue = 23;
    #10 convValue = 24;
    #10 convValue = 25;
    #10 convValue = 26;
    #10 convValue = 27;
    #10 convValue = 28;
    #10 convValue = 29;
    #10 convValue = 30;
    #10 convValue = 31;
    #10 convValue = 32;
    #10 convValue = 33;
    #10 convValue = 34;
    #10 convValue = 35;
    #10 convValue = 36;
    #10 convValue = 37;
    #10 convValue = 38;
    #10 convValue = 39;
    #10 convValue = 40;
    #10 convValue = 41;
    #10 convValue = 42;
    #10 convValue = 43;
    #10 convValue = 44;
    #10 convValue = 45;
    #10 convValue = 46;
    #10 convValue = 47;
    #10 convValue = 48;
    #10 convValue = 49;
    #10 convValue = 50;
    #10 convValue = 51;
    #10 convValue = 52;
    #10 convValue = 53;
    #10 convValue = 54;
    #10 convValue = 55;
    #10 convValue = 56;
    #10 convValue = 57;
    #10 convValue = 58;
    #10 convValue = 59;
    #10 convValue = 60;
    #10 convValue = 61;
    #10 convValue = 62;
    #10 convValue = 63;
    #10 convValue = 64;
    #10 convValue = 65;
    #10 convValue = 66;
    #10 convValue = 67;
    #10 convValue = 68;
    #10 convValue = 69;
    #10 convValue = 70;
    #10 convValue = 71;
    #10 convValue = 72;
    #10 convValue = 73;
    #10 convValue = 74;
    #10 convValue = 75;
    #10 convValue = 76;
    #10 convValue = 77;
    #10 convValue = 78;
    #10 convValue = 79;
    #10 convValue = 80;
    #10 convValue = 81;
    #10 convValue = 82;
    #10 convValue = 83;
    #10 convValue = 84;
    #10 convValue = 85;
    #10 convValue = 86;
    #10 convValue = 87;
    #10 convValue = 88;
    #10 convValue = 89;
    #10 convValue = 90;
    #10 convValue = 91;
    #10 convValue = 92;
    #10 convValue = 93;
    #10 convValue = 94;
    #10 convValue = 95;
    #10 convValue = 96;
    #10 convValue = 97;
    #10 convValue = 98;
    #10 convValue = 99;
    $display("%b", convValue);
    
    #10 valid     = 1;
    #100 valid     = 0;
    #10 reset = 1;
    #10 reset = 0 ;
    #2000 $finish; 
end

always #5 clock = ~clock;

xtremeSearch
  #(
    .NB_PIXEL   (NB_PIXEL),
    .NB_COUNT   (NB_COUNT)
    )
  u_xtremeSearch
    (
     .o_maxValue     (maxValue),
     .o_minValue     (minValue),
     .o_endSignal    (endSignal),
     .o_entre        (o_entre),
     .clock          (clock),
     .reset          (reset),
     .i_valid        (valid),
     .i_imageSize    (imageSize),  
     .i_convValue    (convValue)
     
     );


 
endmodule

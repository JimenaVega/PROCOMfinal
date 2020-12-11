`define IMG_HEIGHT 480
`define IMG_NB 7
`define KERNEL_SIZE 3
`define KERNEL_NB 8

`timescale 1ns/100ps

module test_bench();

//parameter IMG_HEIGHT  = `IMG_HEIGHT;
//parameter IMG_NB      = `IMG_NB;
//parameter KERNEL_SIZE = `KERNEL_SIZE;
//parameter KERNEL_NB   = `KERNEL_NB;

   reg i_reset;
   reg clock;
   reg [6:0]i_pixel;
   wire [18:0]o_pixel;
  
   initial begin
      clock = 1'b0;
      i_reset = 1'b0;
      i_pixel = 7'd1;
      #5 i_reset = 1'b1;
      #5 i_reset = 1'b0;
      #10 $finish;
   end
   
   always #5 clock = ~clock;

convolve conv1
    (.in_reset      (i_reset),
     .clk100        (clock),
     .i_pixel       (i_pixel),
     .o_pixel       (o_pixel)
     );

endmodule
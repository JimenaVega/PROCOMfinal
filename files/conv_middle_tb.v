`define IMG_HEIGHT 480
`define IMG_NB 7
`define KERNEL_SIZE 3
`define KERNEL_NB 8

`timescale 1ns/100ps

module test_bench();

parameter IMG_HEIGHT  = `IMG_HEIGHT;
parameter IMG_NB      = `IMG_NB;
parameter KERNEL_SIZE = `KERNEL_SIZE;
parameter KERNEL_NB   = `KERNEL_NB;

   reg i_reset;
   reg clock;
   
   reg [(IMG_HEIGHT*IMG_NB)-1:0] col;
   reg [(KERNEL_SIZE*KERNEL_SIZE*KERNEL_NB)-1:0] kernel;
   wire [18:0]result;
   
   integer ptr;
   
   initial begin
      clock = 1'b0;
      
      kernel[(KERNEL_SIZE*KERNEL_SIZE*KERNEL_NB-1)-KERNEL_NB*0 -: KERNEL_NB] = 8'd1;
      kernel[(KERNEL_SIZE*KERNEL_SIZE*KERNEL_NB-1)-KERNEL_NB*1 -: KERNEL_NB] = 8'd1;
      kernel[(KERNEL_SIZE*KERNEL_SIZE*KERNEL_NB-1)-KERNEL_NB*2 -: KERNEL_NB] = 8'd1;
      
      kernel[(KERNEL_SIZE*KERNEL_SIZE*KERNEL_NB-1)-KERNEL_NB*3 -: KERNEL_NB] = 8'd1;
      kernel[(KERNEL_SIZE*KERNEL_SIZE*KERNEL_NB-1)-KERNEL_NB*4 -: KERNEL_NB] = 8'd1;
      kernel[(KERNEL_SIZE*KERNEL_SIZE*KERNEL_NB-1)-KERNEL_NB*5 -: KERNEL_NB] = 8'd1;
      
      kernel[(KERNEL_SIZE*KERNEL_SIZE*KERNEL_NB-1)-KERNEL_NB*6 -: KERNEL_NB] = 8'd1;
      kernel[(KERNEL_SIZE*KERNEL_SIZE*KERNEL_NB-1)-KERNEL_NB*7 -: KERNEL_NB] = 8'd1;
      kernel[(KERNEL_SIZE*KERNEL_SIZE*KERNEL_NB-1)-KERNEL_NB*8 -: KERNEL_NB] = 8'd1;
      
      for(ptr=0;ptr<480;ptr=ptr+1)
        col[(IMG_HEIGHT*IMG_NB-1)-(IMG_NB*ptr) -: 7] <= ptr;
      
      i_reset      = 1'b0;
      #100 i_reset = 1'b1;
      #100 i_reset = 1'b0;
      
      #1000000 $finish;
   end
   
   always #5 clock = ~clock;

Convolution conv1
     (.in_reset      (i_reset),
     .clk100         (clock),
     .i_col         (col),
     .i_kernel      (kernel),
     .o_new_pixel  (result)
     );

endmodule
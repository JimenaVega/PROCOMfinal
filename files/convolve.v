`timescale 1ns / 1ps

module convolve
  #(parameter PIXEL_NB = 7,
    parameter KERNEL_SIZE = 3,
    parameter KERNEL_NB = 8
    )
   (input clk100,
    input in_reset,
    input [6:0] i_pixel,
    output[18:0] o_pixel
    );
    
reg signed [PIXEL_NB-1 : 0] shift [(KERNEL_SIZE*KERNEL_SIZE)-1 : 0];
reg signed [KERNEL_NB-1 : 0] kernel [(KERNEL_SIZE*KERNEL_SIZE)-1 : 0];
reg signed[18:0]result0;
reg signed[18:0]result1;
reg signed[18:0]result2;
reg [1:0] counter; //= {2{1'b0}};
integer ptr;
integer ptr1;
reg signed[18:0] add_tmp;


always@(posedge clk100)begin
    if(in_reset)begin
        counter <= 2'd0;
        result0 <= 19'd0;
        result1 <= 19'd0;
        result2 <= 19'd0;
        
        kernel[8] <= 8'b1;
        kernel[7] <= 8'b1;
        kernel[6] <= 8'b1;
        kernel[5] <= 8'b1;
        kernel[4] <= 8'b1;
        kernel[3] <= 8'b1;
        kernel[2] <= 8'b1;
        kernel[1] <= 8'b1;
        kernel[0] <= 8'b1;
        
        for(ptr = 0; ptr < KERNEL_SIZE*KERNEL_SIZE; ptr = ptr + 1)begin
            shift[ptr] <= 7'd0;
        end
    end
    else begin
//        for(ptr = 0; ptr < (KERNEL_SIZE*KERNEL_SIZE)-1; ptr = ptr + 1)begin
        for(ptr = 0; ptr < (KERNEL_SIZE*KERNEL_SIZE)-1; ptr = ptr + 1)begin
//            shift[ptr+1] <= shift[ptr];
            shift[ptr] <= shift[ptr+1];
        end
        shift[8] <= i_pixel;
        counter <= counter + 1;
        if(counter == 2)begin
            result0 <= shift[0]*kernel[0] + shift[1]*kernel[1] + shift[2]*kernel[2];
            result1 <= shift[3]*kernel[3] + shift[4]*kernel[4] + shift[5]*kernel[5];
            result2 <= shift[6]*kernel[6] + shift[7]*kernel[7] + shift[8]*kernel[8];
            counter <= 2'd0;
        end
    end
end

assign o_pixel = result0 + result1 + result2;
    
endmodule
`timescale 1ns / 1ps

module Convolution
  #(parameter IMG_HEIGHT  = 480,
    parameter IMG_NB      = 7,
    parameter KERNEL_SIZE = 3,
    parameter KERNEL_NB   = 8
    )
   (input  clk100,
    input  in_reset,
    input  [(IMG_HEIGHT*IMG_NB)-1:0] i_col,
    input  signed [(KERNEL_SIZE*KERNEL_SIZE*KERNEL_NB)-1:0] i_kernel,
    output [18:0] o_new_pixel
    );
    
reg [IMG_NB-1:0] column0 [IMG_HEIGHT+1:0];
reg [IMG_NB-1:0] column1 [IMG_HEIGHT+1:0];
reg [IMG_NB-1:0] column2 [IMG_HEIGHT+1:0];
reg [IMG_NB-1:0] column3 [IMG_HEIGHT+1:0];

reg [18:0] new_pixel;

reg signed [KERNEL_NB-1:0]  kernel_c0 [KERNEL_SIZE-1:0];
reg signed [KERNEL_NB-1:0]  kernel_c1 [KERNEL_SIZE-1:0];
reg signed [KERNEL_NB-1:0]  kernel_c2 [KERNEL_SIZE-1:0];

reg [2:0] control;
reg [1:0] counter;

integer ptr;
integer ptr1;
integer ptr2;

always@(posedge clk100)begin
    if(in_reset)begin:reset 
        counter        <= 2'd0; 
        control        <= 3'd0;
        ptr1 = 0;
        
        column0[IMG_HEIGHT+1] <= 1'd0;
        column0[0]            <= 1'd0;
        column1[IMG_HEIGHT+1] <= 1'd0;
        column1[0]            <= 1'd0;
        column2[IMG_HEIGHT+1] <= 1'd0;
        column2[0]            <= 1'd0;
        column3[IMG_HEIGHT+1] <= 1'd0;
        column3[0]            <= 1'd0;
        
        kernel_c0[2] <= i_kernel[71 -: 8];
        kernel_c0[1] <= i_kernel[63 -: 8];
        kernel_c0[0] <= i_kernel[55 -: 8];
        
        kernel_c1[2] <= i_kernel[47 -: 8];
        kernel_c1[1] <= i_kernel[39 -: 8];
        kernel_c1[0] <= i_kernel[31 -: 8];
        
        kernel_c2[2] <= i_kernel[23 -: 8];
        kernel_c2[1] <= i_kernel[15 -: 8];
        kernel_c2[0] <= i_kernel[ 7 -: 8];
    end    
    else if(control == 0)begin:filling_columns_0_1_2    // Se realiza la carga de las columnas 0, 1 y 2
        for(ptr=0;ptr<IMG_HEIGHT;ptr=ptr+1)begin
            if(counter == 0)
                column0[IMG_HEIGHT-ptr] <= i_col[(IMG_HEIGHT*IMG_NB-ptr*IMG_NB)-1 -: IMG_NB];
            else if(counter == 1)
                column1[IMG_HEIGHT-ptr] <= i_col[(IMG_HEIGHT*IMG_NB-ptr*IMG_NB)-1 -: IMG_NB];
            else if(counter == 2)
                column2[IMG_HEIGHT-ptr] <= i_col[(IMG_HEIGHT*IMG_NB-ptr*IMG_NB)-1 -: IMG_NB];
        end
        if(counter == 2)begin
            counter <= 2'd0;
            control <= 3'd1;
        end
        else begin
            counter <= counter+1;
        end
    end
    else if(control == 1)begin:conv0  // Se hace la convolucion del kernel con las columnas 0, 1 y 2
        new_pixel <=    kernel_c0[2]*column0[IMG_HEIGHT+1-ptr1] + kernel_c1[2]*column1[IMG_HEIGHT+1-ptr1] + kernel_c2[2]*column2[IMG_HEIGHT+1-ptr1] +
                        kernel_c0[1]*column0[IMG_HEIGHT-ptr1]   + kernel_c1[1]*column1[IMG_HEIGHT-ptr1]   + kernel_c2[1]*column2[IMG_HEIGHT-ptr1]   +
                        kernel_c0[0]*column0[IMG_HEIGHT-1-ptr1] + kernel_c1[0]*column1[IMG_HEIGHT-1-ptr1] + kernel_c2[0]*column2[IMG_HEIGHT-1-ptr1];
        ptr1 = ptr1+1;
        
        if(ptr1 == 480)begin
            for(ptr2=0;ptr2<IMG_HEIGHT;ptr2=ptr2+1)                                                 // Se realiza la carga de la
                column3[IMG_HEIGHT-ptr2] <= i_col[(IMG_HEIGHT*IMG_NB-ptr2*IMG_NB)-1 -: IMG_NB];     // columna 3
            ptr1 = 0;
            control         <= 3'd2;
        end
    end
    else if(control == 2)begin:conv1  // Se hace la convolucion del kernel con las columnas 1, 2 y 3
        new_pixel <=    kernel_c0[2]*column1[IMG_HEIGHT+1-ptr1] + kernel_c1[2]*column2[IMG_HEIGHT+1-ptr1] + kernel_c2[2]*column3[IMG_HEIGHT+1-ptr1] +
                        kernel_c0[1]*column1[IMG_HEIGHT-ptr1]   + kernel_c1[1]*column2[IMG_HEIGHT-ptr1]   + kernel_c2[1]*column3[IMG_HEIGHT-ptr1]   +
                        kernel_c0[0]*column1[IMG_HEIGHT-1-ptr1] + kernel_c1[0]*column2[IMG_HEIGHT-1-ptr1] + kernel_c2[0]*column3[IMG_HEIGHT-1-ptr1];
        ptr1 = ptr1+1;
        if(ptr1 == 480)begin
            for(ptr2=0;ptr2<IMG_HEIGHT;ptr2=ptr2+1)                                                 // Se realiza la carga de la
                column0[IMG_HEIGHT-ptr2] <= i_col[(IMG_HEIGHT*IMG_NB-ptr2*IMG_NB)-1 -: IMG_NB];     // columna 0
            ptr1 = 0;
            control         <= 3'd3;
        end
    end
    else if(control == 3)begin:conv2  // Se hace la convolucion del kernel con las columnas 2, 3 y 0
        new_pixel <=    kernel_c0[2]*column2[IMG_HEIGHT+1-ptr1] + kernel_c1[2]*column3[IMG_HEIGHT+1-ptr1] + kernel_c2[2]*column0[IMG_HEIGHT+1-ptr1] +
                        kernel_c0[1]*column2[IMG_HEIGHT-ptr1]   + kernel_c1[1]*column3[IMG_HEIGHT-ptr1]   + kernel_c2[1]*column0[IMG_HEIGHT-ptr1]   +
                        kernel_c0[0]*column2[IMG_HEIGHT-1-ptr1] + kernel_c1[0]*column3[IMG_HEIGHT-1-ptr1] + kernel_c2[0]*column0[IMG_HEIGHT-1-ptr1];
        ptr1 = ptr1+1;
        if(ptr1 == 480)begin
            for(ptr2=0;ptr2<IMG_HEIGHT;ptr2=ptr2+1)                                                 // Se realiza la carga de la
                column1[IMG_HEIGHT-ptr2] <= i_col[(IMG_HEIGHT*IMG_NB-ptr2*IMG_NB)-1 -: IMG_NB];     // columna 1
            ptr1 = 0;
            control         <= 3'd4;
        end
    end
    else if(control == 4)begin:conv3  // Se hace la convolucion del kernel con las columnas 3, 0 y 1
        new_pixel <=    kernel_c0[2]*column3[IMG_HEIGHT+1-ptr1] + kernel_c1[2]*column0[IMG_HEIGHT+1-ptr1] + kernel_c2[2]*column1[IMG_HEIGHT+1-ptr1] +
                        kernel_c0[1]*column3[IMG_HEIGHT-ptr1]   + kernel_c1[1]*column0[IMG_HEIGHT-ptr1]   + kernel_c2[1]*column1[IMG_HEIGHT-ptr1]   +
                        kernel_c0[0]*column3[IMG_HEIGHT-1-ptr1] + kernel_c1[0]*column0[IMG_HEIGHT-1-ptr1] + kernel_c2[0]*column1[IMG_HEIGHT-1-ptr1];
        ptr1 = ptr1+1;
        if(ptr1 == 480)begin
            for(ptr2=0;ptr2<IMG_HEIGHT;ptr2=ptr2+1)                                                  // Se realiza la carga de la
                column2[IMG_HEIGHT-ptr2] <= i_col[(IMG_HEIGHT*IMG_NB-ptr2*IMG_NB)-1 -: IMG_NB];      // columna 2
            ptr1 = 0;
            control         <= 3'd1;
        end
    end
end

assign o_new_pixel = new_pixel;

endmodule
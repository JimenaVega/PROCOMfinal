`timescale 1ns / 1ps

module Convolution
  #(parameter IMG_HEIGHT  = 120,
    parameter IMG_NB      = 7,
    parameter KERNEL_SIZE = 3,
    parameter KERNEL_NB   = 8
    )
   (input  clock,
    input  i_reset,
    input  [(IMG_HEIGHT*IMG_NB)-1:0] i_col,
    input  [(KERNEL_SIZE*KERNEL_SIZE*KERNEL_NB)-1:0] i_kernel,
    input  i_control,
    output [9119:0]o_new_column
    );
    
reg signed [IMG_NB-1:0]  column0   [IMG_HEIGHT+1 :0];
reg signed [IMG_NB-1:0]  column1   [IMG_HEIGHT+1 :0];
reg signed [IMG_NB-1:0]  column2   [IMG_HEIGHT+1 :0];
reg signed [IMG_NB-1:0]  column3   [IMG_HEIGHT+1 :0];

//reg signed [18:0] new_column[IMG_HEIGHT-1 :0];
reg signed [9119:0] new_column;

reg signed [KERNEL_NB-1:0]  kernel_c0 [KERNEL_SIZE-1:0];
reg signed [KERNEL_NB-1:0]  kernel_c1 [KERNEL_SIZE-1:0];
reg signed [KERNEL_NB-1:0]  kernel_c2 [KERNEL_SIZE-1:0];

reg [2:0] control;
reg [1:0] counter;
reg ready_for_conv;

assign o_new_column = new_column;

integer ptr;
integer ptr1;
integer ptr2;

always@(posedge clock)begin
    if(i_reset)begin:reset              // En el reset se setea:
                                        //        integer ptr;
        counter        <= 2'd0;         // contador de posicion en columna a cero
        control        <= 3'd6;
        ready_for_conv <= 1'd0;   
        
        column0[IMG_HEIGHT+1] <= 7'd0;           // Primer y ultimo pixel de cada columna a cero (zero padding)
        column0[0]            <= 7'd0;
        
        column1[IMG_HEIGHT+1] <= 7'd0;
        column1[0]            <= 7'd0;
        
        column2[IMG_HEIGHT+1] <= 7'd0;
        column2[0]            <= 7'd0;
        
        column3[IMG_HEIGHT+1] <= 7'd0;
        column3[0]            <= 7'd0;
        
//        for(ptr=0;ptr<KERNEL_SIZE;ptr=ptr+1)begin
//            kernel_c0[KERNEL_SIZE-1-ptr] <= i_kernel[(KERNEL_SIZE*KERNEL_SIZE*KERNEL_NB)-1-(ptr*KERNEL_SIZE)  *KERNEL_NB -: KERNEL_NB];
//            kernel_c1[KERNEL_SIZE-1-ptr] <= i_kernel[(KERNEL_SIZE*KERNEL_SIZE*KERNEL_NB)-1-(ptr*KERNEL_SIZE+1)*KERNEL_NB -: KERNEL_NB];
//            kernel_c2[KERNEL_SIZE-1-ptr] <= i_kernel[(KERNEL_SIZE*KERNEL_SIZE*KERNEL_NB)-1-(ptr*KERNEL_SIZE+2)*KERNEL_NB -: KERNEL_NB];
//        end
        
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
    else if(control == 5)begin:filling_columns_0_1_2                             // Se realiza la carga de las columnas
                                                                                // 0, 1 y 2
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
            control <= 3'd0;
        end
        else begin
            counter <= counter+1;
            control <= 3'd6;
        end
    end
    else if(control == 1 && ready_for_conv)begin:conv0
        
        
        for(ptr1=0;ptr1<IMG_HEIGHT;ptr1=ptr1+1)begin    // Se hace la convolucion del kernel con las columnas 0, 1 y 2
            new_column[(IMG_HEIGHT-1)-ptr1] <= kernel_c0[2]*column0[IMG_HEIGHT+1-ptr1] + kernel_c1[2]*column1[IMG_HEIGHT+1-ptr1] + kernel_c2[2]*column2[IMG_HEIGHT+1-ptr1] +
                                               kernel_c0[1]*column0[IMG_HEIGHT-ptr1]   + kernel_c1[1]*column1[IMG_HEIGHT-ptr1]   + kernel_c2[1]*column2[IMG_HEIGHT-ptr1]   +
                                               kernel_c0[0]*column0[IMG_HEIGHT-1-ptr1] + kernel_c1[0]*column1[IMG_HEIGHT-1-ptr1] + kernel_c2[0]*column2[IMG_HEIGHT-1-ptr1];
        end
        
        for(ptr2=0;ptr2<IMG_HEIGHT;ptr2=ptr2+1)                                                 // Se realiza la carga de la
            column3[IMG_HEIGHT-ptr2] <= i_col[(IMG_HEIGHT*IMG_NB-ptr2*IMG_NB)-1 -: IMG_NB];     // columna 3
        
        ready_for_conv <= 1'd0;
    end
    else if(control == 2 && ready_for_conv)begin:conv1
        
        for(ptr1=0;ptr1<IMG_HEIGHT;ptr1=ptr1+1)begin    // Se hace la convolucion del kernel con las columnas 1, 2 y 3
            new_column[(IMG_HEIGHT-1)-ptr1] <= kernel_c0[2]*column1[IMG_HEIGHT+1-ptr1] + kernel_c1[2]*column2[IMG_HEIGHT+1-ptr1] + kernel_c2[2]*column3[IMG_HEIGHT+1-ptr1] +
                                               kernel_c0[1]*column1[IMG_HEIGHT-ptr1]   + kernel_c1[1]*column2[IMG_HEIGHT-ptr1]   + kernel_c2[1]*column3[IMG_HEIGHT-ptr1]   +
                                               kernel_c0[0]*column1[IMG_HEIGHT-1-ptr1] + kernel_c1[0]*column2[IMG_HEIGHT-1-ptr1] + kernel_c2[0]*column3[IMG_HEIGHT-1-ptr1];
        end
        
        for(ptr2=0;ptr2<IMG_HEIGHT;ptr2=ptr2+1)                                                 // Se realiza la carga de la
            column0[IMG_HEIGHT-ptr2] <= i_col[(IMG_HEIGHT*IMG_NB-ptr2*IMG_NB)-1 -: IMG_NB];     // columna 0
        
        ready_for_conv <= 1'd0;
    end
    else if(control == 3 && ready_for_conv)begin:conv2
        
        for(ptr1=0;ptr1<IMG_HEIGHT;ptr1=ptr1+1)begin    // Se hace la convolucion del kernel con las columnas 2, 3 y 0
            new_column[(IMG_HEIGHT-1)-ptr1] <= kernel_c0[2]*column2[IMG_HEIGHT+1-ptr1] + kernel_c1[2]*column3[IMG_HEIGHT+1-ptr1] + kernel_c2[2]*column0[IMG_HEIGHT+1-ptr1] +
                                               kernel_c0[1]*column2[IMG_HEIGHT-ptr1]   + kernel_c1[1]*column3[IMG_HEIGHT-ptr1]   + kernel_c2[1]*column0[IMG_HEIGHT-ptr1]   +
                                               kernel_c0[0]*column2[IMG_HEIGHT-1-ptr1] + kernel_c1[0]*column3[IMG_HEIGHT-1-ptr1] + kernel_c2[0]*column0[IMG_HEIGHT-1-ptr1];
        end
        
        for(ptr2=0;ptr2<IMG_HEIGHT;ptr2=ptr2+1)                                                 // Se realiza la carga de la
            column1[IMG_HEIGHT-ptr2] <= i_col[(IMG_HEIGHT*IMG_NB-ptr2*IMG_NB)-1 -: IMG_NB];     // columna 1
        
        ready_for_conv <= 1'd0;
    end
    else if(control == 4 && ready_for_conv)begin:conv3
        
        for(ptr1=0;ptr1<IMG_HEIGHT;ptr1=ptr1+1)begin    // Se hace la convolucion del kernel con las columnas 3, 0 y 1
            new_column[(IMG_HEIGHT-1)-ptr1] <= kernel_c0[2]*column3[IMG_HEIGHT+1-ptr1] + kernel_c1[2]*column0[IMG_HEIGHT+1-ptr1] + kernel_c2[2]*column1[IMG_HEIGHT+1-ptr1] +
                                               kernel_c0[1]*column3[IMG_HEIGHT-ptr1]   + kernel_c1[1]*column0[IMG_HEIGHT-ptr1]   + kernel_c2[1]*column1[IMG_HEIGHT-ptr1]   +
                                               kernel_c0[0]*column3[IMG_HEIGHT-1-ptr1] + kernel_c1[0]*column0[IMG_HEIGHT-1-ptr1] + kernel_c2[0]*column1[IMG_HEIGHT-1-ptr1];
        end
        
        for(ptr2=0;ptr2<IMG_HEIGHT;ptr2=ptr2+1)                                                  // Se realiza la carga de la
            column2[IMG_HEIGHT-ptr2] <= i_col[(IMG_HEIGHT*IMG_NB-ptr2*IMG_NB)-1 -: IMG_NB];      // columna 2
        
        ready_for_conv <= 1'd0;
        control        <= 3'd0;
    end
end

//always@(posedge clock)begin
//    if(control == 5)begin:filling_columns_0_1_2                                // Se realiza la carga de las columnas
//                                                                                // 0, 1 y 2
//        for(ptr=0;ptr<IMG_HEIGHT;ptr=ptr+1)begin
//            if(counter == 0)
//                column0[IMG_HEIGHT-ptr] <= i_col[(IMG_HEIGHT*IMG_NB-ptr*IMG_NB)-1 -: IMG_NB];
//            else if(counter == 1)
//                column1[IMG_HEIGHT-ptr] <= i_col[(IMG_HEIGHT*IMG_NB-ptr*IMG_NB)-1 -: IMG_NB];
//            else if(counter == 2)
//                column2[IMG_HEIGHT-ptr] <= i_col[(IMG_HEIGHT*IMG_NB-ptr*IMG_NB)-1 -: IMG_NB];
//        end
//        if(counter == 2)begin
//            counter <= 2'd0;
//            control <= 3'd0;
//        end
//        else begin
//            counter <= counter+1;
//            control <= 3'd6;
//        end
//    end
//end

//always@(posedge clock)begin
//    if(control == 1 && ready_for_conv)begin:conv0
        
        
//        for(ptr1=0;ptr1<IMG_HEIGHT;ptr1=ptr1+1)begin    // Se hace la convolucion del kernel con las columnas 0, 1 y 2
//            new_column[(IMG_HEIGHT-1)-ptr1] <= kernel_c0[2]*column0[IMG_HEIGHT+1-ptr1] + kernel_c1[2]*column1[IMG_HEIGHT+1-ptr1] + kernel_c2[2]*column2[IMG_HEIGHT+1-ptr1] +
//                                               kernel_c0[1]*column0[IMG_HEIGHT-ptr1]   + kernel_c1[1]*column1[IMG_HEIGHT-ptr1]   + kernel_c2[1]*column2[IMG_HEIGHT-ptr1]   +
//                                               kernel_c0[0]*column0[IMG_HEIGHT-1-ptr1] + kernel_c1[0]*column1[IMG_HEIGHT-1-ptr1] + kernel_c2[0]*column2[IMG_HEIGHT-1-ptr1];
//        end
        
//        for(ptr2=0;ptr2<IMG_HEIGHT;ptr2=ptr2+1)                                                 // Se realiza la carga de la
//            column3[IMG_HEIGHT-ptr2] <= i_col[(IMG_HEIGHT*IMG_NB-ptr2*IMG_NB)-1 -: IMG_NB];     // columna 3
        
//        ready_for_conv <= 1'd0;
//    end
//end

//always@(posedge clock)begin
//    if(control == 2 && ready_for_conv)begin:conv1
        
//        for(ptr1=0;ptr1<IMG_HEIGHT;ptr1=ptr1+1)begin    // Se hace la convolucion del kernel con las columnas 1, 2 y 3
//            new_column[(IMG_HEIGHT-1)-ptr1] <= kernel_c0[2]*column1[IMG_HEIGHT+1-ptr1] + kernel_c1[2]*column2[IMG_HEIGHT+1-ptr1] + kernel_c2[2]*column3[IMG_HEIGHT+1-ptr1] +
//                                               kernel_c0[1]*column1[IMG_HEIGHT-ptr1]   + kernel_c1[1]*column2[IMG_HEIGHT-ptr1]   + kernel_c2[1]*column3[IMG_HEIGHT-ptr1]   +
//                                               kernel_c0[0]*column1[IMG_HEIGHT-1-ptr1] + kernel_c1[0]*column2[IMG_HEIGHT-1-ptr1] + kernel_c2[0]*column3[IMG_HEIGHT-1-ptr1];
//        end
        
//        for(ptr2=0;ptr2<IMG_HEIGHT;ptr2=ptr2+1)                                                 // Se realiza la carga de la
//            column0[IMG_HEIGHT-ptr2] <= i_col[(IMG_HEIGHT*IMG_NB-ptr2*IMG_NB)-1 -: IMG_NB];     // columna 0
        
//        ready_for_conv <= 1'd0;
//    end
//end

//always@(posedge clock)begin
//    if(control == 3 && ready_for_conv)begin:conv2
        
//        for(ptr1=0;ptr1<IMG_HEIGHT;ptr1=ptr1+1)begin    // Se hace la convolucion del kernel con las columnas 2, 3 y 0
//            new_column[(IMG_HEIGHT-1)-ptr1] <= kernel_c0[2]*column2[IMG_HEIGHT+1-ptr1] + kernel_c1[2]*column3[IMG_HEIGHT+1-ptr1] + kernel_c2[2]*column0[IMG_HEIGHT+1-ptr1] +
//                                               kernel_c0[1]*column2[IMG_HEIGHT-ptr1]   + kernel_c1[1]*column3[IMG_HEIGHT-ptr1]   + kernel_c2[1]*column0[IMG_HEIGHT-ptr1]   +
//                                               kernel_c0[0]*column2[IMG_HEIGHT-1-ptr1] + kernel_c1[0]*column3[IMG_HEIGHT-1-ptr1] + kernel_c2[0]*column0[IMG_HEIGHT-1-ptr1];
//        end
        
//        for(ptr2=0;ptr2<IMG_HEIGHT;ptr2=ptr2+1)                                                 // Se realiza la carga de la
//            column1[IMG_HEIGHT-ptr2] <= i_col[(IMG_HEIGHT*IMG_NB-ptr2*IMG_NB)-1 -: IMG_NB];     // columna 1
        
//        ready_for_conv <= 1'd0;
//    end
//end

//always@(posedge clock)begin
//    if(control == 4 && ready_for_conv)begin:conv3
        
//        for(ptr1=0;ptr1<IMG_HEIGHT;ptr1=ptr1+1)begin    // Se hace la convolucion del kernel con las columnas 3, 0 y 1
//            new_column[(IMG_HEIGHT-1)-ptr1] <= kernel_c0[2]*column3[IMG_HEIGHT+1-ptr1] + kernel_c1[2]*column0[IMG_HEIGHT+1-ptr1] + kernel_c2[2]*column1[IMG_HEIGHT+1-ptr1] +
//                                               kernel_c0[1]*column3[IMG_HEIGHT-ptr1]   + kernel_c1[1]*column0[IMG_HEIGHT-ptr1]   + kernel_c2[1]*column1[IMG_HEIGHT-ptr1]   +
//                                               kernel_c0[0]*column3[IMG_HEIGHT-1-ptr1] + kernel_c1[0]*column0[IMG_HEIGHT-1-ptr1] + kernel_c2[0]*column1[IMG_HEIGHT-1-ptr1];
//        end
        
//        for(ptr2=0;ptr2<IMG_HEIGHT;ptr2=ptr2+1)                                                  // Se realiza la carga de la
//            column2[IMG_HEIGHT-ptr2] <= i_col[(IMG_HEIGHT*IMG_NB-ptr2*IMG_NB)-1 -: IMG_NB];      // columna 2
        
//        ready_for_conv <= 1'd0;
//        control        <= 3'd0;
//    end
//end

//always@(posedge i_control)begin
//    ready_for_conv <= 1'd1;
//    if(control == 6)
//        control <= 3'd5;
//    else begin
//        control <= control+1;
//    end
//end

endmodule
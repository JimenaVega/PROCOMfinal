`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.10.2020 11:21:31
// Design Name: 
// Module Name: xtremeSearch
// Project Name: 
// Description: 
// Recibe cada resultado de 19 bits provenientes del modulo de convolucion,
// los compara y encunetra el mayor y el menor resultado. 
// El resultado es exteriorizado una vez que se corroboraron todos 
// los pixeles de la imagen. En ese momento tambien se activa un flag llamado
// valid que indica que termino el proceso de comparacion.
// 
//////////////////////////////////////////////////////////////////////////////////


module xtremeSearch
   #(
    parameter NB_PIXEL = 19,
    parameter NB_COUNT = 32
    )(
    input  clock,
    input  reset,
    input  i_valid,
    input  [NB_COUNT - 1 : 0]i_imageSize, //ROW*COL de la imagen orignal
    input  signed [NB_PIXEL - 1 : 0]i_convValue, //pixel resultado de la convolucion
    output signed [NB_PIXEL - 1 : 0]o_maxValue,
    output signed [NB_PIXEL - 1 : 0]o_minValue,
    output o_endSignal
   
    );
   
reg signed [NB_PIXEL - 1 : 0]maxPixelReg;
reg signed [NB_PIXEL - 1 : 0]minPixelReg;
reg signed [NB_COUNT - 1 : 0]imSizeReg;
reg signed [NB_COUNT - 1 : 0]counter;


always@ (posedge clock) begin
    if (reset)begin
        maxPixelReg <= (1 << (NB_PIXEL - 1));  // Numero mas chico del rango -2^(NB_PIXEL-1)
        minPixelReg <= {(NB_PIXEL - 1){1'b1}}; //Numero mas grande del rango +2^(NB_PIXEL-1) - 1
        counter     <= {NB_COUNT{1'b0}};
        imSizeReg   <= i_imageSize;
   
    end
    else begin
        if (i_convValue > maxPixelReg) begin
            maxPixelReg <= i_convValue;
        end
        if (minPixelReg > i_convValue) begin
            minPixelReg <= i_convValue;
         
        end
    end
    if ( counter < imSizeReg) begin 
        counter <= counter + 1; //control para que pasen todos los pix de la imgen
    end
    else begin
        counter <= {NB_COUNT{1'b0}};
    end
end //always

assign o_endSignal = ( counter < (imSizeReg-1) ) ? 0 : 1;
assign o_maxValue = ( i_valid ) ? maxPixelReg : {NB_PIXEL{1'b0}};
assign o_minValue = ( i_valid ) ? minPixelReg : {NB_PIXEL{1'b0}};

endmodule

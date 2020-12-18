`timescale 1 ns / 1 ps

	module convolution_v1_0 #
(
    parameter ADDR_WIDTH         = 12,
    parameter C_AXIS_TDATA_WIDTH = 32,
    parameter PIXEL_NB           = 9,
    parameter RESULT_NB          = 19,
    parameter COUNTER_NB         = 2,
    parameter COUNTER1_NB        = 4,
    parameter KERNEL_SIZE        = 3,
    parameter KERNEL_NB          = 8
)
(
    /*
     * AXI slave interface (input to the CONV MODULE)
     */
    input  wire                   s00_axis_aclk,
    input  wire                   s00_axis_aresetn,
    input  wire [C_AXIS_TDATA_WIDTH-1:0]     s00_axis_tdata,
    input  wire [(C_AXIS_TDATA_WIDTH/8)-1:0] s00_axis_tstrb,
    input  wire                   s00_axis_tvalid,
    output wire                   s00_axis_tready,              //se queda en x en la simulación. POR QUE?
    input  wire                   s00_axis_tlast,
    
    /*
     * AXI master interface (output of the CONV MODULE)
     */
    input  wire                   m00_axis_aclk,
    input  wire                   m00_axis_aresetn,
    output wire [C_AXIS_TDATA_WIDTH-1:0]     m00_axis_tdata,
    output wire [(C_AXIS_TDATA_WIDTH/8)-1:0] m00_axis_tstrb,
    output wire                   m00_axis_tvalid,
    input  wire                   m00_axis_tready,
    output wire                   m00_axis_tlast
);

localparam FULL       = 2'h2;           //full del counter general 
localparam FULL1      = 4'h9;           //full del counter para la primera carga

//Reset sync registers
reg s00_rst_sync1_reg = 1'b1;
reg s00_rst_sync2_reg = 1'b1;
reg s00_rst_sync3_reg = 1'b1;
reg m00_rst_sync1_reg = 1'b1;
reg m00_rst_sync2_reg = 1'b1;
reg m00_rst_sync3_reg = 1'b1;

//Convolution registers
reg   signed [PIXEL_NB-1  :0]   shift  [(KERNEL_SIZE*KERNEL_SIZE)-1 : 0];
reg   signed [KERNEL_NB-1 :0]   kernel [(KERNEL_SIZE*KERNEL_SIZE)-1 : 0];
wire  signed [RESULT_NB-1 :0]   result0;
wire  signed [RESULT_NB-1 :0]   result1;
wire  signed [RESULT_NB-1 :0]   result2;
reg   signed [RESULT_NB-1 :0]   add_tmp;
reg          [COUNTER_NB-1:0]   counter; 
reg          [COUNTER1_NB-1:0]  first_counter; 
reg   signed [RESULT_NB-1 :0]   o_pixel_reg;
integer ptr;
integer ptr1;

wire         [(PIXEL_NB-1)-1 :0] final_o_pixel;

//AXI registers
reg  m00_axis_tvalid_reg  = 1'b0;
reg  s00_axis_tlast_reg   = 1'b0;
reg  m00_axis_tlast_reg   = 1'b0;

//Read data
reg [C_AXIS_TDATA_WIDTH-1:0] read_data_reg = {C_AXIS_TDATA_WIDTH{1'b0}};

//Banderas indicadoras del estado de los bits necesarios para hacer la convolucion 
wire full       = (counter == FULL ) ? 1'b1 : 1'b0;
wire empty      = (counter == FULL ) ? 1'b0 : 1'b1;
reg  first_load =  1'b1;
//Señales de control, habilitan los procesos correspondientes
reg write;          
reg read;           
reg store_output;   

//Assigns de las salidas AXI del módulo
assign s00_axis_tready = ~full & ~s00_rst_sync3_reg; //listo para recibir cuando no están todos los datos necesarios y no se presiono el reset 
assign m00_axis_tvalid = m00_axis_tvalid_reg;
assign m00_axis_tlast  = m00_axis_tlast_reg;
assign m00_axis_tdata  = read_data_reg;

//Assigns de lor wire internos al módulo
assign o_pixel_wire    = o_pixel_reg; //VERIFICAR SI SE USA
assign final_o_pixel   = (o_pixel_reg > 255) ? 8'd255 : 
                         (o_pixel_reg < 0)   ? 8'd0   :
                          o_pixel_reg;


/***************************************** SINCRONIZAR RESET **************************************************/
//Reset synchronization de master y slave 
//Al final se usan s00_rst_sync3_reg y m00_rst_sync3_reg 
always @(posedge s00_axis_aclk) begin
    if (!s00_axis_aresetn) begin        //en caso de señal de reset en el slave 
        s00_rst_sync1_reg <= 1'b1;      
        s00_rst_sync2_reg <= 1'b1;
        s00_rst_sync3_reg <= 1'b1;
    end else begin
        s00_rst_sync1_reg <= 1'b0;
        s00_rst_sync2_reg <= s00_rst_sync1_reg | m00_rst_sync1_reg;
        s00_rst_sync3_reg <= s00_rst_sync2_reg;
    end
end

always @(posedge m00_axis_aclk) begin
    if (!m00_axis_aresetn) begin        //en caso de señal de reset en el master 
        m00_rst_sync1_reg <= 1'b1;
        m00_rst_sync2_reg <= 1'b1;
        m00_rst_sync3_reg <= 1'b1;
    end else begin
        m00_rst_sync1_reg <= 1'b0;
        m00_rst_sync2_reg <= s00_rst_sync1_reg | m00_rst_sync1_reg;
        m00_rst_sync3_reg <= m00_rst_sync2_reg;
    end
end

/************************************ FIN SINCRONIZAR RESET **************************************************/

/************************************* COMBINATIONAL LOGIC **************************************************/
//Write logic
/*
    En caso de input de data valid, se verifica si se tienen todos los datos necesarios.
    Si no se tienen todos, se habilita la recepción de datos o "write"
*/ 
always @* begin
    write = 1'b0;   
    if (s00_axis_tvalid) begin                                      
        if (empty) begin        
            write = 1'b1;  
        end
        else if (first_load) begin
            write = 1'b1;
        end                                          
    end
end

//Read logic
/*
    Verifica que este habilitado store output y el read data valid.
    En caso que estén en alto, se verifica que se tenga el resultado disponible.
    Si está disponible (full en alto) se habilita el read  
*/
always @* begin
    read = 1'b0;
    if (store_output & m00_axis_tvalid) begin
        if (full) begin                         //cuando full esta en alto, el resultado está listo => la DMA puede leer el dato de salida 
            read = 1'b1;                        //se levanta la bandera de habilitacion de la lectura
        end 
    end
end

// Output logic
/*
    Se verifica que el master tenga en alto el data valid y la DMA el ready.
    Se pone en alto la bandera de store output para indicar que se puede leer el dato.
*/
always @* begin
    store_output = 1'b0;
    if (m00_axis_tready & m00_axis_tvalid) begin               //tanto el valid como el ready tienen que estar en alto, de esta forma, la or da 1
        store_output = 1'b1;   
    end
end

/************************************* FIN COMBINATIONAL LOGIC **************************************************/

/************************************************* CONVOLUCIÓN **************************************************/
always@(posedge s00_axis_aclk)begin
    kernel[8] <= {8{1'b1}};
    kernel[7] <= {8{1'b1}};
    kernel[6] <= {8{1'b1}};
    kernel[5] <= {8{1'b1}};
    kernel[4] <=  8'h8;
    kernel[3] <= {8{1'b1}};
    kernel[2] <= {8{1'b1}};
    kernel[1] <= {8{1'b1}};
    kernel[0] <= {8{1'b1}};
    
    if(s00_rst_sync3_reg)begin
        counter       <= 2'd0; 
        first_counter <= 4'd0;       
        for(ptr = 0; ptr < KERNEL_SIZE*KERNEL_SIZE; ptr = ptr + 1)begin
            shift[ptr] <= 9'd0;
        end    
    end
    else begin 
        s00_axis_tlast_reg <= s00_axis_tlast;
        shift[8]           <= s00_axis_tdata[PIXEL_NB-1:0];
        
        if (s00_axis_tlast)begin
            first_load = 1'b1;
        end
        
        for(ptr = 0; ptr < (KERNEL_SIZE*KERNEL_SIZE)-1; ptr = ptr + 1)begin
            shift[ptr] <= shift[ptr+1];
        end
        //primera carga: 9 datos 
        if (first_load) begin 
            counter           <= 2'd0;
            if (first_counter != FULL1) begin 
                first_counter <= first_counter+1;
                first_load    <= first_load;
            end
            else begin 
                first_counter <= 4'd0;
                first_load    <= 1'b0;
                o_pixel_reg   <= result0 + result1 + result2;
            end
        end
        //carga general: 3 datos 
        else begin 
            first_counter   <= 4'd0;
            if (counter != FULL) begin        
            counter     <= counter+1;
            end
            else begin
            counter     <= 2'd0;
            o_pixel_reg <= result0 + result1 + result2;
            end   
        end      
        //
        if (~write) begin
            counter              <= 2'd0;
            first_counter        <= 4'd0;
        end
    end
end

//Se asignan los resultados, se cambia el reg por el wire para evitar el desfasaje de la salida 
assign result0  = shift[0]*kernel[0] + shift[1]*kernel[1] + shift[2]*kernel[2];
assign result1  = shift[3]*kernel[3] + shift[4]*kernel[4] + shift[5]*kernel[5];
assign result2  = shift[6]*kernel[6] + shift[7]*kernel[7] + shift[8]*kernel[8];

/************************************* FIN CONVOLUCIÓN ******************************************************/

/*********************************** DEVOLVER EL DATO *******************************************************/
//Determinación del valor a almacenar en el registro read data y el data valid a enviar a la DMA 
/*
    En caso en que el read esté en alto se almacena el dato en read data reg.
    Esto no pasa si está en alto endSignal, indicando que ya se tienen los valores maximos y minimos 
*/
always @(posedge m00_axis_aclk) begin
    if (read) begin
        m00_axis_tlast_reg <= s00_axis_tlast_reg;
        read_data_reg      <= o_pixel_reg;
    end
end

//Se determina el valid final y si se asigna el dato al master o todavía no
/*
    En caso en que esté en alto, se pasa el dato al registro correspondiente 
*/
always @(posedge m00_axis_aclk) begin
    if (m00_rst_sync3_reg) begin
        m00_axis_tvalid_reg <= 1'b0;                     
    end else begin
        m00_axis_tvalid_reg <= 1'b1;    
    end
end

/******************************* FIN DEVOLVER EL DATO *******************************************************/

endmodule
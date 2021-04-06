`timescale 1 ns / 1 ps

module convolution_v1_0 #

(
    parameter ADDR_WIDTH         = 12,
    parameter C_AXIS_TDATA_WIDTH = 32,
    parameter PIXEL_NB           = 9,
    parameter RESULT_NB          = 12,
    parameter COUNTER_NB         = 2,
    parameter COUNTER1_NB        = 2,
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
    input  wire                   s00_axis_tvalid,
    output wire                   s00_axis_tready,              //se queda en x en la simulación. POR QUE?
    input  wire                   s00_axis_tlast,
    
    /*
     * AXI master interface (output of the CONV MODULE)
     */
    input  wire                   m00_axis_aclk,
    input  wire                   m00_axis_aresetn,
    output wire [C_AXIS_TDATA_WIDTH-1:0]     m00_axis_tdata,
    output wire                   m00_axis_tvalid,
    input  wire                   m00_axis_tready,
    output wire                   m00_axis_tlast
);

localparam FULL       = 2'd2;           //full del counter general 

//Reset sync registers
reg s00_rst_sync1_reg = 1'b1;
reg s00_rst_sync2_reg = 1'b1;
reg s00_rst_sync3_reg = 1'b1;
reg m00_rst_sync1_reg = 1'b1;
reg m00_rst_sync2_reg = 1'b1;
reg m00_rst_sync3_reg = 1'b1;

//Convolution registers
reg   signed [PIXEL_NB-1 :0]     shift  [(KERNEL_SIZE*KERNEL_SIZE)-1 : 0];
reg   signed [KERNEL_NB-1 :0]    kernel [(KERNEL_SIZE*KERNEL_SIZE)-1 : 0];
reg   signed [RESULT_NB-1 :0]    result0 = 12'd0;
reg   signed [RESULT_NB-1 :0]    result1 = 12'd0;
reg   signed [RESULT_NB-1 :0]    result2 = 12'd0;
reg          [COUNTER_NB-1:0]    counter; 
wire  signed [RESULT_NB-1 :0]    o_pixel;
integer ptr;

//AXI registers
reg  s00_axis_tlast_reg   = 1'b0;
reg  m00_axis_tlast_reg   = 1'b0;
reg  m00_tlast_reg        = 1'b0;
reg [C_AXIS_TDATA_WIDTH-1:0] m00_data_reg = {C_AXIS_TDATA_WIDTH{1'b0}};
reg  read_data_valid_reg  = 1'b0;
reg  read_data_valid_next = 1'b0;
reg  m00_axis_tvalid_reg  = 1'b0;
reg  m00_axis_tvalid_next = 1'b0;

//Read/Write data
reg [C_AXIS_TDATA_WIDTH-1:0] read_data_reg = {C_AXIS_TDATA_WIDTH{1'b0}};     

//Señales de control, habilitan los procesos correspondientes
reg  write         =  1'b0;          
reg  read          =  1'b0;
reg  full          =  1'b0;
reg  store_output  =  1'b0;

//Assigns de las salidas AXI del módulo
assign s00_axis_tready = s00_axis_tvalid & ~s00_rst_sync3_reg; //listo para recibir cuando no están todos los datos necesarios y no se presiono el reset 
assign m00_axis_tvalid = m00_axis_tvalid_reg;
assign m00_axis_tlast  = m00_tlast_reg;
assign m00_axis_tdata  = m00_data_reg;

//Inicializacion del kernel
 
initial kernel[8] = {8{1'b0}};
initial kernel[7] = {8{1'b0}};
initial kernel[6] = {8{1'b0}};
initial kernel[5] = {8{1'b0}};
initial kernel[4] =  8'd1;
initial kernel[3] = {8{1'b0}};
initial kernel[2] = {8{1'b0}};
initial kernel[1] = {8{1'b0}};
initial kernel[0] = {8{1'b0}};
/*
initial kernel[8] = {8{1'b1}};
initial kernel[7] = {8{1'b1}};
initial kernel[6] = {8{1'b1}};
initial kernel[5] = {8{1'b1}};
initial kernel[4] =  8'd8;
initial kernel[3] = {8{1'b1}};
initial kernel[2] = {8{1'b1}};
initial kernel[1] = {8{1'b1}};
initial kernel[0] = {8{1'b1}};
*/

//inicializacion shift 
initial shift[8] = {PIXEL_NB{1'b0}};
initial shift[7] = {PIXEL_NB{1'b0}};
initial shift[6] = {PIXEL_NB{1'b0}};
initial shift[5] = {PIXEL_NB{1'b0}};
initial shift[4] = {PIXEL_NB{1'b0}};
initial shift[3] = {PIXEL_NB{1'b0}};
initial shift[2] = {PIXEL_NB{1'b0}};
initial shift[1] = {PIXEL_NB{1'b0}};
initial shift[0] = {PIXEL_NB{1'b0}};

//inicializacion contador 
initial counter       = 2'd3;

/***************************************** SINCRONIZAR RESET **************************************************/
always @(posedge s00_axis_aclk) begin
    if (!s00_axis_aresetn) begin        
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
    if (!m00_axis_aresetn) begin       
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
//Write
always @* begin
    write     = 1'b0;    
    if (s00_axis_tvalid) begin
        write = 1'b1;  
    end
end 

//Full
always @(posedge s00_axis_aclk) begin
    if(s00_rst_sync3_reg )begin
        full <= 1'b0; 
    end
    else if (counter == FULL) begin 
        full <= 1'b1;
    end
    else begin 
        full <= full;
    end
end

//Read 
always @* begin
    read = 1'b0;
    read_data_valid_next = read_data_valid_reg;
    if (store_output) begin
        if (full) begin
            read = 1'b1;
            read_data_valid_next = 1'b1;
        end else begin
            read_data_valid_next = 1'b0;
        end
    end
end

// Output register
always @* begin
    store_output = 1'b0;
    m00_axis_tvalid_next = m00_axis_tvalid_reg;
    
    if (m00_axis_tready | ~m00_axis_tvalid) begin
        store_output         = 1'b1;
        m00_axis_tvalid_next = read_data_valid_reg;
    end
end

/************************************* FIN COMBINATIONAL LOGIC **************************************************/

/************************************************* CONVOLUCIÓN **************************************************/
always@(posedge s00_axis_aclk)begin        
    if(s00_rst_sync3_reg )begin
        counter            <= 2'd3;  
        
        result0            <= 12'd0;
        result1            <= 12'd0;
        result2            <= 12'd0;
        
        s00_axis_tlast_reg <= 1'b0;
        
        for(ptr = 0; ptr < KERNEL_SIZE*KERNEL_SIZE; ptr = ptr + 1)begin
            shift[ptr]     <= 9'd0;
        end     
    end
    
    else begin                
        if (full) begin
            result0 <= shift[0]*kernel[0] + shift[1]*kernel[1] + shift[2]*kernel[2];
            result1 <= shift[3]*kernel[3] + shift[4]*kernel[4] + shift[5]*kernel[5];
            result2 <= shift[6]*kernel[6] + shift[7]*kernel[7] + shift[8]*kernel[8];
        end 
        else begin
            result0 <= result0; 
            result1 <= result1; 
            result2 <= result2;       
        end
         
        if (write) begin
            s00_axis_tlast_reg <= s00_axis_tlast;
            
            for(ptr = 0; ptr < (KERNEL_SIZE*KERNEL_SIZE)-1; ptr = ptr + 1)begin
                shift[ptr] <= shift[ptr+3];
            end  
           
           //carga de los datos entrantes, de a 3
            shift[6]       <= s00_axis_tdata[7:0]  ;
            shift[7]       <= s00_axis_tdata[15:8] ;
            shift[8]       <= s00_axis_tdata[23:16];                   
            counter        <= 2'd2;
               
        end 
    end
end

assign o_pixel = result0 + result1 + result2;

/************************************* FIN CONVOLUCIÓN ******************************************************/

/*********************************** DEVOLVER EL DATO *******************************************************/
always @(posedge m00_axis_aclk) begin   
    if (m00_rst_sync3_reg) begin
        read_data_valid_reg <= 1'b0;
    end else begin
        read_data_valid_reg <= read_data_valid_next;
    end
    
    if (read) begin
        m00_axis_tlast_reg <= s00_axis_tlast_reg;
                
        if (o_pixel > 255)begin
            read_data_reg  <= 32'd255;
        end
        else if (o_pixel < 0)begin
            read_data_reg  <= 32'd0;
        end
        else begin 
            read_data_reg  <= o_pixel;
        end  
    end
    else begin 
        m00_axis_tlast_reg <= m00_axis_tlast_reg;
        read_data_reg      <= read_data_reg;
    end 
end
    
always @(posedge m00_axis_aclk) begin
    if (m00_rst_sync3_reg) begin
        m00_axis_tvalid_reg <= 1'b0;                     
    end else begin
        m00_axis_tvalid_reg <= m00_axis_tvalid_next;    
    end
    
    if (store_output) begin
        m00_tlast_reg <= m00_axis_tlast_reg;
        m00_data_reg  <= read_data_reg;
    end
end

/******************************* FIN DEVOLVER EL DATO *******************************************************/

endmodule
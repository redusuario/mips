`timescale 1ns / 1ps

module rx
    #(
        parameter       CLK_FR     = 50000000,  
        parameter       BAUD_RATE    = 9600, 
        parameter       DIV_SAMPLE   = 16, //oversampling,16 veces la tasa de baudios 
        parameter       DBIT    = 8 
    )
    (
        input   wire                        i_clk,
        input   wire                        i_reset,
        input   wire                        i_rx_bit,
        output  wire                        o_ready,
        output  wire   [DBIT-1    :0]       o_data
    );
    
    //Estados
    localparam     IDLE                = 1'b0;
    localparam     RECEIVING           = 1'b1;
    
    //Parametros locales    
    localparam     BIT_COUNTER_SIZE    = $clog2(DBIT+1); //para contener bitcounter
    localparam     DIV_COUNTER         = CLK_FR/(BAUD_RATE*DIV_SAMPLE);  // have to divide the system clock frequency to get a frequency (div_sample) time higher than (baud_rate)  
    localparam     MID_SAMPLE          = (DIV_SAMPLE/2);  // medio de un bit en el que desea  tomar la muestra
    localparam     COUNTER_SIZE        = $clog2(DIV_COUNTER+1)+1;//size para contener el el div_counter
    localparam     SAMPLE_COUNTER_SIZE = $clog2(DIV_SAMPLE+1);
    
    
    reg         [DBIT-1    :0]                  shift_reg, shift_reg_next;   
    reg                                         state, state_next;
    reg                                         data_ready, data_ready_next;    
    reg         [BIT_COUNTER_SIZE-1     :0]     bitcounter, bitcounter_next; // Contador para saber si tengo los 8 bits
    reg         [SAMPLE_COUNTER_SIZE-1  :0]     samplecounter, samplecounter_next; // Contador de muestras de 2 bits para contar hasta 4 para oversampling
    reg         [COUNTER_SIZE+1         :0]     counter; // Contador de la tasa de baudios

    
    assign o_data  = shift_reg [DBIT-1:0]; 
    assign o_ready = data_ready;
    
    always @ (posedge i_clk, posedge i_reset)
        begin 
            if (i_reset)begin       
                counter             <= 0; 
                state               <= IDLE; 
                bitcounter          <= 0; 
                samplecounter       <= 0; 
                shift_reg           <= 0;
                data_ready          <= 0;
            end else begin 
                counter <= counter +1;
                if (counter >= DIV_COUNTER-1) begin // si el contador es igual/mayor entra
                    counter       <= 0; 
                    state         <= state_next; 
                    bitcounter    <= bitcounter_next;
                    data_ready    <= data_ready_next;
                    samplecounter <= samplecounter_next;
                    shift_reg     <= shift_reg_next;                    
                end
            end
        end
       
    always @* 
    begin 
        state_next          <=  state;
        samplecounter_next  <=  samplecounter;
        bitcounter_next     <=  bitcounter;
        data_ready_next     <=  data_ready;
        shift_reg_next      <=  shift_reg;
        case (state)
            IDLE:
             begin 
                if (~i_rx_bit) begin// Si el input de UART es 1 queda, esto el bit start en 0
                    state_next          <= RECEIVING; 
                    bitcounter_next     <= 0;
                    samplecounter_next  <= 0;
                    data_ready_next     <= 0;
                end
            end
            RECEIVING: 
            begin
                if (samplecounter == MID_SAMPLE - 1) begin   
                    shift_reg_next      <=  {i_rx_bit,shift_reg[DBIT-1:1]}; // si el contador de muestras es 1, activa el shift
                end            
                if (samplecounter == DIV_SAMPLE - 1) begin
                    if (bitcounter == DBIT) begin // Si el contador de bits es 8, recibi el total de la data
                        state_next      <= IDLE; 
                        data_ready_next <= 1;
                    end 
                                       
                    bitcounter_next     <= bitcounter + 1; 
                    samplecounter_next  <= 0; //Reinicia el contador
                end 
                else begin 
                    samplecounter_next  <= samplecounter + 1;          
                end
            end
           default: 
                state_next <= IDLE;
         endcase
    end         
endmodule
`timescale 1ns / 1ps


module tx
    #(
        parameter       CLK_FR     = 50000000,  
        parameter       BAUD_RATE    = 9600, 
        parameter       DBIT    = 8
    )
    (
        input                                   i_clk, 
        input                                   i_reset, 
        input                                   i_tx_start, //LLegaron datos a i_data
        input           [DBIT-1    :0]          i_data, // Datos a transmitir
        output                                  o_tx_data, // salida de datos desde tx
        output                                  o_tx_done // se pone a 1 para avisar que se termino con el proceso
    );
    
    localparam   IDLE                = 1'b0;
    localparam   SEND                = 1'b1; 
        
    // Parametros locales
    localparam   BIT_COUNTER_SIZE    = $clog2(DBIT+2);
    localparam   DIV_COUNTER         = CLK_FR / BAUD_RATE; //seria nuestro ticks
    localparam   COUNTER_SIZE        = $clog2(DIV_COUNTER+1); //size para contener el el div_counter
    
    //internal variables
    reg         [COUNTER_SIZE-1         :0]       counter; //Count, have to divide the system clock frequency to get a frequency (div_sample) time higher than (baud_rate)  
    reg         [BIT_COUNTER_SIZE-1     :0]       bitcounter, bitcounter_next; //Contador para saber si se enviaron 10 bits
    reg                                           state, state_next;
    reg         [DBIT+1            :0]            shift, shift_next; 
    
    reg                                           tx_data, tx_next_data;
    reg                                           tx_done, tx_done_next;

    assign o_tx_data      = tx_data;
    assign o_tx_done = tx_done;
    
    always @ (posedge i_clk, posedge i_reset) 
    begin 
        if (i_reset) begin
            state           <= IDLE;
            counter         <= 0; 
            bitcounter      <= 0;
            tx_done         <= 1; 
            tx_data         <= 1;
        end
        else begin
            counter <= counter + 1; //Se incrementa para solo entrar cuando sea mayor/igual a div counter, debe esperar ese tiempo
            if (counter >= DIV_COUNTER) begin //Cuenta hasta 10416          
              counter       <=  0;        
              state         <=  state_next;
              shift     <=  shift_next;
              bitcounter    <=  bitcounter_next;
              tx_data       <=  tx_next_data;
              tx_done       <=  tx_done_next;
           end
         end
    end 
       
    always @* 
    begin        
        shift_next    <= shift;
        tx_next_data      <= tx_data;
        bitcounter_next   <= bitcounter;
        tx_done_next      <= tx_done;
        case (state)
            IDLE:
            begin 
                if (i_tx_start) begin // Si es 1, llegaron datos y puedo comenzar
                   state_next           <= SEND;
                   shift_next       <= {1'b1,i_data,1'b0}; //Cargo 8 bits de datos
                end 
                else begin // Si no hay dato espero
                   state_next           <= IDLE;
                   tx_next_data         <= 1; 
                   tx_done_next         <= 1;
                end
            end
            SEND:
            begin  
                if (bitcounter >= 10) begin // Si se transmitieron 10 bits vuelve a IDLE, 8 bits data, bit start y stop
                    state_next          <= IDLE; 
                    bitcounter_next     <= 0;
                end 
                else begin //Si la transmision no completo envia el siguiente bit
                    state_next          <=  SEND; 
                    tx_done_next        <=  0;
                    tx_next_data        <=  shift[0]; 
                    shift_next      <=  shift >> 1; // Mueve el registro en 1 bit
                    bitcounter_next     <=  bitcounter + 1;
                end
            end
            default: 
                state_next <= IDLE;                      
        endcase
    end

endmodule


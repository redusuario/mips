`timescale 1ns / 1ps


module tb_buffer_tx
#( // Default setting:
		// 38,400 baud, 8 data bits, 1 stop bit, 2^2 FIFO 
		parameter 	DBIT = 8,			// # data bits
					SB_TICK = 16, 		// # ticks for stop bits,
										// 16/24/32 for 1/1.5/2 bits
					DVSR = 163,			// baud rate divisor
										// DVSR = 100MHZ/(16 * baud rate)
					DVSR_BIT = 8, 		// # bits of DVSR
					FIFO_W = 2	,		// # addr bits of FIFO
										// # words i n FIFO=2"FIFO-W
										
					
					NB_DATA = 8,                   
       				NB_CODE = 6,                  
       				NB_STATE = 2);

    reg                         i_clk;
    reg                         i_reset;  
    reg                [31:0]   instruccion;
    wire                         done;
    wire               [7:0]     parte;
    reg                         enviar;   
    wire                     epmty;
    wire                    tick;
    wire                     tx_done_tick;
    wire                    tx;
    reg                     wr;


   initial begin
      i_clk = 1'b0;
      i_reset = 1'b1;
      enviar=1'b0;
      #10
      i_reset = 1'b0;
      enviar=1'b1;
      instruccion = 32'b11111111000000001111111100000000;
        
      #20
      instruccion = 32'b11110000111100001111111100011000;
      
      #20
      instruccion = 32'b111100001111000011111111000111111;
      
      #20
      enviar=1'b0; 
      
      #10
      wr= 1'b1;
      
      #20
      wr= 1'b0;

                
     end

    // CLOCK_GENERATION
    always #10 i_clk = ~i_clk;

    instruc_buffer
    #(
    )
    u_instruc_buffer
    (
        .clk                (i_clk),              
        .reset              (i_reset), 
        .done                 (done),
        .wr                  (wr),
        .enviar             (enviar),
        .tx_done_tick       (tx_done_tick),     
        .entrada             (instruccion), 
        .parte                (parte),
        .empty               (empty)           

  );
  	uart_tx #( .DBIT(DBIT), .SB_TICK(SB_TICK)) uart_tx_unit
		( .clk(i_clk), .reset(i_reset), .tx_start(empty), 
		.s_tick(tick), .din(parte),
		.tx_done_tick(tx_done_tick), .tx(tx));	
		
    	mod_m_counter #(.M(DVSR), .N(DVSR_BIT)) baud_gen_unit
		( .clk(i_clk), .reset(i_reset), .q(), .max_tick(tick));
endmodule
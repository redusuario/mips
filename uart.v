// Code your design here
`timescale 1ns / 1ps

module uart
	
	#(  // Default setting:
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
       				NB_STATE = 2
	)
	(
		input	wire 			clk, reset,
		input 	wire 			rx,
		output  wire 	[7:0] 	tx_fifo_out,
		output 	wire 			 tx,
	    input   wire            wr_uart,
		output  wire     [7:0] 	rx_data_out   
	);

	// signal declaration
	wire       [7:0]     rx_data;
	wire 			tick, rx_done_tick, tx_done_tick, ready_instruc;
    wire            empty;
    //wire               [7:0]     parte;
    wire     [31:0] 	registro;
    wire               done;             
	//body
	mod_m_counter #(.M(DVSR), .N(DVSR_BIT)) baud_gen_unit
		( .clk(clk), .reset(reset), .q(), .max_tick(tick));

	uart_rx #( .DBIT(DBIT), .SB_TICK(SB_TICK)) uart_rx_unit
		( .clk(clk), .reset(reset), .rx(rx), .s_tick(tick),
		.rx_done_tick(rx_done_tick), .dout(rx_data));

  	uart_tx #( .DBIT(DBIT), .SB_TICK(SB_TICK)) uart_tx_unit
		( .clk(clk), .reset(reset), .tx_start(empty), 
		.s_tick(tick), .din(tx_fifo_out),
		.tx_done_tick(tx_done_tick), .tx(tx));	

    
    make_instruc
    #(
    )
    u_make_instruc
    (
        .i_clk                (clk),              
        .i_reset              (reset),            
        .entrada        (rx_data),
        .i_rx_done        (rx_done_tick),
        .ready_instruc     (ready_instruc),       
        .o_registro              (registro),
        .test                    (rx_data_out)      

  );
  
      instruc_buffer
    #(
    )
    u_instruc_buffer
    (
        .clk                (clk),              
        .reset              (reset), 
        .done                 (done),
        .wr                  (wr_uart),
        .enviar             (ready_instruc),
        .tx_done_tick       (tx_done_tick),     
        .entrada             (registro), 
        .parte                (tx_fifo_out),
        .empty               (empty)           

  );


//mapear clk,reset,rx input, rd_uart = ? input pulsador, rx_empty = debug, r_data = 7 leds

endmodule



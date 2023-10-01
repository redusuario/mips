`timescale 1ns / 1ps

module top #(
	parameter 		NB_ADDR 		= 	32,
	parameter 		NBITS 			= 	32,
	parameter 		NB_INST   		= 	32,
    parameter       NB_OPCODE       =   6,
    parameter       NB_FUNCT        =   6,
    parameter       NB_REG          =   5,     // Longitud del campo RS,RT,RD
    parameter       NB_IMMEDIATE    =   16,
    parameter       NB_DATA         =   32,
    parameter       SIZE_REG        =   32,
    parameter       NB_IMMED        =   16,     // Longitud sin signo
	parameter   	NB_OP         	= 	6,  
    parameter   	NB_DATA_OUT   	= 	32,
    parameter   	NB_SELECTOR   	= 	2,       // Longitud del selector
    parameter       DBIT = 8,
    parameter       SB_TICK = 16, 		// # ticks for stop bits,
										// 16/24/32 for 1/1.5/2 bits
	parameter	    DVSR = 163,			// baud rate divisor
										// DVSR = 100MHZ/(16 * baud rate)
    parameter       DVSR_BIT = 8 		// # bits of DVSR

)
(

	//----------------------------------------------------
	// IF - INPUT
	//----------------------------------------------------

	input 		wire 						i_clk,
	input 		wire 						i_reset,
    
   //-------------------
   //UART INPUT
    input 	wire 			rx,
    input   wire            wr_uart,
   
	//----------------------------------------------------
	// ID - INPUT
	//----------------------------------------------------

    
	//----------------------------------------------------
	// EX - INPUT
	//----------------------------------------------------

	//----------------------------------------------------
	// WB - INPUT
	//----------------------------------------------------
    //input   wire    [NB_INST-1:0]      i_data_mem, NO SE IMPLEMENTO AUN



	//----------------------------------------------------
	// IF - OUTPUT
	//----------------------------------------------------


	//----------------------------------------------------
	// ID - OUTPUT
	//----------------------------------------------------


	//----------------------------------------------------
	// EX - OUTPUT
	//----------------------------------------------------

    //-------------------
    //UART OUTPUT
    output  wire 	[7:0] 	tx_fifo_out,
	output 	wire 			 tx,
    output  wire     [7:0] 	rx_data_out   
);


//--------------------------------------------------------------------------------------
	// signal declaration
	reg 	[NB_ADDR - 1:0] 	i_pc=4; //BORRAR, POR AHORA SE HACE ASI
	wire                        i_write;
	wire 						i_enable;
	wire 	[NB_INST - 1:0]     i_instruction;
	wire 	[NB_ADDR - 1:0]     i_address;
	wire  [NB_INST-1:0]       		o_instruction;
	wire [NB_DATA-1:0]               o_data_read_debug;
	wire  [NB_ADDR-1:0]              o_pc;
	
	wire       [7:0]     rx_data;
	wire 			tick, rx_done_tick, tx_done_tick;
    wire            empty;
    wire               done;    
//--------------------------------------------------------------------------------------

top_mips u_top_mips(
	.i_clk(i_clk),
	.i_enable(i_enable),
	.i_reset(i_reset),
	.i_pc(i_pc),
	.i_write(i_write),
	.i_instruction(i_instruction),
	.i_address(i_address),
	//.i_data_mem(i_data_mem), aun no se IMPLEMENTA
	.o_instruction(o_instruction),
	.o_pc(o_pc),
	.o_data_read_debug(o_data_read_debug)
);
	mod_m_counter #(.M(DVSR), .N(DVSR_BIT)) baud_gen_unit
		( .clk(i_clk), .reset(i_reset), .q(), .max_tick(tick));

	uart_rx #( .DBIT(DBIT), .SB_TICK(SB_TICK)) uart_rx_unit
		( .clk(i_clk), .reset(i_reset), .rx(rx), .s_tick(tick),
		.rx_done_tick(rx_done_tick), .dout(rx_data));

  	uart_tx #( .DBIT(DBIT), .SB_TICK(SB_TICK)) uart_tx_unit
		( .clk(i_clk), .reset(i_reset), .tx_start(empty), 
		.s_tick(tick), .din(tx_fifo_out),
		.tx_done_tick(tx_done_tick), .tx(tx));	

    
    make_instruc
    #(
    )
    u_make_instruc
    (
        .i_clk                (i_clk),              
        .i_reset              (i_reset),            
        .entrada        (rx_data),
        .i_rx_done        (rx_done_tick),
        .ready_instruc     (i_write),       
        .o_registro              (i_instruction),
        .test                    (rx_data_out),
        .o_address                (i_address),
        .o_step                   (i_enable)      

  );
  
      instruc_buffer
    #(
    )
    u_instruc_buffer
    (
        .clk                (i_clk),              
        .reset              (i_reset), 
        .done                 (done),
        .wr                  (wr_uart),
        //.enviar             (ready_instruc),
        .tx_done_tick       (tx_done_tick),     
        .entrada             (o_data_read_debug), 
        .parte                (tx_fifo_out),
        .empty               (empty),
        .i_pc                 (o_pc),
        .i_instruction        (o_instruction)  

  );


endmodule
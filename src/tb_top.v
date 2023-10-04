// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples

// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_top();

	localparam 		NB_ADDR 		= 	32;
	localparam 		NBITS 			= 	32;
	localparam 		NB_INST   		= 	32;
    localparam       NB_OPCODE       =   6;
    localparam       NB_FUNCT        =   6;
    localparam       NB_REG          =   5;     // Longitud del campo RS,RT,RD
    localparam       NB_IMMEDIATE    =   16;
    localparam       NB_DATA         =   32;
    localparam       SIZE_REG        =   32;
    localparam       NB_IMMED        =   16;     // Longitud sin signo
	localparam   	NB_OP         	= 	6;  
    localparam   	NB_DATA_OUT   	= 	32;
    localparam  	NB_SELECTOR   	= 	2;       // Longitud del selector
    localparam       DBIT = 8;
    localparam       SB_TICK = 16; 		// # ticks for stop bits,
										// 16/24/32 for 1/1.5/2 bits
	localparam	    DVSR = 163;			// baud rate divisor
										// DVSR = 100MHZ/(16 * baud rate)
    localparam       DVSR_BIT = 8; 		// # bits of DVSR



    reg                         i_clk;
    reg                         i_reset;  
    reg                         rx;
    wire               [7:0]     rx_data_out;
    wire               [7:0]     tx_fifo_out;
    reg                         wr_uart;
    wire                         tx;  

  initial begin
      i_clk = 1'b0;
      i_reset = 1'b1;
      wr_uart=1'b0;
      rx = 1'b1;
      //se carga 000000 00111 10000 10011 00000 100000
      #10
      i_reset = 1'b0;
      rx = 1'b0;
        
      #104167
      rx = 1'b0;
      
      #104167
      rx = 1'b1;
      
      #5000
      rx = 1'b0;

      #104167
      rx = 1'b0;
 
      #104167
      rx = 1'b0;
      
      #104167
      rx = 1'b0;

      #104167
      rx = 1'b0;
      
            #104167
      rx = 1'b1;
      
      #104167
      rx = 1'b1;
      
      #104167
      rx = 1'b1;

      #104167
      rx = 1'b0;
 
      #104167
      rx = 1'b0;
      
      #104167
      rx = 1'b1; //esta póner a 0 para probar el caso de bucle

      #104167
      rx = 1'b0;
                  
      #10416
      rx = 1'b0;
      
      #104167
      rx = 1'b1;
      
      #104167
      rx = 1'b0;

      #104167
      rx = 1'b0;
 
      #104167
      rx = 1'b0;
      
      #104167
      rx = 1'b1;

      #70416
      rx = 1'b0;      
            
      #50000
      rx = 1'b0; 

    #104167
      rx = 1'b0;
      
      #104167
      rx = 1'b0;
      
      #104167
      rx = 1'b0;

      #104167
      rx = 1'b1;
 
      #104167
      rx = 1'b0;
      
      #104167
      rx = 1'b0;

      #204167
      rx = 1'b0;
      
            #104167
      rx = 1'b1;
      
      #104167
      rx = 1'b1;
      
      #104167
      rx = 1'b1;

      #104167
      rx = 1'b0;
 
      #104167
      rx = 1'b0;
      
      #104167
      rx = 1'b0;

      #204167
      rx = 1'b0;
                  
      #50000
      rx = 1'b1;
      
      #104167
      rx = 1'b1;
      
      #104167
      rx = 1'b1;

      #104167
      rx = 1'b0;
 
      #104167
      rx = 1'b0;
      
      #104167
      rx = 1'b0;

      #104167
      rx = 1'b0;      
            
      #104167
      rx = 1'b1;

      #10
      wr_uart=1'b0;
       
      $finish();
                
     end

    // CLOCK_GENERATION
    always #10 i_clk = ~i_clk;
top u_top
(
        .i_clk                (i_clk),              
        .i_reset              (i_reset), 
        .rx                 (rx),
        .wr_uart                  (wr_uart),
        .tx             (tx),
        .rx_data_out       (rx_data_out),     
        .tx_fifo_out            (tx_fifo_out)  
);
endmodule
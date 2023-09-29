`timescale 1ns / 1ps


module tb_uart();

		localparam 	DBIT = 8;			// # data bits
		localparam	SB_TICK = 16; 		// # ticks for stop bits,
										// 16/24/32 for 1/1.5/2 bits
		localparam	DVSR = 163;			// baud rate divisor
										// DVSR = 100MHZ/(16 * baud rate)
		localparam			DVSR_BIT = 8; 		// # bits of DVSR
		localparam			FIFO_W = 2;		// # addr bits of FIFO
										// # words i n FIFO=2"FIFO-W
										
					
		localparam			NB_DATA = 8;                   
       	localparam			NB_CODE = 6;                  
       	localparam			NB_STATE = 2;

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
      
      #10
      i_reset = 1'b0;
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

    uart
    #(
    	.DBIT	(DBIT),		
		.SB_TICK (SB_TICK) , 						
		.DVSR    (DVSR),										
		.DVSR_BIT (DVSR_BIT), 		
		.FIFO_W (FIFO_W)	,		
		.NB_DATA (NB_DATA),                   
       	.NB_CODE (NB_CODE),                  
       	.NB_STATE (NB_STATE)
    )
    u_uart
    (
        .clk                (i_clk),              
        .reset              (i_reset), 
        .rx                 (rx),
        .wr_uart                  (wr_uart),
        .tx             (tx),
        .rx_data_out       (rx_data_out),     
        .tx_fifo_out            (tx_fifo_out)          

  );
endmodule
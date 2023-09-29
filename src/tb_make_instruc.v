`timescale 1ns / 1ps


module tb_make_instruc();

    reg                        i_clk;
    reg                         i_reset;  
    reg                [7:0]          entrada;
    reg                         i_rx_done;
    wire [31:0] registro;
    wire  ready_instruc;



   initial begin
        i_clk = 1'b0;
        i_reset = 1'b1;
        i_rx_done=1'b0;
        #10
        i_reset = 1'b0;
        i_rx_done=1'b1;
        entrada = 8'b11111111;
        
        #20
        entrada = 8'b00000000;        
        
        #20
        entrada = 8'b11111111;  
        
        
        #20
        i_rx_done=1'b0;
        
        #20
        entrada = 8'b00000000;
        
        #200
        i_rx_done=1'b1;
         
        
        #20
        i_rx_done=1'b0;
        entrada = 8'b11110000;  // basura que no entra porque rx_done es 0
        
      #60
      if ((registro == 32'b11111111000000001111111100000000 && ready_instruc==1'b1 ))
          $display("******  Test CORRECTO ******");
        else     
          $display("############# Test FALLO ############");
            
        #20
        i_rx_done=1'b1;
        entrada = 8'b00000000;
        
        $finish();
                
    end

    // CLOCK_GENERATION
    always #10 i_clk = ~i_clk;

    make_instruc
    #(
    )
    u_make_instruc
    (
        .i_clk                (i_clk),              
        .i_reset              (i_reset), 
        .i_rx_done             (i_rx_done),           
        .entrada        (entrada),
        .ready_instruc      (ready_instruc),     
        .o_registro              (registro)           

  );
endmodule
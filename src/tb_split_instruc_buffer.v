`timescale 1ns / 1ps


module tb_instruc_buffer();

    reg                         i_clk;
    reg                         i_reset;  
    reg                [31:0]   instruccion;
    wire                         done;
    wire               [7:0]     parte;
    reg                         tx_done_tick;
    reg                         enviar;   


   initial begin
      i_clk = 1'b0;
      i_reset = 1'b1;
      enviar=1'b0;
      tx_done_tick = 1'b0;
      #10
      i_reset = 1'b0;
      enviar=1'b1;
      instruccion = 32'b11111111000000001111111100000000;
        
      #20
      instruccion = 32'b11110000111100001111111100011000;
      
      #20
      instruccion = 32'b111100001111000011111111000111111;
      
      #20
      tx_done_tick =1'b1;
      enviar=1'b0; 
      
      #10
      //tx_done_tick= 1'b0;
       
      $finish();
                
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
        .parte                (parte)           

  );
endmodule
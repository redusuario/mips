`timescale 1ns / 1ps

module Sumador_PC_Jump
    #(
        parameter NBITS     =  32,
        parameter NBITSJUMP =  26
    )
    (
        input   wire    [NBITSJUMP-1 :0]     i_if_id_jump,
        input   wire    [NBITS-1:0]          i_id_expc4,
        output  wire    [NBITS-1:0]          o_IJump                 
    );
    
    reg [NBITS-1:0]   IJump_reg   ;    
    
    always @(*)
    begin
        IJump_reg   <=  {i_id_expc4[NBITS-1:27], (i_if_id_jump<<2)}  ; //se obtienen los bits 31 a 27 y se concatenan con i_if_id_jump
                                                             //i_if_id_jump se desplazo 2 lugares a la izq, lo que equivale a multiplicar por 4
                                                             //calculo el salto
    end   
    
   assign  o_IJump   = IJump_reg   ;
endmodule

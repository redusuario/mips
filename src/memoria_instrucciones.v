`timescale 1ns / 1ps

module Memoria_Instrucciones
    #(
        parameter NBITS     = 32    ,
        parameter TAM    = 256
    )
    (
        input   wire                        i_clk,
        input   wire                        i_reset,
        input   wire                        i_step,
        input   wire    [NBITS-1    :0]     i_pc,
        input   wire    [NBITS-1    :0]     i_address_memory_ins,
        input   wire    [NBITS-1    :0]     i_instruction,
        input   wire                        i_write_intruc,
        output  reg     [NBITS-1    :0]     o_instruction   
    );
    
    reg     [NBITS-1  :0]     memory[TAM-1:0];
    integer                   i;

    
    initial 
    begin
        for (i = 0; i < TAM; i = i + 1) begin
            memory[i] = 0;
        end  
    end


    always @(posedge i_clk)
    begin
        if (i_step)begin
            o_instruction  <= memory[i_pc];
        end
    end

    always @(posedge i_write_intruc) begin
            memory[i_address_memory_ins] <= i_instruction; 
    end

endmodule

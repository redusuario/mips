`timescale 1ns / 1ps

module Mux_PC
    #(
        parameter NBITS     =  32
    )
    (
        input   wire                            i_Jump,
        input   wire                            i_JALR,
        input   wire    [NBITS-1      :0]       i_rs,
        input   wire                            i_pcSrc,
        input   wire    [NBITS-1      :0]       i_SumadorBranch,
        input   wire    [NBITS-1      :0]       i_sumador_pc4,        
        input   wire    [NBITS-1      :0]       i_SumadorJump,
        output  wire    [NBITS-1      :0]       o_pc            
    );
    
    reg             [NBITS-1  :0]          pc   ;
   
    always @(*)
    begin
        if(i_Jump)
            pc <=  i_SumadorJump;
        else if (i_JALR)
            pc <=  i_rs;
        else if(i_pcSrc)
            pc <=  i_SumadorBranch;
        else
            pc <=  i_sumador_pc4;  
    end

    assign o_pc = pc;

endmodule

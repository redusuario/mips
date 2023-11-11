`timescale 1ns / 1ps


module Sumador_Branch
    #(
        parameter NBITS = 32
    )
    (
        input   wire    [NBITS-1      :0]   i_extension_data,
        input   wire    [NBITS-1      :0]   i_sumador_pc4,
        output  wire    [NBITS-1      :0]   o_sum_pc_branch                 
    );
    
    reg [NBITS-1  :0]   mux_sumador_branch;    
    
    always @(*)
    begin
        mux_sumador_branch   <=  (i_extension_data<<2) + i_sumador_pc4  ;
    end  
     
    assign  o_sum_pc_branch   =   mux_sumador_branch;


endmodule

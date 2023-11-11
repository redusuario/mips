`timescale 1ns / 1ps
module AND_Branch
    #(
        parameter NBITS = 32
    )
    (
        input   wire    i_Branch    ,
        input   wire    i_NBranch   ,
        input   wire    i_cero      ,
        output  wire    o_pcSrc                 
    );
    
    reg result  ;    
    
    initial 
    begin
        result     <=      1'b0;      
    end
    
    always @(*)
    begin
        if((i_Branch && i_cero) || (i_NBranch && !i_cero))
            result   <=     1'b1    ;
        else
            result   <=     1'b0    ;
    end
    
    assign  o_pcSrc   =   result  ;       
endmodule

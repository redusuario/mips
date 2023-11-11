`timescale 1ns / 1ps

module Mux_Registro
    #(
        parameter NBITS = 5
    )
    (
        input   wire                          i_RegDst,
        input   wire     [NBITS-1      :0]    i_reg_rd,
        input   wire     [NBITS-1      :0]    i_reg_rt,
        output  wire     [NBITS-1      :0]    o_registro                 
    );
    
    reg [NBITS-1  :0]   to_reg;

    
    always @(*)
    begin
        case(i_RegDst)
            1'b0:   to_reg  <=  i_reg_rt    ;   
            1'b1:   to_reg  <=  i_reg_rd    ;
        endcase
    end

    assign  o_registro   =   to_reg;

endmodule

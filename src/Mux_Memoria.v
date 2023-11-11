`timescale 1ns / 1ps

module Mux_Memoria
    #(
        parameter NBITS = 32
    )
    (
        input   wire                          i_MemToReg    ,
        input   wire     [NBITS-1      :0]    i_MemData    , //Memoria de Datos -> Dato del Filtro -> Dato de LUI 
        input   wire     [NBITS-1      :0]    i_ALU_result  , //Dato de la ALU
        output  wire     [NBITS-1      :0]    o_to_mux_jal                 
    );
    
    reg [NBITS-1  :0]   to_mux_jal;
    
    always @(*)
    begin
        case(i_MemToReg)
            1'b0:   to_mux_jal  <=  i_ALU_result;   
            1'b1:   to_mux_jal  <=  i_MemData;
        endcase
    end

    assign  o_to_mux_jal   =   to_mux_jal;

endmodule

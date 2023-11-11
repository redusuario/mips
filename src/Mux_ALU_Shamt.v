`timescale 1ns / 1ps

module Mux_ALU_Shamt
    #(
        parameter NBITS         = 32,
        parameter CORTOCIRCUITO = 3
    )
    (
        input   wire  [CORTOCIRCUITO-1:0]   i_corto_cir_regA,
        input   wire  [NBITS-1:0]           i_ID_EX_Registro,
        input   wire  [NBITS-1:0]           i_ex_mem_reg,
        input   wire  [NBITS-1:0]           i_MEM_WR_Registro,
        output  wire  [NBITS-1:0]           o_mux_alu                 
    );
    
    reg [NBITS-1  :0]   to_alu;
    assign o_mux_alu =    to_alu;
    
    always @(*)
    begin
        case(i_corto_cir_regA)
            3'b001:      to_alu  <=  i_ex_mem_reg   ;
            3'b010:      to_alu  <=  i_MEM_WR_Registro   ; 
            default :    to_alu  <=  i_ID_EX_Registro    ;
        endcase
       end
          
endmodule

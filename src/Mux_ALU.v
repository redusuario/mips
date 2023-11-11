`timescale 1ns / 1ps

module Mux_ALU
    #(
        parameter NBITS         = 32,
        parameter CORTOCIRCUITO = 3
        
    )
    (
        input   wire                            i_ALUSrc,                   //Usas inmediato o registro
        input   wire    [CORTOCIRCUITO-1:0]     i_corto_circuito_regb,   //Registro ha usar x cortocircuito
        input   wire    [NBITS-1:0]             i_registro,                 //Dato leido Registro 2
        input   wire    [NBITS-1:0]             i_extension_data,            //Inst Extendida
        input   wire    [NBITS-1:0]             i_ex_mem_reg,          //Resultado ALU EX/MEM
        input   wire    [NBITS-1:0]             i_MEM_WR_Operando,          //Resultado ALU MEM/WR
        output  wire    [NBITS-1:0]             o_mux_data_b                 
    );
    
    reg     [NBITS-1:0]        to_alu;


    
    always @(*)
    begin
        if(i_ALUSrc)begin
                to_alu <= i_extension_data;
            end
        else
            begin
                case(i_corto_circuito_regb)
                    3'b001:     to_alu  <=  i_ex_mem_reg;
                    3'b010:     to_alu  <=  i_MEM_WR_Operando;
                    default:    to_alu  <=  i_registro;
                endcase
            end 
    end

    assign  o_mux_data_b         =   to_alu;

endmodule

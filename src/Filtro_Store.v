`timescale 1ns / 1ps

//00: complete word
//01: SB -> para un byte
//10: SH -> para media palabra

module Filtro_Store
    #(
        parameter   NBITS           =   32,
        parameter   TNBITS          =   2   
    )
    (
        input   wire    [NBITS-1    :0]     i_dato_rt, // REG[rt]
        input   wire    [TNBITS-1   :0]     i_selector, // selector dependiendo la instrucción SB / SH / OTRA
        output  wire    [NBITS-1    :0]     o_DatoEscribir // dato para ser escrito en memoria           
    );
    
    reg [NBITS-1    :0] DatoEscribir;

    
    always @(*)
    begin : selector
            case(i_selector)
                2'b00       :       
                                    DatoEscribir   <=   i_dato_rt; // rt sin modifiaciones: memory[base+offset] <- rt 
                2'b01    :        
                                    DatoEscribir   <=   i_dato_rt & 32'b00000000_00000000_00000000_11111111;    // para instrucciones sb:  memory[base+offset] <- rt
                2'b10    :
                                    DatoEscribir   <=   i_dato_rt & 32'b00000000_00000000_11111111_11111111;    // para instrucciones sh:  memory[base+offset] <- rt
                default     :   
                                    DatoEscribir   <=   -1;
            endcase
    end

    assign o_DatoEscribir =    DatoEscribir;


endmodule
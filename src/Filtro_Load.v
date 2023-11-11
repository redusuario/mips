`timescale 1ns / 1ps


module Filtro_Load
    #(
        parameter   NBITS           =   32,
        parameter   HWORDBITS       =   16,
        parameter   BYTENBITS       =   8,
        parameter   TNBITS          =   2   
    )
    (
        input   wire    [NBITS-1    :0]     i_data,
        input   wire    [TNBITS-1   :0]     i_size,
        input   wire                        i_cero, //Zero_Extend es un flag para decir si es Unsigned
        output  wire    [NBITS-1    :0]     o_DatoEscribir            
    );
    
    reg [NBITS-1    :0] DatoEscribir           ;

    
    always @(*)
    begin : Tamano
            case(i_size)
                2'b00       :       
                                    DatoEscribir   <=   i_data;
                2'b01   :
                    case(i_cero)
                        1'b0:       DatoEscribir   <=   {{HWORDBITS+BYTENBITS{i_data[BYTENBITS-1]}}, i_data[BYTENBITS-1:0]};
                        1'b1:       DatoEscribir   <=   i_data & 32'b00000000_00000000_00000000_11111111;      
                    endcase
                2'b10    :
                    case(i_cero)
                        1'b0:       DatoEscribir   <=   {{HWORDBITS{i_data[HWORDBITS-1]}}, i_data[HWORDBITS-1:0]};
                        1'b1:       DatoEscribir   <=   i_data & 32'b00000000_00000000_11111111_11111111; 
                    endcase
                default     :   
                                    DatoEscribir   <=   -1;
            endcase
    end
    

    assign o_DatoEscribir =    DatoEscribir;


endmodule

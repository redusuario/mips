`timescale 1ns / 1ps

module Extensor_Signo #(
        parameter i_NBITS = 16,
        parameter e_NBITS = 16,
        parameter o_NBITS = 32
    )
    (
        input   wire    [i_NBITS-1:0]     i_id_inmediate,
        input   wire    [1:0]             i_extension_mode,
        output  wire    [o_NBITS-1:0]     o_extensionresult
    );
    
    reg     [o_NBITS-1:0] result_extension;

    always @(*)
    begin
        case(i_extension_mode)
            2'b00:      result_extension  <=  {{e_NBITS{i_id_inmediate[i_NBITS-1]}}, i_id_inmediate}  ;
            //1000 0000 0000 0000 -> 1111 1111 1111 1111 1000 0000 0000 0000
            2'b01:      result_extension  <=  {{e_NBITS{1'b0}}, i_id_inmediate};
            //1000 0000 0000 0000 -> 0000 0000 0000 0000 1000 0000 0000 0000
            2'b10:      result_extension  <=  {i_id_inmediate,{e_NBITS{1'b0}}};
            //1000 0000 0000 0000 -> 1000 0000 0000 0000 0000 0000 0000 0000   
            default:    result_extension  <= -1;
        endcase
    end

    assign o_extensionresult = result_extension;
    
endmodule

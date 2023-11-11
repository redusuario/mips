`timescale 1ns / 1ps

module Mux_LUI
    #(
        parameter NBITS = 32
    )
    (
        input   wire                          i_LUI,
        input   wire     [NBITS-1      :0]    i_extend,
        input   wire     [NBITS-1      :0]    i_filter_load,
        output  wire     [NBITS-1      :0]    o_to_mux_memory                 
    );
    
    reg [NBITS-1  :0]   to_mux_memory ;

    
    always @(*)
    begin
        case(i_LUI)
            1'b0:   to_mux_memory   <=  i_filter_load; // entrada proveniente del filtro load   
            1'b1:   to_mux_memory   <=  i_extend;   // entrada proveniente del extensor de signo
        endcase
    end
    

    assign  o_to_mux_memory   =   to_mux_memory ; //salida hacia mux_memory


endmodule

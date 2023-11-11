`timescale 1ns / 1ps

module WB_Mux_RegDestino
    #(
        parameter REGS        = 5
    )
    (
        input   wire     [REGS-1       :0]    i_RD,
        input   wire                          i_JAL,
        output  wire     [REGS-1       :0]    o_RD                 
    );

    reg [REGS-1  :0]   to_RD;


    always @(*)
    begin
        case(i_JAL)
            1'b0:   to_RD  <=  i_RD;   
            1'b1:   to_RD  <=  5'b11111; //En JAL se debe guardar el PC+8 en el registro 31
        endcase
    end

    assign  o_RD   =   to_RD;

endmodule
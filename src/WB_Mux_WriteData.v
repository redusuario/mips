`timescale 1ns / 1ps

module WB_Mux_Write_data
    #(
        parameter NBITS = 32
    )
    (
        input   wire                          i_JAL,
        input   wire     [NBITS-1      :0]    i_MemData,
        input   wire     [NBITS-1      :0]    i_pc_8,
        output  wire     [NBITS-1      :0]    o_reg                 
    );

    reg [NBITS-1  :0]   to_Reg;


    always @(*)
    begin
        case(i_JAL)
            1'b0:   to_Reg  <=  i_MemData;   
            1'b1:   to_Reg  <=  i_pc_8;
        endcase
    end

    assign  o_reg   =   to_Reg;

endmodule
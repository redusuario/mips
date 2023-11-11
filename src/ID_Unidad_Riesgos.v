`timescale 1ns / 1ps

module ID_Unidad_Riesgos
    #(
        parameter RNBITS    =   5,
        parameter MUXBITS   =   3
    )
    (
        input   wire                i_EX_MEM_Flush,
        input   wire                i_ID_EX_MemRead,
        input   wire                i_EX_MEM_MemRead,
        input   wire                i_JALR,
        input   wire                i_HALT,
        input   wire [RNBITS-1:0]   i_ID_EX_Rt,
        input   wire [RNBITS-1:0]   i_EX_MEM_Rt ,
        input   wire [RNBITS-1:0]   i_IF_ID_Rs ,
        input   wire [RNBITS-1:0]   i_IF_ID_Rt,
        output  wire                o_Mux_Risk,
        output  wire                o_pc_Write,
        output  wire                o_IF_ID_Write,
        output  wire                o_Latch_Flush
    );

    reg Reg_IF_ID_Write;
    reg Reg_Latch_Flush;
    reg Reg_IF_ID_Flush;
    reg Reg_Mux_Risk ;
    reg Reg_PC_Write;

    initial
    begin
        Reg_Mux_Risk       <=      1'b0;
        Reg_PC_Write       <=      1'b1;
        Reg_IF_ID_Write    <=      1'b1;
        Reg_Latch_Flush    <=      1'b0;
        Reg_IF_ID_Flush    <=      1'b0;
    end

    always @(*)
    begin
        if(i_EX_MEM_Flush)
        begin
            Reg_Latch_Flush      <= 1'b1;
        end
        else
        begin
            Reg_Latch_Flush      <= 1'b0;
        end
    end

    always @(*)
    begin
        if((i_ID_EX_MemRead && ((i_ID_EX_Rt == i_IF_ID_Rs) | (i_ID_EX_Rt == i_IF_ID_Rt))) | ((i_EX_MEM_MemRead && (i_EX_MEM_Rt == i_IF_ID_Rs)) && i_JALR))
        begin
            Reg_Mux_Risk        <= 1'b1; //risk 1
            Reg_PC_Write        <= 1'b0; //No escribir 0
            Reg_IF_ID_Write     <= 1'b0; //No escribir 0
        end
        else if (i_HALT)
        begin
            Reg_Mux_Risk        <= 1'b0;
            Reg_PC_Write        <= 1'b0;
            Reg_IF_ID_Write     <= 1'b1;
        end
        else
        begin
            Reg_Mux_Risk        <= 1'b0;
            Reg_PC_Write        <= 1'b1;
            Reg_IF_ID_Write     <= 1'b1;
        end
    end
    
    assign  o_Mux_Risk      =   Reg_Mux_Risk;
    assign  o_pc_Write      =   Reg_PC_Write;
    assign  o_IF_ID_Write   =   Reg_IF_ID_Write;
    assign  o_Latch_Flush   =   Reg_Latch_Flush;
endmodule

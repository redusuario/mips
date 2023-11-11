`timescale 1ns / 1ps

module WB
    #(
        parameter   NBITS           = 32,
        parameter   HWORDBITS       = 16,
        parameter   BYTENBITS       = 8,
        parameter   REGS            = 5,
        parameter   TNBITS          = 2              
    )
    (
        input   wire                            i_WB_LUI,
        input   wire    [NBITS-1        :0]     i_WB_Extend,
        input   wire    [NBITS-1        :0]     i_WB_DataMemory,
        input   wire    [1              :0]     i_WB_SizeFiltroL,
        input   wire                            i_WB_ZeroExtend,
        input   wire                            i_WB_MemToReg,
        input   wire    [NBITS-1        :0]     i_WB_ALU,
        input   wire                            i_WB_JAL,
        input   wire    [NBITS-1        :0]     i_WB_PC8,
        input   wire    [REGS-1         :0]     i_WB_Rd,
        output  wire    [NBITS-1        :0]     o_WB_DataWrite,
        output  wire    [NBITS-1        :0]     o_WB_EscribirDato,
        output  wire    [REGS-1         :0]     o_WB_Rd
    );


    wire    [NBITS-1        :0]     WB_DatoFiltradoL_o;
    wire    [NBITS-1        :0]     WB_DatoToReg_o;
    wire    [NBITS-1        :0]     WB_DatoEscritura;


    Mux_LUI
    #(
        .NBITS(NBITS)
    )
    u_Mux_LUI
    (
        .i_LUI(i_WB_LUI),
        .i_extend(i_WB_Extend),
        .i_filter_load(WB_DatoFiltradoL_o),
        .o_to_mux_memory(WB_DatoToReg_o)
    );

    Filtro_Load
    #(
        .NBITS(NBITS),
        .HWORDBITS(HWORDBITS),
        .BYTENBITS(BYTENBITS),
        .TNBITS(TNBITS) 
    )
    u_Filtro_Load
    (
        .i_data(i_WB_DataMemory),
        .i_size(i_WB_SizeFiltroL),
        .i_cero(i_WB_ZeroExtend),
        .o_DatoEscribir(WB_DatoFiltradoL_o) 
    );


    Mux_Memoria
    #(
        .NBITS(NBITS) 
    )
    u_Mux_Memoria
    (
        .i_MemToReg(i_WB_MemToReg),
        .i_MemData(WB_DatoToReg_o),
        .i_ALU_result(i_WB_ALU),
        .o_to_mux_jal(WB_DatoEscritura)   
    );


    WB_Mux_Write_data
    #(
        .NBITS(NBITS) 
    )
    u_WB_Mux_Write_data
    (
        .i_JAL(i_WB_JAL),
        .i_MemData(WB_DatoEscritura),
        .i_pc_8(i_WB_PC8),
        .o_reg(o_WB_EscribirDato) 
    );


    WB_Mux_RegDestino
    #(
        .REGS(REGS)
    )
    u_WB_Mux_RegDestino
    (
        .i_JAL(i_WB_JAL),
        .i_RD(i_WB_Rd),
        .o_RD(o_WB_Rd) 
    );
    

  
    assign o_WB_DataWrite  = WB_DatoEscritura;
endmodule
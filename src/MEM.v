`timescale 1ns / 1ps

module MEM
    #(
        parameter   NBITS           = 32,
        parameter   TNBITS          = 2,
        parameter   TAM_M           = 10       
    )
    (
        input   wire                            i_clk,
        input   wire                            i_reset,
        input   wire                            i_mips_clk_ctrl,
        input   wire    [NBITS-1:0]             i_EX_MEM_ALU,
        input   wire    [NBITS-1:0]             i_mips_mem_debug,
        input   wire                            i_EX_MEM_MemRead,
        input   wire                            i_EX_MEM_MemWrite,
        input   wire    [NBITS-1:0]             i_EX_MEM_Reg2,
        input   wire    [1:0]                   i_EX_MEM_TamanoFiltro,
        output  wire    [NBITS-1:0]             o_MEM_DataMemory,
        output  wire    [NBITS-1:0]             o_MEM_DataMemoryDebug
    );

    wire    [NBITS-1:0]     MEM_DatoFiltradoS_o;
  
    Filtro_Store
    #(
        .NBITS(NBITS),
        .TNBITS(TNBITS)
    )
    u_Filtro_Store
    (
        .i_dato_rt(i_EX_MEM_Reg2),
        .i_selector(i_EX_MEM_TamanoFiltro),
        .o_DatoEscribir(MEM_DatoFiltradoS_o)
    );
    
    Memory_Data
    #(
        .NBITS(NBITS),
        .TAM(TAM_M)
    )
    u_Memory_Data
    (
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_step(i_mips_clk_ctrl),
        .i_ALUaddress(i_EX_MEM_ALU),
        .i_debug_address(i_mips_mem_debug),
        .i_data_reg(MEM_DatoFiltradoS_o),
        .i_MemRead(i_EX_MEM_MemRead),
        .i_MemWrite(i_EX_MEM_MemWrite),
        .o_data_read(o_MEM_DataMemory),
        .o_debug_data(o_MEM_DataMemoryDebug)
    );
  

endmodule
`timescale 1ns / 1ps

module ID
    #(
        parameter   NBITS           = 32,
        parameter   NBITSJUMP       = 26,
        parameter   REGS            = 5,
        parameter   TAM_REG         = 32,
        parameter   INBITS          = 16,
        parameter   TNBITS          = 2
        
    )
    (
        input   wire                            i_clk,
        input   wire                            i_reset,
        input   wire                            i_step,
        input   wire                            i_mem_wb_regwrite,
        input   wire     [REGS-1:0]             i_dir_rs,
        input   wire     [REGS-1:0]             i_dir_rt,
        input   wire     [REGS-1:0]             i_tx_dir_debug,
        input   wire     [REGS-1:0]             i_wb_dir_rd,
        input   wire     [NBITS-1:0]            i_wb_write,
        input   wire     [NBITSJUMP-1:0]        i_if_id_jump,
        input   wire     [NBITS-1:0]            i_id_expc4,
        input   wire     [INBITS-1:0]           i_id_inmediate,
        input   wire     [TNBITS-1:0]           i_rctrl_extensionmode,
        output  wire     [NBITS-1:0]            o_data_rs,
        output  wire     [NBITS-1:0]            o_data_rt,
        output  wire     [NBITS-1:0]            o_data_tx_debug,
        output  wire     [NBITS-1:0]            o_id_jump,  
        output  wire     [NBITS-1:0]            o_extensionresult
        
    );

  
    Sumador_PC_Jump
    #(
        .NBITS      (NBITS),
        .NBITSJUMP  (NBITSJUMP)
    )
    u_Sumador_PC_Jump
    (
        .i_if_id_jump    (i_if_id_jump),
        .i_id_expc4      (i_id_expc4),
        .o_IJump         (o_id_jump)
    );
    
    
    register_file
    #(
        .REGS        (REGS),
        .NBITS       (NBITS),
        .TAM         (TAM_REG)
    )
    u_register_file
    (
        .i_clk               (i_clk),
        .i_reset             (i_reset),
        .i_step              (i_step),
        .i_RegWrite          (i_mem_wb_regwrite),
        .i_dir_rs            (i_dir_rs),
        .i_dir_rt            (i_dir_rt),
        .i_RegDebug          (i_tx_dir_debug),
        .i_RD                (i_wb_dir_rd),
        .i_DatoEscritura     (i_wb_write),
        .o_data_rs           (o_data_rs),
        .o_data_rt           (o_data_rt),
        .o_RegDebug          (o_data_tx_debug)

    );
  
  
    Extensor_Signo
    #(
        .i_NBITS                 (INBITS),
        .e_NBITS                 (INBITS),
        .o_NBITS                 (NBITS)
    )
    u_Extensor_Signo
    (
        .i_id_inmediate         (i_id_inmediate),
        .i_extension_mode       (i_rctrl_extensionmode),
        .o_extensionresult      (o_extensionresult)
    );

endmodule
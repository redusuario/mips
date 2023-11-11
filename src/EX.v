`timescale 1ns / 1ps

module EX
    #(
        parameter   NBITS           = 32,
        parameter   ALUOP           = 4,
        parameter   NB_OP           = 4,
        parameter   REGS            = 5,
        parameter   CORTOCIRCUITO   = 3
    )
    (
        input  wire      [NBITS-1:0]           i_id_extension,
        input  wire      [NBITS-1:0]           i_id_pc4,
        input  wire      [REGS-1:0]            i_shamt,
        input  wire                            i_usahmt,
        input  wire      [ALUOP-1:0]           i_operation,
        input  wire      [CORTOCIRCUITO-1:0]   i_corto_cir_regA,  
        input  wire      [NBITS-1 :0]          i_reg1,
        input  wire      [NBITS-1:0]           i_ex_mem_reg, 
        input  wire      [NBITS-1:0]           i_wb_write_data,
        input  wire                            i_ide_Ex_alu_src,
        input  wire      [CORTOCIRCUITO-1:0]   i_corto_circuito_regb,
        input  wire      [NBITS-1:0]           i_id_Ex_reg2,
        input  wire                            i_select_reg,
        input  wire      [REGS-1:0]            i_reg_rt,
        input  wire      [REGS-1:0]            i_reg_rd,
        output wire      [NBITS-1:0]           o_sum_pc_branch,
        output wire      [NBITS-1:0]           o_data_a,
        output wire                            o_cero,
        output wire      [NBITS-1:0]           o_alu_result,
        output wire      [REGS-1:0]            o_mux_reg_rd 
        
    );


        wire             [NBITS-1:0]           mux_data_a;
        wire             [NBITS-1:0]           o_mux_data_b;

        assign            o_data_a  =          mux_data_a;
   


    Sumador_Branch
    #
    (
        .NBITS              (NBITS)
    )
    u_Sumador_Branch
    (
        .i_extension_data            (i_id_extension ),
        .i_sumador_pc4               (i_id_pc4),
        .o_sum_pc_branch             (o_sum_pc_branch)
    );


    ALU
    #(
        .NBITS                        (NBITS),
        .RNBITS                       (REGS),
        .NB_OP                        (NB_OP )
    )
    u_ALU
    (
        .i_data_1                     (mux_data_a),
        .i_data_2                     (o_mux_data_b),
        .i_shamt                      (i_shamt),
        .i_UShamt                     (i_usahmt),
        .i_operation                  (i_operation),
        .o_cero                       (o_cero),
        .o_result                     (o_alu_result)
    );

    Mux_ALU_Shamt
    #(
        .NBITS                         (NBITS),
        .CORTOCIRCUITO                 (CORTOCIRCUITO)
    )
    u_Mux_ALU_Shamt
    (
        .i_corto_cir_regA             (i_corto_cir_regA),
        .i_ID_EX_Registro             (i_reg1),
        .i_ex_mem_reg                 (i_ex_mem_reg),
        .i_MEM_WR_Registro            (i_wb_write_data),
        .o_mux_alu                    (mux_data_a)
    );
    
    Mux_ALU
    #(
        .NBITS                      (NBITS),
        .CORTOCIRCUITO              (CORTOCIRCUITO)
    )
    u_Mux_ALU
    (
        .i_ALUSrc                   (i_ide_Ex_alu_src),
        .i_corto_circuito_regb      (i_corto_circuito_regb),
        .i_registro                 (i_id_Ex_reg2),
        .i_extension_data           (i_id_extension),
        .i_ex_mem_reg               (i_ex_mem_reg),
        .i_MEM_WR_Operando          (i_wb_write_data),
        .o_mux_data_b               (o_mux_data_b)
    );
    
    
    Mux_Registro
    #(
        .NBITS                      (REGS)
    )
    u_Mux_Registro
    (
        .i_RegDst                   (i_select_reg ),
        .i_reg_rt                   (i_reg_rt),
        .i_reg_rd                   (i_reg_rd),
        .o_registro                 (o_mux_reg_rd)
    );

   
    

endmodule
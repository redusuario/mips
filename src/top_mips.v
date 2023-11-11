`timescale 1ns / 1ps

//module MIPS
module MIPS
    #(
        parameter   NBITS           = 32,
        parameter   SIZE_REG        = 32,
        parameter   SIZE_M          = 10,
        parameter   SIZE_INSTRUC    = 256, // 64
        parameter   BIT_SIZE_INSTRUC    = 8,
        parameter   NBITSJUMP       = 26,
        parameter   INBITS          = 16,
        parameter   HWORDBITS       = 16,
        parameter   BYTENBITS       = 8,
        parameter   ALUNBITS        = 6,
        parameter   ALUCNBITS       = 2,
        parameter   ALUOP           = 4,
        parameter   NB_OP           = 4,
        parameter   TNBITS          = 2,
        parameter   CTRLNBITS       = 6,
        parameter   REGS            = 5,
        parameter   CORTOCIRCUITO   = 3
    )
    (
        input   wire                                i_clk,
        input   wire                                i_reset,
        input   wire                                i_control_clk_wiz,
        input   wire     [REGS-1:0]                 i_select_reg_dir,
        input   wire     [NBITS-1:0]                i_select_mem_dir,
        input   wire     [BIT_SIZE_INSTRUC-1:0]     i_select_mem_ins_dir,
        input   wire     [NBITS-1:0]                i_dato_mem_ins,
        input   wire                                i_write_mem_ins,
        output  wire     [NBITS-1:0]                o_pc,
        output  wire     [NBITS-1:0]                o_data_reg_file,
        output  wire     [NBITS-1:0]                o_data_mem,
        output  wire                                o_mips_halt
    );

    //    IF

    //PC
    wire    [NBITS-1:0]        IF_PC4_o;
    wire    [NBITS-1:0]        IF_PC8_o;

    //MemoriaInstrucciones
    wire    [NBITS-1:0]        IF_Instr;
    wire    [NBITS-1:0]        IF_DatoInstrDebug_i;
    wire    [NBITS-1:0]        IF_DirecInstrDebug_i;

    //   IF_ID  
    wire    [NBITS-1:0]        IF_ID_PC4;
    wire    [NBITS-1:0]        IF_ID_PC8;
    wire    [NBITS-1:0]        IF_ID_Instr;

    //    ID     
    // Unidad Riesgos
    wire                            if_risk_pc_write;
    wire                            if_id_risk_Write;
    wire                            id_risk_Mux;
    wire                            id_risk_latch_flush;

    // Unidad Control
    wire     [CTRLNBITS-1:0]        ID_InstrControl;
    wire     [CTRLNBITS-1:0]        ID_InstrSpecial;
    wire                            ctl_unidad_regWrite;
    wire                            ctl_unidad_mem_to_reg;
    wire                            ctl_unidad_branch;
    wire     [ALUCNBITS-1:0]        ctl_unidad_alu_op;
    wire     [TNBITS-1:0]           ctl_unidad_extend_mode;
    wire     [TNBITS-1:0]           ctl_unidad_size_filter;
    wire     [TNBITS-1:0]           ctl_unidad_size_filterL;
    wire                            ctl_unidad_Nbranch;
    wire                            ctl_unidad_jump;
    wire                            ctl_unidad_jal;
    wire                            ctl_unidad_reg_rd;
    wire                            ctl_unidad_alu_src;
    wire                            ctl_unidad_mem_read;
    wire                            ctl_unidad_mem_write;
    wire                            ctl_unidad_zero_extend;
    wire                            ctl_unidad_lui;
    wire                            ctl_unidad_jalR;
    wire                            ctl_unidad_halt;

    //Mux Unidad Riesgos
    wire                            Rctl_unidad_regWrite;
    wire                            Rctl_unidad_mem_to_reg;
    wire                            Rctl_unidad_branch;
    wire     [ALUCNBITS-1:0]        Rctl_unidad_alu_op;
    wire     [TNBITS-1:0]           Rctl_unidad_extend_mode;
    wire                            Rctl_unidad_Nbranch;
    wire                            Rctl_unidad_jump;
    wire                            Rctl_unidad_jal;
    wire                            Rctl_unidad_reg_rd;
    wire                            Rctl_unidad_alu_src;
    wire                            Rctl_unidad_mem_read;
    wire                            Rctl_unidad_mem_write;
    wire     [TNBITS-1:0]           Rctl_unidad_size_filter;
    wire     [TNBITS-1:0]           Rctl_unidad_size_filterL;
    wire                            Rctl_unidad_zero_extend ;
    wire                            Rctl_unidad_lui;
    wire                            Rctl_unidad_jalR;
    wire                            Rctl_unidad_halt;
    
    //Sumador PC Jump 
    wire     [NBITSJUMP-1:0]        ID_Jump_i;
    wire     [NBITS-1:0]            ID_Jump_o;

    //Regs
    wire     [REGS-1:0]            ID_Reg_rs_i;
    wire     [REGS-1:0]            ID_Reg_rd_i;
    wire     [REGS-1:0]            ID_Reg_rt_i;
    wire     [NBITS-1:0]           ID_data_read1;
    wire     [NBITS-1:0]           ID_data_read2;
    wire     [NBITS-1:0]           ID_Reg_Debug;

    // Extensor de signo
    wire     [INBITS-1:0]          ID_Instr16_i;
    wire     [NBITS-1:0]           ID_InstrExt;

    //   ID_EX
    wire    [NBITS-1:0]            ID_EX_PC4;
    wire    [NBITS-1:0]            ID_EX_PC8;
    wire    [NBITS-1:0]            ID_EX_Reg1;
    wire    [NBITS-1:0]            ID_EX_Reg2;
    wire    [REGS-1:0]             ID_EX_Rs;
    wire    [REGS-1:0]             ID_EX_Rt;
    wire    [REGS-1:0]             ID_EX_Rd;
    wire    [NBITS-1:0]            ID_EX_DJump;
    wire    [NBITS-1:0]            ID_EX_Extension;
    wire    [NBITS-1:0]            ID_EX_Instr;

    //ID/EX/CONTROL
    wire                           ID_EX_ctl_unidad_alu_src;
    wire                           ID_EX_ctl_unidad_jump;
    wire                           ID_EX_ctl_unidad_jal;
    wire    [1:0]                  ID_EX_ctl_unidad_alu_op;
    wire                           ID_EX_ctl_unidad_reg_rd;
    wire                           ID_EX_ctl_unidad_branch;
    wire                           ID_EX_ctl_unidad_Nbranch;
    wire                           ID_EX_ctl_unidad_mem_write;
    wire                           ID_EX_ctl_unidad_mem_read;
    wire                           ID_EX_ctl_unidad_mem_to_reg;
    wire                           ID_EX_ctl_unidad_regWrite;
    wire                           ID_EX_ctl_unidad_lui;
    wire                           ID_EX_ctl_unidad_jalR;
    wire                           ID_EX_ctl_unidad_halt;
    wire    [1:0]                  ID_EX_ctl_unidad_size_filter;
    wire    [1:0]                  ID_EX_ctl_unidad_size_filterL;
    wire                           ID_EX_ctl_unidad_zero_extend;


    //MuxShamt
    wire     [NBITS-1:0]           EX_AluRegA_i;
    //ALU
    wire     [NBITS-1:0]           EX_ALUResult_o;
    wire                           EX_AluCero_o;
    wire     [REGS-1 :0]           EX_AluShamtInstr_i  ;
    //ALUControl
    wire     [ALUNBITS-1:0]        EX_AluCtrlInstr_i;
    wire     [ALUNBITS-1:0]        EX_AluCtrlOpcode_i;
    wire     [ALUOP-1:0]           EX_ALUCtrlOp_o;
    wire                           EX_UShamt;

    //Sumador branch
    wire     [NBITS-1:0]           EX_SumPcBranch_o;

    //MultiplexorRegistro
    wire     [REGS-1:0]            EX_Mux_Reg_rd_o;


    //UnidadCortocircuito
    wire    [CORTOCIRCUITO-1:0]   Cortocircuito_RegA;
    wire    [CORTOCIRCUITO-1:0]   Cortocircuito_RegB;

    //   EX_MEM
    wire    [NBITS-1:0]           EX_MEM_PC4;
    wire    [NBITS-1:0]           EX_MEM_PC8;
    wire    [NBITS-1:0]           EX_MEM_PCBranch;
    wire    [NBITS-1:0]           EX_MEM_Instr;
    wire                          EX_MEM_Cero;
    wire    [NBITS-1:0]           EX_MEM_ALU;
    wire    [NBITS-1:0]           EX_MEM_Reg2;
    wire    [REGS-1:0]            EX_MEM_RegistroDestino;
    wire    [NBITS-1:0]           EX_MEM_Extension;
    wire                          EX_MEM_Branch;
    wire                          EX_MEM_NBranch;
    wire                          EX_MEM_MemWrite;
    wire                          EX_MEM_MemRead;
    wire                          EX_MEM_MemToReg;
    wire                          EX_MEM_RegWrite;
    wire    [1:0]                 EX_MEM_TamanoFiltro;
    wire    [1:0]                 EX_MEM_TamanoFiltroL;
    wire                          EX_MEM_ZeroExtend;
    wire                          EX_MEM_LUI;
    wire                          EX_MEM_HALT;

    //    MEM    

    //MultiplexorBranch
    wire                            MEM_PcSrc_o;

    //Memoria de datos
    wire    [NBITS-1:0]     MEM_DatoMemoria_o;
    wire    [NBITS-1:0]     MEM_DatoMemoriaDebug_o; 

    //   MEM_WB  

    wire    [NBITS-1:0]     MEM_WB_PC4;
    wire    [NBITS-1:0]     MEM_WB_PC8;
    wire    [NBITS-1:0]     MEM_WB_Instruction;
    wire    [NBITS-1:0]     MEM_WB_ALU;
    wire    [NBITS-1:0]     MEM_WB_DatoMemoria;
    wire    [REGS-1:0]      MEM_WB_RegistroDestino;
    wire    [NBITS-1:0]     MEM_WB_Extension ;
    wire                    MEM_WB_JAL;
    wire                    MEM_WB_MemToReg;
    wire                    MEM_WB_RegWrite;
    wire    [1:0]           MEM_WB_TamanoFiltroL;
    wire                    MEM_WB_ZeroExtend ;
    wire                    MEM_WB_LUI ;
    wire                    MEM_WB_HALT ;


    //    WB     

    //MultiplexorMemoria 
    wire    [NBITS-1:0]             WB_DatoEscritura_o;

    wire    [REGS-1:0]              WB_RegistroDestino_o;
    //MultiplexorEscribirDato
    wire    [NBITS-1:0]             WB_EscribirDato_o;

    // ID
    assign ID_InstrControl     =    IF_ID_Instr     [NBITS-1:NBITS-CTRLNBITS];
    assign ID_InstrSpecial     =    IF_ID_Instr     [CTRLNBITS-1:0] ;
    assign ID_Jump_i           =    IF_ID_Instr     [NBITSJUMP-1:0] ;

    //Memoria de instrucciones
    assign IF_DirecInstrDebug_i =   i_select_mem_ins_dir;
    assign IF_DatoInstrDebug_i  =   i_dato_mem_ins;
    assign IF_WriteInstrDebug_i =   i_write_mem_ins;

    // EX
    // ALU Control
    assign EX_AluCtrlInstr_i   =    ID_EX_Extension [ALUNBITS-1:0];
    assign EX_AluCtrlOpcode_i  =    ID_EX_Instr     [NBITS-1:REGS+REGS+INBITS];
    //SumadorJump

    assign EX_AluShamtInstr_i  =    ID_EX_Instr    [10:6];
    //Registros
    assign ID_Reg_rs_i         =    IF_ID_Instr    [INBITS+REGS+REGS-1:INBITS+REGS];//INBITS+RT+RS-1=16+5+5-1=25; INBITS+RT=16+5=21; [25-21]
    assign ID_Reg_rt_i         =    IF_ID_Instr    [INBITS+REGS-1:INBITS];//INBITS+RT-1=16+5-1=20; INBITS=16; [20-16]
    assign ID_Reg_rd_i         =    IF_ID_Instr    [INBITS-1:INBITS-REGS]; //INBITS-1=16-1=15; INBITS-RD=16-5=11; [15-11]
    assign o_data_reg_file     =    ID_Reg_Debug;
    
    //Memoria de datos
    assign o_data_mem          =    MEM_DatoMemoriaDebug_o;    
    
    //Extensor
    assign ID_Instr16_i        =   IF_ID_Instr     [INBITS-1:0];

    // OUTPUT
    assign o_mips_halt = MEM_WB_HALT  ;

//////////////////ETAPA IF
    IF
    #(
        .NBITS                      (NBITS),
        .TAM_I                      (SIZE_INSTRUC)
    )
    u_IF
    (
        .i_step                     (i_control_clk_wiz),
        .i_reset                    (i_reset),
        .i_clk                      (i_clk),
        .i_instruction              (IF_DatoInstrDebug_i),
        .i_address_memory_ins       (IF_DirecInstrDebug_i),
        .i_write_intruc             (IF_WriteInstrDebug_i),
        .hazard_pc_Write            (if_risk_pc_write),
        .IF_PC_o                    (o_pc),
        .IF_PC4_o                   (IF_PC4_o),
        .IF_PC8_o                   (IF_PC8_o),
        .i_Jump                     (ID_EX_ctl_unidad_jump),
        .i_JALR                     (ID_EX_ctl_unidad_jalR),
        .i_pc_src                   (MEM_PcSrc_o),
        .i_SumadorBranch            (EX_MEM_PCBranch),
        .i_SumadorJump              (ID_EX_DJump),
        .i_rs                       (EX_AluRegA_i),
        .o_instruction              (IF_Instr)
    );

    ///  ETAPA IF/ID

    IF_ID
    #(
        .NBITS              (NBITS)
    )
    u_IF_ID
    (
        .i_clk              (i_clk),
        .i_reset            (i_reset),
        .i_step             (i_control_clk_wiz),
        .i_IF_ID_Write      (if_id_risk_Write),
        .i_pc4              (IF_PC4_o),
        .i_pc8              (IF_PC8_o),
        .i_Instruction      (IF_Instr),
        .o_pc4              (IF_ID_PC4),
        .o_pc8              (IF_ID_PC8),
        .o_instruction      (IF_ID_Instr)
    );

    //ETAPA ID  


    ID
    #(
        .NBITS               (NBITS),
        .NBITSJUMP           (NBITSJUMP),
        .REGS                (REGS),
        .TAM_REG             (SIZE_REG),
        .INBITS              (INBITS),
        .TNBITS              (TNBITS)
    )
    u_ID
    (
        .i_clk                 (i_clk),
        .i_reset               (i_reset),
        .i_step                (i_control_clk_wiz),
        .i_mem_wb_regwrite     (MEM_WB_RegWrite),
        .i_dir_rs              (ID_Reg_rs_i),
        .i_dir_rt              (ID_Reg_rt_i),
        .i_tx_dir_debug        (i_select_reg_dir),
        .i_wb_dir_rd           (WB_RegistroDestino_o),
        .i_wb_write            (WB_EscribirDato_o),
        .i_if_id_jump          (ID_Jump_i),
        .i_id_expc4            (ID_EX_PC4),
        .i_id_inmediate        (ID_Instr16_i),
        .i_rctrl_extensionmode (ctl_unidad_extend_mode),
        .o_data_rs             (ID_data_read1),
        .o_data_rt             (ID_data_read2),
        .o_data_tx_debug       (ID_Reg_Debug),
        .o_id_jump             (ID_Jump_o),
        .o_extensionresult     (ID_InstrExt) 
    );
  
    // UNIDAD DE CONTROL

    Control_Unidad
    #(
        .NBITS                      (CTRLNBITS   )
    )
    u_Control_Unidad
    (
        .i_Instruction              (ID_InstrControl     ),
        .i_Special                  (ID_InstrSpecial     ),
        .o_RegDst                   (ctl_unidad_reg_rd         ),
        .o_Jump                     (ctl_unidad_jump           ),
        .o_JAL                      (ctl_unidad_jal            ),
        .o_Branch                   (ctl_unidad_branch         ),
        .o_NBranch                  (ctl_unidad_Nbranch        ),
        .o_MemRead                  (ctl_unidad_mem_read        ),
        .o_MemToReg                 (ctl_unidad_mem_to_reg),
        .o_ALUOp                    (ctl_unidad_alu_op          ),
        .o_MemWrite                 (ctl_unidad_mem_write       ),
        .o_ALUSrc                   (ctl_unidad_alu_src         ),
        .o_RegWrite                 (ctl_unidad_regWrite       ),
        .o_ExtensionMode            (ctl_unidad_extend_mode  ),
        .o_TamanoFiltro             (ctl_unidad_size_filter   ),
        .o_TamanoFiltroL            (ctl_unidad_size_filterL  ),
        .o_ZeroExtend               (ctl_unidad_zero_extend     ),
        .o_LUI                      (ctl_unidad_lui            ),
        .o_JALR                     (ctl_unidad_jalR           ),
        .o_HALT                     (ctl_unidad_halt           )
    );

    // UNIDAD DE RIESGOS
    ID_Unidad_Riesgos
    #(
        .RNBITS                      (REGS)
    )
    u_ID_Unidad_Riesgos
    (
        .i_EX_MEM_Flush             (MEM_PcSrc_o),
        .i_ID_EX_MemRead            (ID_EX_ctl_unidad_mem_read),
        .i_EX_MEM_MemRead           (EX_MEM_MemRead),
        .i_JALR                     (ctl_unidad_jalR),
        .i_HALT                     (ctl_unidad_halt),
        .i_ID_EX_Rt                 (ID_EX_Rt ),
        .i_EX_MEM_Rt                (EX_MEM_RegistroDestino),
        .i_IF_ID_Rs                 (ID_Reg_rs_i),
        .i_IF_ID_Rt                 (ID_Reg_rt_i),
        .o_Mux_Risk                 (id_risk_Mux),
        .o_pc_Write                 (if_risk_pc_write),
        .o_IF_ID_Write              (if_id_risk_Write),
        .o_Latch_Flush              (id_risk_latch_flush)
    );


    // MUX UNIDAD DE RIESGOS

    ID_Mux_Unidad_Riesgos
    #(
    )
    u_ID_Mux_Unidad_Riesgos
    (
        .i_Risk                     (id_risk_Mux         ),
        .i_RegDst                   (ctl_unidad_reg_rd        ),
        .i_Jump                     (ctl_unidad_jump          ),
        .i_JAL                      (ctl_unidad_jal           ),
        .i_Branch                   (ctl_unidad_branch        ),
        .i_NBranch                  (ctl_unidad_Nbranch       ),
        .i_MemRead                  (ctl_unidad_mem_read       ),
        .i_MemToReg                 (ctl_unidad_mem_to_reg      ),
        .i_ALUOp                    (ctl_unidad_alu_op         ),
        .i_MemWrite                 (ctl_unidad_mem_write      ),
        .i_ALUSrc                   (ctl_unidad_alu_src        ),
        .i_RegWrite                 (ctl_unidad_regWrite      ),
        .i_extension_mode            (ctl_unidad_extend_mode ),
        .i_TamanoFiltro             (ctl_unidad_size_filter  ),
        .i_TamanoFiltroL            (ctl_unidad_size_filterL ),
        .i_ZeroExtend               (ctl_unidad_zero_extend    ),
        .i_LUI                      (ctl_unidad_lui           ),
        .i_JALR                     (ctl_unidad_jalR          ),
        .i_HALT                     (ctl_unidad_halt          ),
        .o_RegDst                   (Rctl_unidad_reg_rd        ),
        .o_Jump                     (Rctl_unidad_jump          ),
        .o_JAL                      (Rctl_unidad_jal           ),
        .o_Branch                   (Rctl_unidad_branch        ),
        .o_NBranch                  (Rctl_unidad_Nbranch       ),
        .o_MemRead                  (Rctl_unidad_mem_read       ),
        .o_MemToReg                 (Rctl_unidad_mem_to_reg      ),
        .o_ALUOp                    (Rctl_unidad_alu_op         ),
        .o_MemWrite                 (Rctl_unidad_mem_write      ),
        .o_ALUSrc                   (Rctl_unidad_alu_src        ),
        .o_RegWrite                 (Rctl_unidad_regWrite      ),
        .o_ExtensionMode            (Rctl_unidad_extend_mode ),
        .o_TamanoFiltro             (Rctl_unidad_size_filter  ),
        .o_TamanoFiltroL            (Rctl_unidad_size_filterL ),
        .o_ZeroExtend               (Rctl_unidad_zero_extend    ),
        .o_LUI                      (Rctl_unidad_lui           ),
        .o_JALR                     (Rctl_unidad_jalR          ),
        .o_HALT                     (Rctl_unidad_halt          )
    );  


    // ETAPA ID/EX

    ID_EX
    #(
        .NBITS                      (NBITS          ),
        .RNBITS                     (REGS           )
    )
    u_ID_EX
    (
        //General
        .i_clk                      (i_clk                      ),
        .i_reset                    (i_reset                    ),
        .i_step                     (i_control_clk_wiz),
        .i_Flush                    (id_risk_latch_flush         ),
        .i_pc4                      (IF_ID_PC4                ),
        .i_pc8                      (IF_ID_PC8                ),
        .i_Instruction              (IF_ID_Instr              ),

        //ControlEX
        .i_Jump                     (Rctl_unidad_jump               ),
        .i_JAL                      (Rctl_unidad_jal                ),
        .i_ALUSrc                   (Rctl_unidad_alu_src             ),

        .i_ALUOp                    (Rctl_unidad_alu_op              ),
        .i_RegDst                   (Rctl_unidad_reg_rd             ),
        //ControlM
        .i_Branch                   (Rctl_unidad_branch             ),
        .i_NBranch                  (Rctl_unidad_Nbranch            ),
        .i_MemWrite                 (Rctl_unidad_mem_write           ),
        .i_MemRead                  (Rctl_unidad_mem_read            ),
        .i_TamanoFiltro             (Rctl_unidad_size_filter       ),
        //ControlWB
        .i_MemToReg                 (Rctl_unidad_mem_to_reg           ),
        .i_RegWrite                 (Rctl_unidad_regWrite           ),
        .i_TamanoFiltroL            (Rctl_unidad_size_filterL      ),
        .i_ZeroExtend               (Rctl_unidad_zero_extend         ),
        .i_LUI                      (Rctl_unidad_lui                ),
        .i_JALR                     (Rctl_unidad_jalR               ),
        .i_HALT                     (Rctl_unidad_halt               ),

        //Modules
        .i_Reg1                     (ID_data_read1         ),
        .i_Reg2                     (ID_data_read2         ),
        .i_extension                (ID_InstrExt           ),
        .i_rs                       (ID_Reg_rs_i             ),
        .i_rt                       (ID_Reg_rt_i             ),
        .i_Rd                       (ID_Reg_rd_i             ),
        .i_DJump                    (ID_Jump_o               ),

        .o_pc4                      (ID_EX_PC4          ),
        .o_pc8                      (ID_EX_PC8          ),
        .o_instruction              (ID_EX_Instr        ),
        .o_Registro1                (ID_EX_Reg1    ),
        .o_Registro2                (ID_EX_Reg2    ),
        .o_Extension                (ID_EX_Extension    ),
        .o_Rs                       (ID_EX_Rs           ),
        .o_Rt                       (ID_EX_Rt           ),
        .o_Rd                       (ID_EX_Rd           ),
        .o_DJump                    (ID_EX_DJump        ),

        //ControlEX
        .o_Jump                     (ID_EX_ctl_unidad_jump         ),
        .o_JALR                     (ID_EX_ctl_unidad_jalR         ),
        .o_JAL                      (ID_EX_ctl_unidad_jal          ),
        .o_ALUSrc                   (ID_EX_ctl_unidad_alu_src       ),
        .o_ALUOp                    (ID_EX_ctl_unidad_alu_op        ),
        .o_RegDst                   (ID_EX_ctl_unidad_reg_rd       ),
        //ControlM
        .o_Branch                   (ID_EX_ctl_unidad_branch       ),
        .o_NBranch                  (ID_EX_ctl_unidad_Nbranch      ),
        .o_MemWrite                 (ID_EX_ctl_unidad_mem_write     ),
        .o_MemRead                  (ID_EX_ctl_unidad_mem_read      ),
        .o_TamanoFiltro             (ID_EX_ctl_unidad_size_filter ),
        //ControlWB
        .o_MemToReg                 (ID_EX_ctl_unidad_mem_to_reg     ),
        .o_RegWrite                 (ID_EX_ctl_unidad_regWrite),
        .o_TamanoFiltroL            (ID_EX_ctl_unidad_size_filterL),
        .o_ZeroExtend               (ID_EX_ctl_unidad_zero_extend   ),
        .o_LUI                      (ID_EX_ctl_unidad_lui          ),
        .o_HALT                     (ID_EX_ctl_unidad_halt         )
    );

    //ETAPA EX

    EX
    #
    (
        .NBITS                 (NBITS),
        .REGS                  (REGS),
        .NB_OP                 (NB_OP),
        .CORTOCIRCUITO         (CORTOCIRCUITO)
    )
    u_EX
    (
        .i_id_extension        (ID_EX_Extension),
        .i_id_pc4              (ID_EX_PC4),
        .i_shamt               (EX_AluShamtInstr_i),
        .i_usahmt              (EX_UShamt),
        .i_operation           (EX_ALUCtrlOp_o), 
        .i_corto_cir_regA      (Cortocircuito_RegA),
        .i_reg1                (ID_EX_Reg1),
        .i_ex_mem_reg          (EX_MEM_ALU),
        .i_wb_write_data       (WB_DatoEscritura_o),   
        .i_ide_Ex_alu_src      (ID_EX_ctl_unidad_alu_src),
        .i_corto_circuito_regb (Cortocircuito_RegB),
        .i_id_Ex_reg2          (ID_EX_Reg2),
        .i_select_reg          (ID_EX_ctl_unidad_reg_rd),
        .i_reg_rt              (ID_EX_Rt),
        .i_reg_rd              (ID_EX_Rd),
        .o_cero                (EX_AluCero_o),
        .o_alu_result          (EX_ALUResult_o),
        .o_sum_pc_branch       (EX_SumPcBranch_o),
        .o_data_a              (EX_AluRegA_i),
        .o_mux_reg_rd          (EX_Mux_Reg_rd_o)
    );


    // CONTROL ALU

    Control_ALU
    #(
        .ANBITS                    (ALUNBITS ),
        .NBITSCONTROL              (ALUCNBITS),
        .ALUOP                     (ALUOP)
    )
    u_Control_ALU
    (
        .i_Funct                   (EX_AluCtrlInstr_i      ),
        .i_Opcode                  (EX_AluCtrlOpcode_i     ),
        .i_ALUOp                   (ID_EX_ctl_unidad_alu_op       ),
        .o_ALUOp                   (EX_ALUCtrlOp_o         ),
        .o_Shamt                   (EX_UShamt              )

    );
   
    // UNIDAD DE CORTOCIRCUITO

    EX_Unidad_Cortocircuito
    #(
        .RNBITS     (REGS ),
        .MUXBITS    (CORTOCIRCUITO)
    )
    u_Ex_Unidad_Cortocircuito
    (
        .i_EX_MEM_RegWrite  (EX_MEM_RegWrite        ), //Se escribe Registro Destino en EX/MEM
        .i_EX_MEM_Rd        (EX_MEM_RegistroDestino ), //Registro destino en EX/MEM
        .i_MEM_WR_RegWrite  (MEM_WB_RegWrite        ), //Se escribe Registro Destino en MEM/WB
        .i_MEM_WR_Rd        (MEM_WB_RegistroDestino ), //Registro destino en MEM/WB
        .i_rs               (ID_EX_Rs               ), //Rs para comparar con Registro Destino
        .i_rt               (ID_EX_Rt               ), //Rt para comparar con Registro Destino
        .o_mux_A            (Cortocircuito_RegA     ), //para RegistroA
        .o_mux_B            (Cortocircuito_RegB     )  //para RegistroB
    );


    EX_MEM
    #(
        .NBITS  (NBITS),
        .REGS   (REGS)
    )
    u_EX_MEM
    (
        //General
        .i_clk                      (i_clk),
        .i_reset                    (i_reset),
        .i_step                     (i_control_clk_wiz),
        .i_Flush                    (id_risk_latch_flush     ),
        .i_pc4                      (ID_EX_PC4              ),
        .i_pc8                      (ID_EX_PC8              ),
        .i_pcBranch                 (EX_SumPcBranch_o       ),
        .i_Instruction              (ID_EX_Instr            ),
        .i_cero                     (EX_AluCero_o           ),
        .i_ALU                      (EX_ALUResult_o         ),
        .i_Reg2                     (ID_EX_Reg2        ),
        .i_RegistroDestino          (EX_Mux_Reg_rd_o        ),
        .i_extension                (ID_EX_Extension        ),

        //ControlIM
        .i_JAL                      (ID_EX_ctl_unidad_jal           ),
        .i_Branch                   (ID_EX_ctl_unidad_branch        ),
        .i_NBranch                  (ID_EX_ctl_unidad_Nbranch       ),
        .i_MemWrite                 (ID_EX_ctl_unidad_mem_write      ),
        .i_MemRead                  (ID_EX_ctl_unidad_mem_read       ),
        .i_TamanoFiltro             (ID_EX_ctl_unidad_size_filter  ),
        //ControlWB
        .i_MemToReg                 (ID_EX_ctl_unidad_mem_to_reg      ),
        .i_RegWrite                 (ID_EX_ctl_unidad_regWrite),
        .i_TamanoFiltroL            (ID_EX_ctl_unidad_size_filterL ),
        .i_ZeroExtend               (ID_EX_ctl_unidad_zero_extend    ),
        .i_LUI                      (ID_EX_ctl_unidad_lui           ),
        .i_HALT                     (ID_EX_ctl_unidad_halt          ),

        .o_pc4                      (EX_MEM_PC4             ),
        .o_pc8                      (EX_MEM_PC8             ),
        .o_pcBranch                 (EX_MEM_PCBranch        ),
        .o_instruction              (EX_MEM_Instr           ),
        .o_cero                     (EX_MEM_Cero            ),
        .o_ALU                      (EX_MEM_ALU             ),
        .o_Reg2                     (EX_MEM_Reg2       ),
        .o_RegistroDestino          (EX_MEM_RegistroDestino ),
        .o_Extension                (EX_MEM_Extension       ),

        //ControlM
        .o_JAL                      (EX_MEM_JAL             ),
        .o_Branch                   (EX_MEM_Branch          ),
        .o_NBranch                  (EX_MEM_NBranch         ),
        .o_MemWrite                 (EX_MEM_MemWrite        ),
        .o_MemRead                  (EX_MEM_MemRead         ),
        .o_TamanoFiltro             (EX_MEM_TamanoFiltro    ),

        //ControlWB
        .o_MemToReg                 (EX_MEM_MemToReg        ),
        .o_RegWrite                 (EX_MEM_RegWrite        ),
        .o_TamanoFiltroL            (EX_MEM_TamanoFiltroL   ),
        .o_ZeroExtend               (EX_MEM_ZeroExtend      ),
        .o_LUI                      (EX_MEM_LUI             ),
        .o_HALT                     (EX_MEM_HALT            )
    );

    AND_Branch
    #(
    )
    u_AND_Branch
    (
        .i_Branch   (EX_MEM_Branch  ),
        .i_NBranch  (EX_MEM_NBranch ),
        .i_cero     (EX_MEM_Cero    ),
        .o_pcSrc    (MEM_PcSrc_o    )
    );
    
    MEM
    #(
        .NBITS   (NBITS),
        .TNBITS  (TNBITS),
        .TAM_M   (SIZE_M)
    )
    u_MEM
    (
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_mips_clk_ctrl(i_control_clk_wiz),
        .i_EX_MEM_ALU(EX_MEM_ALU),
        .i_mips_mem_debug(i_select_mem_dir),
        .i_EX_MEM_MemRead(EX_MEM_MemRead),
        .i_EX_MEM_MemWrite(EX_MEM_MemWrite),
        .i_EX_MEM_Reg2(EX_MEM_Reg2),
        .i_EX_MEM_TamanoFiltro(EX_MEM_TamanoFiltro),
        .o_MEM_DataMemory(MEM_DatoMemoria_o),
        .o_MEM_DataMemoryDebug(MEM_DatoMemoriaDebug_o)
    );

    MEM_WB
    #(
        .NBITS              (NBITS                  ),
        .RNBITS             (REGS                   )
    )
    u_MEM_WB
    (
        .i_clk              (i_clk                    ),
        .i_reset            (i_reset                  ),
        .i_step             (i_control_clk_wiz),
        .i_pc4              (EX_MEM_PC4             ),
        .i_pc8              (EX_MEM_PC8             ),
        .i_Instruction      (EX_MEM_Instr           ),
        .i_ALU              (EX_MEM_ALU             ),
        .i_DataMemory       (MEM_DatoMemoria_o      ),
        .i_RegistroDestino  (EX_MEM_RegistroDestino ),
        .i_extension        (EX_MEM_Extension       ),

        //ControlWB
        .i_MemToReg         (EX_MEM_MemToReg        ),
        .i_RegWrite         (EX_MEM_RegWrite        ),
        .i_TamanoFiltroL    (EX_MEM_TamanoFiltroL   ),
        .i_ZeroExtend       (EX_MEM_ZeroExtend      ),
        .i_LUI              (EX_MEM_LUI             ),
        .i_JAL              (EX_MEM_JAL             ),
        .i_HALT             (EX_MEM_HALT            ),

        .o_pc4              (MEM_WB_PC4             ),
        .o_pc8              (MEM_WB_PC8             ),
        .o_instruction      (MEM_WB_Instruction     ),
        .o_ALU              (MEM_WB_ALU             ),
        .o_DatoMemoria      (MEM_WB_DatoMemoria     ),
        .o_RegistroDestino  (MEM_WB_RegistroDestino ),
        .o_Extension        (MEM_WB_Extension       ),

        //ControlWB
        .o_MemToReg         (MEM_WB_MemToReg        ),
        .o_RegWrite         (MEM_WB_RegWrite        ),
        .o_TamanoFiltroL    (MEM_WB_TamanoFiltroL   ),
        .o_ZeroExtend       (MEM_WB_ZeroExtend      ),
        .o_LUI              (MEM_WB_LUI             ),
        .o_JAL              (MEM_WB_JAL             ),
        .o_HALT             (MEM_WB_HALT            )
    );

    WB #(
         .NBITS          (NBITS),       
         .HWORDBITS      (HWORDBITS),
         .BYTENBITS      (BYTENBITS),
         .REGS           (REGS),      
         .TNBITS         (TNBITS)              
    )
     u_WB   (
        .i_WB_LUI(MEM_WB_LUI),
        .i_WB_Extend(MEM_WB_Extension),
        .i_WB_DataMemory(MEM_WB_DatoMemoria),
        .i_WB_SizeFiltroL(MEM_WB_TamanoFiltroL),
        .i_WB_ZeroExtend(MEM_WB_ZeroExtend),
        .i_WB_MemToReg(MEM_WB_MemToReg),
        .i_WB_ALU(MEM_WB_ALU),
        .i_WB_JAL(MEM_WB_JAL),
        .i_WB_PC8(MEM_WB_PC8),
        .i_WB_Rd(MEM_WB_RegistroDestino),
        .o_WB_DataWrite(WB_DatoEscritura_o),
        .o_WB_EscribirDato(WB_EscribirDato_o),
        .o_WB_Rd(WB_RegistroDestino_o)
    );

endmodule
`timescale 1ns / 1ps

module MEM_WB
    #(
        parameter NBITS     =   32  ,
        parameter RNBITS    =   5   
    )
    (   
        input   wire                        i_clk,
        input   wire                        i_reset ,
        input   wire    [NBITS-1:0]         i_pc4,
        input   wire    [NBITS-1:0]         i_pc8,
        input   wire                        i_step ,
        input   wire    [NBITS-1:0]         i_Instruction  ,
        input   wire    [NBITS-1:0]         i_ALU,
        input   wire    [NBITS-1:0]         i_DataMemory,
        input   wire    [RNBITS-1:0]        i_RegistroDestino ,
        input   wire    [NBITS-1:0]         i_extension ,
        input   wire                        i_LUI  ,
        input   wire                        i_JAL ,    
        input   wire                        i_HALT ,
        input   wire                        i_MemToReg ,
        input   wire                        i_RegWrite ,
        input   wire    [1:0]               i_TamanoFiltroL ,
        input   wire                        i_ZeroExtend ,
        output  wire    [NBITS-1:0]         o_pc4  ,
        output  wire    [NBITS-1:0]         o_pc8 ,     
        output  wire    [NBITS-1:0]         o_instruction  ,
        output  wire    [NBITS-1:0]         o_ALU    ,
        output  wire    [NBITS-1:0]         o_DatoMemoria ,
        output  wire    [RNBITS-1:0]        o_RegistroDestino   ,
        output  wire    [NBITS-1:0]         o_Extension  ,
        output  wire                        o_JAL    ,
        output  wire                        o_MemToReg   ,
        output  wire                        o_RegWrite  ,
        output  wire    [1          :0]     o_TamanoFiltroL,           
        output  wire                        o_ZeroExtend,
        output  wire                        o_LUI ,
        output  wire                        o_HALT
    );
    
    reg     [NBITS-1:0]         PC4_reg  ;
    reg     [NBITS-1:0]         PC8_reg   ;
    reg     [NBITS-1:0]         Instruction_reg   ;
    reg     [NBITS-1:0]         ALU_reg     ;
    reg     [NBITS-1:0]         DatoMemoria_reg   ;
    reg     [RNBITS-1:0]        RegistroDestino_reg ;
    reg     [NBITS-1:0]         Extension_reg ;
    
    //RegWB
    reg                     JAL_reg  ;
    reg                     MemToReg_reg  ;
    reg                     RegWrite_reg     ;
    reg     [1:0]           TamanoFiltroL_reg   ;
    reg                     ZeroExtend_reg   ;
    reg                     LUI_reg     ;
    reg                     HALT_reg     ;
    
    
    always @(posedge i_clk)
        if(i_reset)
            begin
                PC4_reg             <=  {NBITS{1'b0}}  ;
                PC8_reg             <=  {NBITS{1'b0}}   ;
                Instruction_reg     <=  {NBITS{1'b0}}  ;
                ALU_reg             <=  {NBITS{1'b0}}  ; 
                DatoMemoria_reg     <=  {NBITS{1'b0}}  ;
                RegistroDestino_reg <=  {RNBITS{1'b0}}  ;
                Extension_reg       <=  {NBITS{1'b0}}  ;
                
                //WB
                JAL_reg             <=  1'b0   ;         
                MemToReg_reg        <=  1'b0  ;
                RegWrite_reg        <=  1'b0   ;
                TamanoFiltroL_reg   <=  2'b00   ;
                ZeroExtend_reg      <=  1'b0   ;
                LUI_reg             <=  1'b0   ;
                HALT_reg            <=  1'b0   ;   
            end
        else if (i_step)
            begin 
                PC4_reg             <=  i_pc4  ;
                PC8_reg             <=  i_pc8  ;
                Instruction_reg     <=  i_Instruction  ;
                ALU_reg             <=  i_ALU    ;
                DatoMemoria_reg     <=  i_DataMemory   ;
                RegistroDestino_reg <=  i_RegistroDestino  ;
                Extension_reg       <=  i_extension   ;
                
                //WB
                JAL_reg             <=  i_JAL    ;
                MemToReg_reg        <=  i_MemToReg   ;
                RegWrite_reg        <=  i_RegWrite  ;
                TamanoFiltroL_reg   <=  i_TamanoFiltroL   ;
                ZeroExtend_reg      <=  i_ZeroExtend  ;
                LUI_reg             <=  i_LUI     ;
                HALT_reg            <=  i_HALT   ;
            end

    assign o_pc4                =   PC4_reg   ;
    assign o_pc8                =   PC8_reg    ;
    assign o_instruction        =   Instruction_reg  ;
    assign o_ALU                =   ALU_reg  ;
    assign o_DatoMemoria        =   DatoMemoria_reg  ;
    assign o_RegistroDestino    =   RegistroDestino_reg ;
    assign o_Extension          =   Extension_reg  ;
    
    assign o_JAL            =   JAL_reg     ;
    assign o_MemToReg       =   MemToReg_reg   ;
    assign o_RegWrite       =   RegWrite_reg   ;
    assign o_TamanoFiltroL  =   TamanoFiltroL_reg   ;
    assign o_ZeroExtend     =   ZeroExtend_reg  ;
    assign o_LUI            =   LUI_reg    ;
    assign o_HALT           =   HALT_reg    ;

endmodule

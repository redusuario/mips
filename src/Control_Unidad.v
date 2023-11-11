`timescale 1ns / 1ps
//LW:   100011   base         RT     OFFSET
//LWU:  100111   base         RT     OFFSET
//LB:   100000   base         RT     OFFSET
//LBU:  100100   base         RT     OFFSET
//LH:   100001   base         RT     OFFSET
//LHU:  100101   base         RT     OFFSET
//LUI:  001111   00000        RT     IMMEDIATE
//SW:   101011    base        RT     OFFSET
//SB:   101000    base        RT     OFFSET
//SH:   101001    base        RT     OFFSET
//ADD:  000000     RS         RT     RD     00000      100000
//SUB:  000000     RS         RT     RD     00000      100010
//SUBU: 000000     RS         RT     RD     00000      100011
//AND:  000000     RS         RT     RD     00000      100100
//ANDI: 001100     RS         RT     IMMEDIATE
//OR:   000000     RS         RT     RD     00000      100101
//ORI:  001101     RS        RT     IMMEDIATE
//NOR:  000000     RS         RT     RD     00000      100111
//XOR:  000000     RS         RT     RD     00000      100110
//XORI: 001110     RS         RT     IMMEDIATE
//SLT:  000000     RS         RT     RD     00000      101010
//SLTI: 001010     RS         RT     IMMEDIATE
//BEQ:  000100     RS         RT     OFFSET
//BNE:  000101     RS         RT     OFFSET
//J:    000010     INSTR_INDEX
//ADDI: 001000     RS         RT     IMMEDIATE
//SLL:  000000     000000     RT     RD     sa         000000
//SRL:  000000     000000     RT     RD     sa         000010


module Control_Unidad
    #(
        parameter   NBITS       =   6
    )
    (
        input   wire    [NBITS-1:0]             i_Instruction   ,
        input   wire    [NBITS-1:0]             i_Special       ,
        output  wire                            o_MemToReg      ,
        output  wire    [1:0]                   o_ALUOp         ,
        output  wire                            o_MemWrite      ,
        output  wire                            o_ALUSrc        ,
        output  wire                            o_RegWrite      ,
        output  wire    [1:0]                   o_ExtensionMode ,
        output  wire                            o_RegDst        ,
        output  wire                            o_Jump          ,
        output  wire                            o_JAL           ,
        output  wire                            o_Branch        ,
        output  wire                            o_NBranch       ,
        output  wire                            o_MemRead       ,
        output  wire    [1:0]                   o_TamanoFiltro  ,
        output  wire    [1:0]                   o_TamanoFiltroL ,
        output  wire                            o_ZeroExtend    ,
        output  wire                            o_LUI           ,
        output  wire                            o_JALR          ,
        output  wire                            o_HALT
    );
localparam LW     = 6'b100011;
localparam LWU    = 6'b100111;
localparam LB     = 6'b100000;
localparam LBU    = 6'b100100;
localparam LH     = 6'b100001;
localparam LHU    = 6'b100101;
localparam LUI    = 6'b001111;
localparam SW     = 6'b101011;
localparam SB     = 6'b101000;
localparam SH     = 6'b101001;
localparam BEQ    = 6'b000100;
localparam BNE    = 6'b000101;
localparam J      = 6'b000010;
localparam JAL    = 6'b000011;
localparam BAS    = 6'b000000;
localparam ADDI   = 6'b001000;
localparam ANDI   = 6'b001100;
localparam SLTI   = 6'b001010;
localparam ORI    = 6'b001101;
localparam XORI   = 6'b001110;
localparam JALR   = 6'b001001;
localparam JR     = 6'b001000;
localparam HALT   = 6'b111111;

    reg         RegDst_Reg          ;
    reg         Jump_Reg            ;
    reg         JAL_Reg             ;
    reg         Branch_Reg          ;
    reg         NBranch_Reg         ;
    reg         MemRead_Reg         ;
    reg         MemToReg_Reg        ;
    reg [1:0]   ALUOp_Reg           ;
    reg         MemWrite_Reg        ;
    reg         ALUSrc_Reg          ;
    reg         RegWrite_Reg        ;
    reg [1:0]   ExtensionMode_Reg   ;
    reg [1:0]   TamanoFiltro_Reg    ;
    reg [1:0]   TamanoFiltroL_Reg   ;
    reg         ZeroExtend_Reg      ;
    reg         LUI_Reg             ;
    reg         JALR_Reg            ;
    reg         HALT_Reg            ;

    always @(*)
    begin : Decoder
        case(i_Instruction)
            BAS:
            if(i_Special == JALR)
            begin
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                RegDst_Reg          <=  1'b1    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b1    ;
                Branch_Reg          <=  1'b0    ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b1    ;
                HALT_Reg            <=  1'b0    ;
            end
            else if (i_Special == JR)
            begin
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b1    ;
                HALT_Reg            <=  1'b0    ;
            end
            else
            begin
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b10   ;
                RegDst_Reg          <=  1'b1    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            ADDI:
            begin
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            ANDI:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b11   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b01   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            ORI:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b11   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b01   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            SLTI:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b11   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            XORI:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b11   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b01   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            LW:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b1    ;
                MemToReg_Reg        <=  1'b1    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            LWU:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b1    ;
                MemToReg_Reg        <=  1'b1    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            LB:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b1    ;
                MemToReg_Reg        <=  1'b1    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b01   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            LBU:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b1    ;
                MemToReg_Reg        <=  1'b1    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b01   ;
                ZeroExtend_Reg      <=  1'b1    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            LH:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b1    ;
                MemToReg_Reg        <=  1'b1    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b10   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            LHU:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b1    ;
                MemToReg_Reg        <=  1'b1    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b10   ;
                ZeroExtend_Reg      <=  1'b1    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            LUI:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b1    ;
                MemToReg_Reg        <=  1'b1    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b10   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b1    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            SW:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b1    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            SB:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b1    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b01   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            SH:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b1    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b10   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            BEQ:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b1    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b01   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            BNE:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b1    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b01   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            J:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b1    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

           JAL:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b1    ;
                JAL_Reg             <=  1'b1    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end
    
            HALT:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b1    ;
            end
            
            default:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b11   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end
        endcase
    end
    
    assign  o_RegDst        =   RegDst_Reg          ;
    assign  o_Jump          =   Jump_Reg            ;
    assign  o_JAL           =   JAL_Reg             ;
    assign  o_Branch        =   Branch_Reg          ;
    assign  o_NBranch       =   NBranch_Reg         ;
    assign  o_MemRead       =   MemRead_Reg         ;
    assign  o_MemToReg      =   MemToReg_Reg        ;
    assign  o_ALUOp         =   ALUOp_Reg           ;
    assign  o_MemWrite      =   MemWrite_Reg        ;
    assign  o_ALUSrc        =   ALUSrc_Reg          ;
    assign  o_RegWrite      =   RegWrite_Reg        ;
    assign  o_ExtensionMode =   ExtensionMode_Reg   ;
    assign  o_TamanoFiltro  =   TamanoFiltro_Reg    ;
    assign  o_TamanoFiltroL =   TamanoFiltroL_Reg   ;
    assign  o_ZeroExtend    =   ZeroExtend_Reg      ;
    assign  o_LUI           =   LUI_Reg             ;
    assign  o_JALR          =   JALR_Reg            ;
    assign  o_HALT          =   HALT_Reg            ;
    
endmodule

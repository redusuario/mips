// Code your design here
`timescale 1ns / 1ps

module ID_decodificador
#(
    parameter               NB_ADDR         =   32,
    parameter               NB_INST         =   32,
    parameter               NB_OPCODE       =   6,
    parameter               NB_FUNCT        =   6,
    parameter               NB_REG          =   5,     // Longitud del campo RS,RT,RD
    parameter               NB_IMMEDIATE    =   16
)
(
    // INPUTS   
    input wire   [NB_ADDR-1:0]              i_pc,
    input wire   [NB_INST-1:0]              i_instruction,
    output wire  [NB_REG-1:0]               o_rs,
    output wire  [NB_REG-1:0]               o_rt,
    output wire  [NB_REG-1:0]               o_rd,
    output wire  [NB_FUNCT-1:0]             o_funct,
    output wire  [NB_OPCODE-1:0]            o_opcode,
    output wire  [NB_IMMEDIATE-1:0]         o_immediate,  
    output wire  [NB_INST-1:0]              o_instruction,
    output wire  [NB_ADDR-1:0]              o_pc
);

//--------------------------------------------------------------------------------    
    //PARAMETROS LOCALES
  localparam RINST_OPCODE = 6'b000000;// instrucciones de tipo R
  localparam IINST_OPCODE = 6'b001000;// instrucciones de tipo I
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
    reg  [NB_REG-1:0]               rs;
    reg  [NB_REG-1:0]               rt;
    reg  [NB_REG-1:0]               rd;
    reg  [NB_FUNCT-1:0]             funct;
    reg  [NB_OPCODE-1:0]            opcode;
    reg  [NB_IMMEDIATE-1:0]         immediate;
//--------------------------------------------------------------------------------


//R-Type
//SLL
//SRL
//SRA
//SLLV
//SRLV
//SRAV
//ADDU
//SUBU
//AND
//OR
//XOR
//NOR
//SLT
//      OPCODE      RS          RT      RD      SHAMT       FUNCT
//ADD:  000000  |   RS      |   RT  |   RD  |   00000   |   100000

//I-Type
//LB
//LH
//LW
//LWU
//LBU
//LHU
//SB
//SH
//SW
//ADDI
//ANDI
//ORI
//XORI
//LUI
//SLTI
//BEQ
//BNE
//J
//JAL
//       OPCODE      RS          RT               IMMEDIATE
//ADDI:  001000  |   RS      |   RT  |   00000  |   00000   |   000000
//       31  26   25       21 20   16 15                               0
//         6          5          5                   16 


    always @(*)
    begin

        opcode          = i_instruction[31:26];

        case(opcode)

            RINST_OPCODE:
            begin
                rs          = i_instruction[25:21];
                rt          = i_instruction[20:16];
                rd          = i_instruction[15:11];
                funct       = i_instruction[5:0];
            end

            IINST_OPCODE:
            begin
                rs          = i_instruction[25:21];
                rt          = i_instruction[20:16];
                immediate   = i_instruction[15:0];
            end
            
            default:
            begin
                rs          = 0;
                rt          = 0;
                rd          = 0;
            end
        endcase

    end

    assign o_rs          = rs;
    assign o_rt          = rt;
    assign o_rd          = rd;

    assign o_immediate   = immediate;

    assign o_funct       = funct;

    assign o_opcode      = opcode;

    assign o_instruction = i_instruction;

    assign o_pc = i_pc;

endmodule
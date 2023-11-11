`timescale 1ns / 1ps

module Control_ALU
    #(
        parameter   ANBITS          =   6   ,
        parameter   NBITSCONTROL    =   2   ,
        parameter   ALUOP           =   4   
    )
    (
        input   wire    [ANBITS-1:0]           i_Funct ,
        input   wire    [ANBITS-1:0]           i_Opcode,
        input   wire    [NBITSCONTROL-1:0]     i_ALUOp ,    
        output  wire    [ALUOP-1:0]            o_ALUOp ,
        output  wire                           o_Shamt            
    );
localparam	ADD_C	=  6'b100000;	//Suma
localparam	SUB_C	=  6'b100010;	//Resta
localparam	SUBU_C  =  6'b100011;	//Resta Unsigned
localparam	AND_C	=  6'b100100;	//And
localparam	ANDI_C  =  6'b001100;	//And Immediate
localparam	OR_C	=  6'b100101;	//Or
localparam	ORI_C	=  6'b001101;	//Or Immediate
localparam NOR_C    =  6'b100111 ;  //Nor
localparam XOR_C    =  6'b100110;   //Xor
localparam XORI_C   =  6'b001110;   //Xor Immediate
localparam	SLT_C	=  6'b101010;	//Set on Less than
localparam SLTI_C   =  6'b001010;   //Set on Less than Immediate
localparam	ADDU_C  =  6'b100001;   //Add Unsigned Word
localparam	SLL_C   =  6'b000000;   //Shift Word Left Logical
localparam SLLV_C   =  6'b000100;   //Shift Word Left Logical Variable
localparam	SRL_C   =  6'b000010 ;  //Shift Word Right Logical
localparam	SRLV_C  =  6'b000110 ;  //Shift Word Right Logical Variable
localparam	SRA_C   =  6'b000011 ;  //Shift Word Right Arithmetic
localparam	SRAV_C  =  6'b000111 ;  //Shift Word Right Arithmetic Variable

localparam	CERO   = 2'b00;
localparam	CEROUNO= 2'b01;
localparam	UNOCERO= 2'b10;
localparam	UNOUNO = 2'b11;

    reg [ALUOP-1    :0] ALUOp_Reg   ;
   
    
    always @(*)
    begin : ALUOp
            case(i_ALUOp)
                CERO :       
                                    ALUOp_Reg   <=   4'b0010    ;
                CEROUNO :        
                                    ALUOp_Reg   <=   4'b0110    ;
                UNOCERO :
                    case(i_Funct)
                        ADD_C    :   ALUOp_Reg   <=   4'b0010    ;
                        SUB_C    :   ALUOp_Reg   <=   4'b0110    ;
                        SUBU_C   :   ALUOp_Reg   <=   4'b0110    ;
                        AND_C    :   ALUOp_Reg   <=   4'b0000    ;
                        OR_C     :   ALUOp_Reg   <=   4'b0001    ;
                        NOR_C    :   ALUOp_Reg   <=   4'b1100    ;
                        XOR_C    :   ALUOp_Reg   <=   4'b1101    ;
                        SLT_C    :   ALUOp_Reg   <=   4'b0111    ;
                        ADDU_C   :   ALUOp_Reg   <=   4'b0010    ;
                        SLL_C    :   ALUOp_Reg   <=   4'b0011    ;
                        SRL_C    :   ALUOp_Reg   <=   4'b0100    ;  
                        SLLV_C   :   ALUOp_Reg   <=   4'b0011    ;
                        SRLV_C   :   ALUOp_Reg   <=   4'b0100    ;  
                        SRA_C    :   ALUOp_Reg   <=   4'b0101    ;
                        SRAV_C   :   ALUOp_Reg   <=   4'b0101    ;                         
                        default :   ALUOp_Reg   <=   -2         ;
                    endcase       
                UNOUNO :
                    case(i_Opcode)
                        SLTI_C   :   ALUOp_Reg   <=   4'b0111    ;
                        ANDI_C   :   ALUOp_Reg   <=   4'b0000    ;
                        ORI_C    :   ALUOp_Reg   <=   4'b0001    ;   
                        XORI_C   :   ALUOp_Reg   <=   4'b1101    ;                           
                        default :   ALUOp_Reg   <=   -3         ;
                    endcase       
                default:            ALUOp_Reg   <=   -1        ;
            endcase
    end
    
    assign o_ALUOp  =    ALUOp_Reg   ;
    assign o_Shamt  =   (i_Funct == SRA_C | i_Funct == SRL_C | i_Funct == SLL_C) ? 1 : 0 ;
endmodule

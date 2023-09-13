`timescale 1ns / 1ps


module ID_sign_extend
#(
    parameter               NB_INST         =   32,         // Longitud con signo
    parameter               NB_IMMED        =   16,         // Longitud sin signo
    parameter               NB_OPCODE       =   6           // OPCODE
)
(
    // INPUTS   
    input wire  [NB_IMMED-1:0]             i_immediate,
    input wire  [NB_OPCODE-1:0]            i_opcode,
    
    // OUTPUTS
    output wire [NB_INST-1:0]              o_sign_extend
);

    // LOCALPARAMETERS
    localparam          imm = 6'b001???;
    
    // OUTPUT
  assign o_sign_extend = (i_opcode == imm) ? $unsigned(i_immediate) : $signed(i_immediate);
    
endmodule
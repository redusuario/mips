`timescale 1ns / 1ps

module IE #(
    parameter   NB_OP         = 6,  
    parameter   NB_DATA       = 32,
    parameter   NB_DATA_OUT   = 32,
    parameter   NB_INST       = 32,         // Longitud de registro con signo
    parameter   NB_SELECTOR   = 2           // Longitud del selector
)
(
    input wire      [NB_DATA-1:0]      i_data_1,
    input wire      [NB_DATA-1:0]      i_data_2,
    input wire      [NB_OP-1:0]        i_code,
    output wire     [NB_DATA_OUT-1:0]  o_alu_result
);


IE_alu u_alu(
    .i_data_1(i_data_1),
    .i_data_2(i_data_2),
    .i_code(i_code),
    .o_alu_result(o_alu_result)
);

//IE_multiplexor_A u_multiplexor_A(
//    .i_decodificador_rs(),
//    .i_sign_extend(),
//    .i_selector(),
//    .o_mux()
//);


endmodule
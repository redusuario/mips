`timescale 1ns / 1ps

module EX #(
    parameter   NB_OP         = 6,  
    parameter   NB_DATA       = 32,
    parameter   NB_DATA_OUT   = 32,
    parameter   NB_INST       = 32,         // Longitud de registro con signo
    parameter   NB_SELECTOR   = 2           // Longitud del selector
)
(
    input   wire    [NB_INST-1:0]      i_pc,
    input   wire    [NB_INST-1:0]      i_sign_extend,
    input   wire    [NB_DATA-1:0]      i_data_1,
    input   wire    [NB_DATA-1:0]      i_data_2,
    input   wire    [NB_OP-1:0]        i_code,
    input   wire                       i_selector_mux_A,
    input   wire                       i_selector_mux_B,
    output  wire    [NB_DATA_OUT-1:0]  o_alu_result
);

    wire    [NB_INST-1:0]              mux_A;
    wire    [NB_INST-1:0]              mux_B;

EX_alu u_alu(
    .i_data_1(mux_A),
    .i_data_2(mux_B),
    .i_code(i_code),
    .o_alu_result(o_alu_result)
);

EX_multiplexor_A u_multiplexor_A(
    .i_pc(i_pc),
    .i_register_file_data(i_data_1),
    .i_selector(i_selector_mux_A),
    .o_mux(mux_A)
);

EX_multiplexor_B u_multiplexor_B(
    .i_sign_extend(i_sign_extend),
    .i_register_file_data(i_data_2),
    .i_selector(i_selector_mux_B),
    .o_mux(mux_B)
);


endmodule
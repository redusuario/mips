`timescale 1ns / 1ps

module WB #(
    parameter               NB_INST         =   32,         // Longitud de registro con signo
    parameter               NB_SELECTOR     =   2           // Longitud del selecto
)
(
    // INPUTS   
    input   wire    [NB_INST-1:0]      i_data_alu,
    input   wire    [NB_INST-1:0]      i_data_mem,
    input   wire                       i_selector,
    output  wire    [NB_INST-1:0]      o_mux
);


WB_multiplexor u_wb_multiplexor(
	.i_data_alu(i_data_alu), 
	.i_data_mem(i_data_mem),
	.i_selector(i_selector),
	.o_mux(o_mux)
);


endmodule
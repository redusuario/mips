`timescale 1ns / 1ps

module IF #(
	parameter NB_ADDR 	= 32,
	parameter NBITS 	= 32,
	parameter NB_INST   = 32
)
(
	input 		wire 						i_clk,
	input 		wire 						i_enable,
	input 		wire 						i_reset,
	input 		wire 	[NB_ADDR - 1:0] 	i_pc,

	input  		wire                        i_write,
	input  		wire 	[NB_INST - 1:0]     i_instruction,
	input  		wire 	[NB_ADDR - 1:0]     i_address,
	output 		wire 	[NB_INST - 1:0]     o_instruction,

	output 		wire 	[NB_ADDR - 1:0]	   	o_pc 
);

wire 	[NB_ADDR - 1:0] 	pc;

IF_pc u_pc(
	.i_clk(i_clk), 
	.i_enable(i_enable),
	.i_reset(i_reset),
	.i_pc(i_pc), 
	.o_pc(pc) 
);

IF_memoria_instrucciones u_memoria_instrucciones
(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_pc(pc),    
    .i_write(i_write),
    .i_instruction(i_instruction),
    .i_address(i_address),
    .o_instruction(o_instruction)
);

IF_inc_pc u_inc_pc
(
	.i_pc(pc), 
	.o_pc(o_pc) 
);


endmodule
`timescale 1ns / 1ps

module top_mips #(
	parameter 		NB_ADDR 		= 	32,
	parameter 		NBITS 			= 	32,
	parameter 		NB_INST   		= 	32,
    parameter       NB_OPCODE       =   6,
    parameter       NB_FUNCT        =   6,
    parameter       NB_REG          =   5,     // Longitud del campo RS,RT,RD
    parameter       NB_IMMEDIATE    =   16,
    parameter       NB_DATA         =   32,
    parameter       SIZE_REG        =   32,
    parameter       NB_IMMED        =   16,     // Longitud sin signo
	parameter   	NB_OP         	= 	6,  
    parameter   	NB_DATA_OUT   	= 	32,
    parameter   	NB_SELECTOR   	= 	2       // Longitud del selector

)
(

	//----------------------------------------------------
	// IF - INPUT
	//----------------------------------------------------

	input 		wire 						i_clk,
	input 		wire 						i_enable,
	input 		wire 						i_reset,
	input 		wire 	[NB_ADDR - 1:0] 	i_pc,
	input  		wire                        i_write,
	input  		wire 	[NB_INST - 1:0]     i_instruction,
	input  		wire 	[NB_ADDR - 1:0]     i_address,

	//----------------------------------------------------
	// ID - INPUT
	//----------------------------------------------------

    //input wire  [NB_REG-1:0]              	i_address_data,
    //input wire                            	i_write_debug_reg_file,
    //input wire 								i_write_data,
 
    //input wire  [NB_REG-1:0]                i_address_write_debug,
    //input wire  [NB_DATA-1:0]               i_write_data_debug,
	//----------------------------------------------------
	// EX - INPUT
	//----------------------------------------------------

	//----------------------------------------------------
	// WB - INPUT
	//----------------------------------------------------
    input   wire    [NB_INST-1:0]      i_data_mem,



	//----------------------------------------------------
	// IF - OUTPUT
	//----------------------------------------------------


	//----------------------------------------------------
	// ID - OUTPUT
	//----------------------------------------------------

	output wire  [NB_INST-1:0]       		o_instruction,/////////////////////////////////////////
    output wire  [NB_ADDR-1:0]              o_pc,//////////////////////////////////////////////////
    output wire [NB_DATA-1:0]               o_data_read_debug

	//----------------------------------------------------
	// EX - OUTPUT
	//----------------------------------------------------


);


//--------------------------------------------------------------------------------------

	wire 	[NB_ADDR - 1:0]	   	o_if_pc;
	wire 	[NB_INST - 1:0]     o_if_instruction;
	wire  	[NB_INST-1:0]       sign_extend;
	wire  	[NB_DATA-1:0]       data_1;
    wire  	[NB_DATA-1:0]       data_2;
	wire  	[NB_FUNCT-1:0]      funct;
    wire                       	signal_control_mult_A;
    wire                       	signal_control_mult_B;
    wire    [NB_DATA_OUT-1:0]  	alu_result;
    wire                        signal_control_mult_wb;
    wire    [NB_INST-1:0]       o_mux_wb;
    wire    [NB_REG-1:0]        rd;
    wire  [NB_REG-1:0]                o_address_read_debug;

//--------------------------------------------------------------------------------------

IF u_IF(
	.i_clk(i_clk),
	.i_enable(i_enable),
	.i_reset(i_reset),
	.i_pc(i_pc),
	.i_write(i_write),
	.i_instruction(i_instruction),
	.i_address(i_address),
	.o_instruction(o_if_instruction),
	.o_pc(o_if_pc)
);
//rd â†? rs + rt

ID u_ID(
	.i_clk(i_clk),
	.i_enable(i_enable),
	.i_reset(i_reset),
	.i_data_input(o_mux_wb),
	.i_address_data(o_address_read_debug),
	//.i_write_debug_reg_file(i_write_debug_reg_file),
	//.i_write_data(i_write_data),
	.i_pc(o_if_pc),
	.i_instruction(o_if_instruction),
	.i_address_read_debug(o_address_read_debug),
	//.i_address_write_debug(i_address_write_debug),/////////////////////////////////////////////
	//.i_write_data_debug(i_write_data_debug),///////////////////////////////////////////////////
	.o_funct(funct),
	.o_instruction(o_instruction),
	.o_pc(o_pc),
	.o_data_1(data_1),
	.o_data_2(data_2),
	.o_rd(rd),
	.o_data_read_debug(o_data_read_debug),
	.o_sign_extend(sign_extend),
	.o_signal_control_mult_A(signal_control_mult_A),
	.o_signal_control_mult_B(signal_control_mult_B),
	.o_signal_control_mult_wb(signal_control_mult_wb)
);

EX u_EX(
    .i_pc(i_pc),
    .i_sign_extend(sign_extend),
    .i_data_1(data_1),
    .i_data_2(data_2),
    .i_code(funct),
    .i_selector_mux_A(signal_control_mult_A),
    .i_selector_mux_B(signal_control_mult_B),
    .o_alu_result(alu_result)
);

WB u_WB(
	.i_data_alu(alu_result), 
	.i_data_mem(i_data_mem),
	.i_selector(signal_control_mult_wb),
	.o_mux(o_mux_wb)
);

ID_EX I_ID_EX(
	.i_rd(rd), 
	.i_clk(i_clk),
	.i_reset (i_reset),
	.i_step(i_enable),
	.o_address_read_debug (o_address_read_debug)
);


endmodule
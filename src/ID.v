`timescale 1ns / 1ps

module ID #(
    parameter               NB_ADDR         =   32,
    parameter               NB_INST         =   32,
    parameter               NB_OPCODE       =   6,
    parameter               NB_FUNCT        =   6,
    parameter               NB_REG          =   5,     // Longitud del campo RS,RT,RD
    parameter               NB_IMMEDIATE    =   16,
    parameter               NB_DATA         =   32,
    parameter               SIZE_REG        =   32,
    parameter               NB_IMMED        =   16         // Longitud sin signo
)
(
    // INPUTS
    input wire                            	i_clk,/////////////////////////////////////////////////
    input wire  [NB_DATA-1:0]             	i_data_input,//////////////////////////////////////////
    input wire  [NB_REG-1:0]              	i_address_data,////////////////////////////////////////
    //input wire                            	i_write_debug_reg_file,////////////////////////////////
    //input wire                              i_write_data,//////////////////////////////////////////
    input wire   [NB_ADDR-1:0]              i_pc,//////////////////////////////////////////////////
    input wire   [NB_INST-1:0]              i_instruction,/////////////////////////////////////////
    input wire  [NB_REG-1:0]                i_address_read_debug,//////////////////////////////////
    //input wire  [NB_REG-1:0]                i_address_write_debug,
    //input wire  [NB_DATA-1:0]               i_write_data_debug,
	output wire  [NB_FUNCT-1:0]      		o_funct,///////////////////////////////////////////////
	output wire  [NB_INST-1:0]       		o_instruction,/////////////////////////////////////////
    output wire  [NB_ADDR-1:0]              o_pc,//////////////////////////////////////////////////
    output wire [NB_DATA-1:0]             	o_data_1,//////////////////////////////////////////////
    output wire [NB_DATA-1:0]             	o_data_2,//////////////////////////////////////////////
    output wire  [NB_REG-1:0]               o_rd,
    output wire [NB_DATA-1:0]               o_data_read_debug,/////////////////////////////////////
    output wire [NB_INST-1:0]               o_sign_extend,/////////////////////////////////////////
    output wire                             o_signal_control_mult_A,///////////////////////////////
    output wire                             o_signal_control_mult_B,///////////////////////////////
    output wire                             o_signal_control_mult_wb //////////////////
);

    wire  [NB_REG-1:0]        		rs;
	wire  [NB_REG-1:0]        	rt;
	wire  [NB_REG-1:0]        		rd;
    wire  [NB_IMMEDIATE-1:0]        immediate;
    wire  [NB_OPCODE-1:0]           opcode;
    wire                            signal_control_write_data_reg_file;

ID_decodificador u_decodificador(
	.i_pc(i_pc),
	.i_instruction(i_instruction),
	.o_rs(rs),
	.o_rt(rt),
	.o_rd(o_rd),
	.o_funct(o_funct),
    .o_opcode(opcode),
	.o_immediate(immediate),
	.o_instruction(o_instruction),
	.o_pc(o_pc)
);

ID_register_file u_register_file(
    .i_clk(i_clk), 
    .i_address_1(rs),
    .i_address_2(rt),    
    .i_data_input(i_data_input),
    .i_address_data(i_address_data),
    //.i_write_debug_reg_file(i_write_debug_reg_file),
    .i_write_data(signal_control_write_data_reg_file),
    .i_address_read_debug(i_address_read_debug),
    //.i_address_write_debug(i_address_write_debug),
    //.i_write_data_debug(i_write_data_debug),
    .o_data_1(o_data_1),
    .o_data_2(o_data_2),
    .o_data_read_debug(o_data_read_debug)
);

ID_sign_extend u_sign_extend(
    .i_immediate(immediate),
    .i_opcode(opcode),
    .o_sign_extend(o_sign_extend)
);


ID_control u_control
(
    .i_opcode(opcode),
    .o_signal_control_mult_A(o_signal_control_mult_A),
    .o_signal_control_mult_B(o_signal_control_mult_B),
    .o_signal_control_mult_wb(o_signal_control_mult_wb),
    .o_signal_control_write_data_reg_file(signal_control_write_data_reg_file)
);



endmodule
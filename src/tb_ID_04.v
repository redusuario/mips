// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_ID();


    localparam               NB_ADDR         =   32;
    localparam               NB_INST         =   32;
    localparam               NB_OPCODE       =   6;
    localparam               NB_FUNCT        =   6;
    localparam               NB_REG          =   5;     // Longitud del campo RS,RT,RD
    localparam               NB_IMMEDIATE    =   16;
    localparam               NB_DATA         =   32;
    localparam               SIZE_REG        =   32;


    localparam ADD             = 32'b000000_00010_00001_00000_00000_100000;
 

    reg                              i_clk;////////////////////////////////////////////////////////
    reg   [NB_DATA-1:0]              i_data_input;/////////////////////////////////////////////////
    reg   [NB_REG-1:0]               i_address_data;///////////////////////////////////////////////
    reg                              i_write_debug_reg_file;


    reg   [NB_ADDR-1:0]              i_pc;
    reg   [NB_INST-1:0]              i_instruction;
    reg  [NB_REG-1:0]                i_address_read_debug;




    wire  [NB_FUNCT-1:0]             o_funct;

    wire  [NB_INST-1:0]              o_instruction;
    wire  [NB_ADDR-1:0]              o_pc;

    reg  [NB_REG-1:0]                i_address_write_debug;
    reg  [NB_DATA-1:0]               i_write_data_debug;
    wire  [NB_DATA-1:0]              o_data_1;
    wire  [NB_DATA-1:0]              o_data_2;
    wire  [NB_REG-1:0]               o_rt;
    wire  [NB_INST-1:0]              o_sign_extend;

    wire                             o_signal_control_mult_A;
    wire                             o_signal_control_mult_B;
    wire                             o_signal_control_mult_wb;
    wire [NB_DATA-1:0]               o_data_read_debug;

ID u_ID
(
    .i_clk(i_clk),
    .i_data_input(i_data_input),
    .i_address_data(i_address_data),
    .i_write_debug_reg_file(i_write_debug_reg_file),
    .i_pc(i_pc),
    .i_instruction(i_instruction),
    .i_address_read_debug(i_address_read_debug),
    .i_address_write_debug(i_address_write_debug),
    .i_write_data_debug(i_write_data_debug),
    .o_funct(o_funct),

    .o_instruction(o_instruction),
    .o_pc(o_pc),

    .o_data_1(o_data_1),
    .o_data_2(o_data_2),
    .o_rd(o_rd),
    .o_data_read_debug(o_data_read_debug),

    .o_sign_extend(o_sign_extend),

    .o_signal_control_mult_A(o_signal_control_mult_A),
    .o_signal_control_mult_B(o_signal_control_mult_B),
    .o_signal_control_mult_wb(o_signal_control_mult_wb)

);


    initial begin
      
        $dumpfile("dump.vcd"); $dumpvars;

        #20
        i_clk = 1'b0;
        #20
        i_pc = 32'b1;
        i_write_debug_reg_file = 1'b1;
        #20
        i_address_write_debug = 32'b01;//rs
        i_write_data_debug    = 32'b111;
        #20
        i_address_write_debug = 32'b10;//rt
        i_write_data_debug    = 32'b1000;
        #20
        i_address_write_debug = 32'b11;//rd
        i_write_data_debug    = 32'b0;
        #20  
        //rd ← rs + rt
      
      
        //      OPCODE      RS          RT      RD      SHAMT       FUNCT
        //ADD:  000000  |   RS      |   RT  |   RD  |   00000   |   100000
        //      000000     00001      00010   00011     00000       100000


        i_instruction=32'b000000_00001_00010_00011_00000_100000;

        #40
        i_address_read_debug = 5'b11;//rd
        #100
        
        $display("############# Test OK ############");
        $finish();
    end
  
      // CLOCK_GENERATION
    always #10 i_clk = ~i_clk;

endmodule
// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples

// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_top_mips();

    localparam       NB_ADDR         =   32;
    localparam       NBITS           =   32;
    localparam       NB_INST         =   32;
    localparam       NB_OPCODE       =   6;
    localparam       NB_FUNCT        =   6;
    localparam       NB_REG          =   5;     // Longitud del campo RS,RT,RD
    localparam       NB_IMMEDIATE    =   16;
    localparam       NB_DATA         =   32;
    localparam       SIZE_REG        =   32;
    localparam       NB_IMMED        =   16;     // Longitud sin signo
    localparam       NB_OP           =   6;  
    localparam       NB_DATA_OUT     =   32;
    localparam       NB_SELECTOR     =   2;      // Longitud del selector


    //localparam ADD             = 32'b000000_00001_00010_00110_00000_100001;

    //localparam HALT             = 32'b0;

    //      OPCODE      RS          RT      RD      SHAMT       FUNCT
    //ADD:  000000  |   RS      |   RT  |   RD  |   00000   |   100000
    //      000000     00001      00010   00100     00000       100000


    //----------------------------------------------------
    // IF - INPUT
    //----------------------------------------------------

    reg                         i_clk;
    reg                         i_enable;
    reg                         i_reset;
    reg     [NB_ADDR - 1:0]     i_pc;
    reg                         i_write;
    reg     [NB_INST - 1:0]     i_instruction;
    reg     [NB_ADDR - 1:0]     i_address;

    //----------------------------------------------------
    // ID - INPUT
    //----------------------------------------------------


    reg     [NB_REG-1:0]        i_address_data;
    reg                         i_write_debug_reg_file;
    //reg                         i_write_data;
    reg  [NB_REG-1:0]           i_address_read_debug;
    reg  [NB_REG-1:0]           i_address_write_debug;
    reg  [NB_DATA-1:0]          i_write_data_debug;
    //----------------------------------------------------
    // EX - INPUT
    //----------------------------------------------------
    //----------------------------------------------------
    // WB - INPUT
    //----------------------------------------------------
    reg    [NB_INST-1:0]      i_data_mem;
    //----------------------------------------------------
    // IF - OUTPUT
    //----------------------------------------------------


    //----------------------------------------------------
    // ID - OUTPUT
    //----------------------------------------------------

    wire    [NB_INST-1:0]       o_instruction;
    wire    [NB_ADDR-1:0]       o_pc;
    wire    [NB_DATA-1:0]       o_data_read_debug;
    //----------------------------------------------------
    // EX - OUTPUT
    //----------------------------------------------------



top_mips u_top_mips
(
    .i_clk(i_clk),
    .i_enable(i_enable),
    .i_reset(i_reset),
    .i_pc(i_pc),
    .i_write(i_write),
    .i_instruction(i_instruction),
    .i_address(i_address),
    .i_address_data(i_address_data),
    .i_write_debug_reg_file(i_write_debug_reg_file),
    //.i_write_data(i_write_data),
    .i_address_read_debug(i_address_read_debug),
    .i_address_write_debug(i_address_write_debug),
    .i_write_data_debug(i_write_data_debug),
    .i_data_mem(i_data_mem),
    .o_instruction(o_instruction),
    .o_pc(o_pc),
    .o_data_read_debug(o_data_read_debug)
);

    initial begin
      
        $dumpfile("dump.vcd"); $dumpvars;
        i_reset = 1;

        #20
        i_clk = 1'b0;
        i_reset = 0;

        #20
        i_enable = 1'b1;

        #20
        //      OPCODE      RS          RT      RD      SHAMT       FUNCT
        //ADD:  000000  |   RS      |   RT  |   RD  |   00000   |   100000
        //      000000     00001      00011   00010     00000       100000

        i_write =  1'b1;
        i_write_debug_reg_file =  1'b1;
        //i_write_data =  1'b1;
        #20
        i_address_write_debug = 5'b1;  
        #20
        i_write_data_debug = 32'b111;
        #20
        i_address_write_debug = 5'b10;  
        #20
        i_write_data_debug = 32'b1000;
        #20
        i_address = 32'b1;
        #20
        i_instruction = 32'b000000_00001_00010_00011_00000_100000;
        #20
        i_pc = 32'b1;
        #100
        i_address_read_debug = 5'b11;
        #100

        $display("############# Test OK ############");
        $finish();
    end
  
      // CLOCK_GENERATION
    always #10 i_clk = ~i_clk;

endmodule

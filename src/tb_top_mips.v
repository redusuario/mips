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

    reg     [NB_DATA-1:0]       i_data_input;
    reg     [NB_REG-1:0]        i_address_data;
    reg                         i_id_write;


    //----------------------------------------------------
    // EX - INPUT
    //----------------------------------------------------


    //----------------------------------------------------
    // IF - OUTPUT
    //----------------------------------------------------


    //----------------------------------------------------
    // ID - OUTPUT
    //----------------------------------------------------

    wire    [NB_INST-1:0]       o_instruction;
    wire    [NB_ADDR-1:0]       o_pc;

    //----------------------------------------------------
    // EX - OUTPUT
    //----------------------------------------------------
    wire    [NB_DATA_OUT-1:0]   o_alu_result;


top_mips u_top_mips
(
    .i_clk(i_clk),
    .i_enable(i_enable),
    .i_reset(i_reset),
    .i_pc(i_pc),
    .i_write(i_write),
    .i_instruction(i_instruction),
    .i_address(i_address),
    .i_data_input(i_data_input),
    .i_address_data(i_address_data),
    .i_id_write(i_id_write),
    .o_instruction(o_instruction),
    .o_pc(o_pc),
    .o_alu_result(o_alu_result)
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
        i_id_write =  1'b1;
        #20

        i_address_data = 32'b1;
        i_data_input   = 32'b0001;

        #20
        i_address_data = 32'b10;
        i_data_input   = 32'b00010;

        #20

        i_address = 32'b1;
        i_instruction = 32'b000000_00001_00000_00010_00000_100000;
        #20
        i_pc = 32'b1;
        #100
        $display("############# Test OK ############");
        $finish();
    end
  
      // CLOCK_GENERATION
    always #10 i_clk = ~i_clk;

endmodule
